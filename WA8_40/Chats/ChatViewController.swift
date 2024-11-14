import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    private let chatView = ChatView()
    private let contact: Contact
    private let db = Firestore.firestore()
    private var messages: [Message] = []
    private let pageSize = 20
    private var lastDocument: DocumentSnapshot?
    private var isLoadingMessages = false
    private var canLoadMoreMessages = true
    private lazy var chatRoomId: String = {
        guard let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else { return "" }
        return [currentUserEmail, contact.email.lowercased()].sorted().joined(separator: "_")
    }()
    
    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        listenToMessages()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        chatView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
      
    }
    
    private func setupUI() {
        title = contact.name
    }
    
    private func setupTableView() {
        chatView.tableView.dataSource = self
        chatView.tableView.delegate = self
        chatView.tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        chatView.tableView.separatorStyle = .none
        chatView.tableView.backgroundColor = .white
    }
    
    private func listenToMessages() {
        guard let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else {
            return 
        }
        
        let query = db.collection("chatRooms")
            .document(chatRoomId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
        
        query.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                self.messages = []
                DispatchQueue.main.async {
                    self.chatView.tableView.reloadData()
                }
                return
            }
        
            
            let newMessages = documents.compactMap { document -> Message? in
                do {
                    let message = try document.data(as: Message.self)
                    return message
                } catch {
                    print("Failed to parse message: \(error)")
                    return nil
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.messages = newMessages
                self.chatView.tableView.reloadData()
                if !self.messages.isEmpty {
                    self.scrollToBottom()
                }
            }
        }
    }

    private func loadMoreMessages() {
        guard !isLoadingMessages,
            canLoadMoreMessages,
            let lastDocument = lastDocument,
            let currentUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        
        isLoadingMessages = true
        
        let query = db.collection("chatRooms")
            .document(chatRoomId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .limit(to: pageSize)
            .start(afterDocument: lastDocument)
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            self.isLoadingMessages = false
            
            if let error = error {
                print("Failed to load more messages: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                self.canLoadMoreMessages = false
                return
            }
            
            self.lastDocument = documents.last
            
            let moreMessages = documents.compactMap { document -> Message? in
                try? document.data(as: Message.self)
            }
            
            self.messages.append(contentsOf: moreMessages)
            
            DispatchQueue.main.async {
                self.chatView.tableView.reloadData()
            }
        }
    }

    private func updateMessageStatus() {
        guard let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else { return }
        
        // update contact's unread status
        let contactRef = db.collection("users")
            .document(currentUserEmail)
            .collection("contacts")
            .document(contact.email.lowercased())
        
        contactRef.updateData([
            "hasUnreadMessages": false
        ]) { error in
            if let error = error {
                print("Error updating message status: \(error)")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateMessageStatus()
    }

    private func updateLastMessage(_ message: Message) {
        guard let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else { return }
        // Get curr user name
        let currentUserName = Auth.auth().currentUser?.displayName ?? "Unknown"
        let batch = db.batch()
    
        
        // Update the sender's contact list
        let senderContactRef = db.collection("users")
            .document(currentUserEmail)
            .collection("contacts")
            .document(self.contact.email.lowercased())
        
        // Update the recipient's contact list
        let receiverContactRef = db.collection("users")
            .document(self.contact.email.lowercased())
            .collection("contacts")
            .document(currentUserEmail)
        


        // Update the sender's contact data
        let senderData: [String: Any] = [
            "name": self.contact.name,
            "email": self.contact.email.lowercased(),
            "lastMessage": message.content,
            "lastMessageTime": message.timestamp,
            "hasUnreadMessages": false
        ]
        
        // Update the recipient's contact data
        let receiverData: [String: Any] = [
            "name": Auth.auth().currentUser?.displayName ?? "Unknown",
            "email": currentUserEmail,
            "lastMessage": message.content,
            "lastMessageTime": message.timestamp,
            "hasUnreadMessages": true  // Set receiver's unread status to true
        ]
        
        batch.setData(senderData, forDocument: senderContactRef, merge: true)
        batch.setData(receiverData, forDocument: receiverContactRef, merge: true)
        
        batch.commit { [weak self] error in
            if let error = error {
                print("Failed to update last message: \(error.localizedDescription)")
                self?.showAlert(title: "Error", message: "Failed to update contact list")
            } else {
                print("Both contact lists updated successfully")
                print("sender updated: \(currentUserEmail) -> \(self?.contact.email.lowercased() ?? "")")
                print("receiver updated: \(self?.contact.email.lowercased() ?? "") -> \(currentUserEmail)")
            }
        }
    }
        
    @objc private func sendMessage() {
        guard let messageText = chatView.messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            !messageText.isEmpty,
            let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else {
            print("Failed to send message: message is empty or user is not logged in")
            showAlert(title: "Error", message: "Message cannot be empty or user is not logged in")
            return
        }
        
        let message = Message(senderId: currentUserEmail, receiverId: contact.email.lowercased(), content: messageText)
        
        chatView.messageTextField.text = ""
        
        do {
            try db.collection("chatRooms")
                .document(chatRoomId)
                .collection("messages")
                .addDocument(from: message) { [weak self] error in
                    if let error = error {
                        print("Failed to send message: \(error.localizedDescription)")
                        self?.showAlert(title: "Error", message: "Failed to send message")
                    } else {
                        print("Message sent successfully")
                        self?.updateLastMessage(message)
                    }
                }
        } catch {
            print("Message encoding failed: \(error)")
            showAlert(title: "Error", message: "Message encoding failed")
        }
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.chatView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.chatView.transform = .identity
        }
    }
    



    // Add in ChatViewController
    private func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }

    private func hideLoadingIndicator() {
        navigationItem.rightBarButtonItem = nil
    }

    private func handleError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "confirm", style: .default))
        present(alert, animated: true)
    }
        

    
    func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let lastIndex = messages.count - 1
        let indexPath = IndexPath(row: lastIndex, section: 0)
        chatView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < messages.count else {
            return UITableViewCell() // Return an empty cell as a fallback
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        let isFromCurrentUser = message.senderId.lowercased() == Auth.auth().currentUser?.email?.lowercased()
        
        cell.configure(with: message, isFromCurrentUser: isFromCurrentUser)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > 0 && position > (scrollView.contentSize.height - scrollView.frame.size.height - 100) {
            loadMoreMessages()
        }
    }
}
