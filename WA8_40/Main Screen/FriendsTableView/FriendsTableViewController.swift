import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol FriendsTableViewControllerDelegate: AnyObject {
    func didSelectFriend(_ contact: Contact)
}

class FriendsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var friends: [Contact] = []
    weak var delegate: FriendsTableViewControllerDelegate?
    let db = Firestore.firestore()
    
    private let friendTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        setupTableView()
        loadAllUsers()
    }
    
    private func setupTableView() {
        friendTableView.dataSource = self
        friendTableView.delegate = self
        friendTableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "friendscell")
        view.addSubview(friendTableView)
        friendTableView.frame = view.bounds
    }
    
    private func loadAllUsers() {
        guard let currentUserEmail = Auth.auth().currentUser?.email?.lowercased() else { return }
        
        // Get all users but exclude current user and users who are already contacts
        db.collection("users").addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error loading users: \(error)")
                return
            }
            
            // Get the current user’s contact list
            self?.db.collection("users")
                .document(currentUserEmail)
                .collection("contacts")
                .getDocuments { (contactsSnapshot, contactsError) in
                    if let contactsError = contactsError {
                        print("Error loading contacts: \(contactsError)")
                        return
                    }
                    
                    // Get the email list of existing contacts
                    let existingContactEmails = contactsSnapshot?.documents.compactMap { doc -> String? in
                        if let contact = try? doc.data(as: Contact.self) {
                            return contact.email.lowercased()
                        }
                        return nil
                    } ?? []
                    
                    // Filter the user list to exclude current users and existing contacts
                    self?.friends = snapshot?.documents.compactMap { document -> Contact? in
                        do {
                            let contact = try document.data(as: Contact.self)
                            let contactEmail = contact.email.lowercased()
                            
                            // Exclude current user and existing contacts
                            if contactEmail != currentUserEmail && !existingContactEmails.contains(contactEmail) {
                                return contact
                            }
                            return nil
                        } catch {
                            print("Error decoding contact: \(error)")
                            return nil
                        }
                    } ?? []
                    
                    DispatchQueue.main.async {
                        self?.friendTableView.reloadData()
                    }
                }
        }
    }
    
    // TableView DataSource & Delegate methods...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendscell", for: indexPath) as! FriendsTableViewCell
        let friend = friends[indexPath.row]
        cell.configure(with: friend)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFriend = friends[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didSelectFriend(selectedFriend)
        }
    }
}
