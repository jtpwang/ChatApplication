import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate, FriendsTableViewControllerDelegate {
   
    let mainScreenView = MainScreenView()
    let tableViewContacts = UITableView()
    let db = Firestore.firestore()
    
    var contactsList: [Contact] = []
    var friends: [Contact] = []
    
    weak var friendsTableVC: FriendsTableViewController?
    
    override func loadView() {
        view = mainScreenView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat room"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Setup TableView
        mainScreenView.tableViewContacts.dataSource = self
        mainScreenView.tableViewContacts.delegate = self
                
        // Setup floating button
        mainScreenView.floatingButtonAddChat.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        view.bringSubviewToFront(mainScreenView.floatingButtonAddChat)
        // Setup logout button
        setupRightBarButton(isLoggedin: true)
        view.bringSubviewToFront(mainScreenView.floatingButtonAddChat)
        loadContacts()
    }
    
    //MARK: save friend to Firestore - collection: users, document: userEmail
    func saveFriendToFirestore(friend: Contact) {
      let userEmail = "current_user_email" // Replace with actual current user email
      let collectionContacts = db.collection("users").document(userEmail).collection("contacts")
      
      do {
          try collectionContacts.addDocument(from: friend) { error in
              if let error = error {
                  print("Error saving friend to Firestore: \(error.localizedDescription)")
              } else {
                  print("Friend successfully saved to Firestore.")
              }
          }
      } catch {
          print("Error encoding friend data for Firestore: \(error)")
      }
    }
    
    func loadFriendsFirestore() {
        let userEmail = "current_user_email"
        let collectionContacts = db.collection("users").document(userEmail).collection("contacts")
        collectionContacts.whereField("email", isEqualTo: userEmail).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error loading friends from Firestore: \(error.localizedDescription)")
            } else {
                self.friends = snapshot?.documents.compactMap { document in
                    try? document.data(as: Contact.self)
                } ?? []
                
                DispatchQueue.main.async {
                    self.tableViewContacts.reloadData()
                }
            }
        }
    }
    
    @objc func floatingButtonTapped() {
        let friendsVC = FriendsTableViewController()
        friendsVC.delegate = self
        friendsVC.modalPresentationStyle = .pageSheet
        
        if let sheet = friendsVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(friendsVC, animated: true)
    }
    
    private func loadContacts() {
        guard let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else { return }

        // Listen to the current user's contact list
        db.collection("users")
            .document(currentUserEmail)
            .collection("contacts")
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error loading contacts: \(error)")
                    return
                }
                
                self?.contactsList = snapshot?.documents.compactMap { document -> Contact? in
                    do {
                        let contact = try document.data(as: Contact.self)
                        // Only return contacts with the last message
                        if contact.lastMessage != nil && contact.lastMessageTime != nil {
                            return contact
                        }
                        return nil
                    } catch {
                        print("Error decoding contact: \(error)")
                        return nil
                    }
                } ?? []
                
                // Sort by last message
                self?.contactsList.sort { (contact1, contact2) -> Bool in
                    guard let time1 = contact1.lastMessageTime,
                            let time2 = contact2.lastMessageTime else {
                        return false
                    }
                    return time1 > time2
                }
                
                DispatchQueue.main.async {
                    self?.mainScreenView.tableViewContacts.reloadData()
                }
            }
        }

    func didSelectFriend(_ contact: Contact) {
        let chatVC = ChatViewController(contact: contact)
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

