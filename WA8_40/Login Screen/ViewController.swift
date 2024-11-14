import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    let loginView = LoginScreenView()
    let mainScreen = MainScreenView()
    
    var contactsList = [Contact]()
    var handleAuth: AuthStateDidChangeListenerHandle?
    var currentUser:FirebaseAuth.User?
    let childProgressView = ProgressSpinnerViewController()
    
    let database = Firestore.firestore()
    
    override func loadView() {
        view = loginView
    }

    //MARK: viewWillAppear, Lifecycle method where handle logic before the screen is loaded
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        //MARK: handleAuth is a authentication state change listener, used for tracking whether any user is signed in
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                // do nothing
            } else {
                self.currentUser = user
                
                //MARK: Observe Firestore database to display the contacts list...
                self.database.collection("users")
                    .document((self.currentUser?.email)!)
                    .collection("contacts")
                    .addSnapshotListener(includeMetadataChanges: false, listener: {querySnapshot, error in
                                                
                        if let documents = querySnapshot?.documents{
                            self.contactsList.removeAll()
                            for document in documents{
                                do{
                                    let contact  = try document.data(as: Contact.self)
                                    self.contactsList.append(contact)
                                }catch{
                                    print(error)
                                }
                            }
                            self.contactsList.sort(by: {$0.name < $1.name})
                            print(self.contactsList)
                            //self.mainScreen.tableViewContacts.reloadData()
                            // MARK: modify here
                           if let mainScreenController = self.navigationController?.topViewController as? MainScreenController {
                               mainScreenController.contactsList = self.contactsList
                               //mainScreenController.tableViewContacts.reloadData()
                               self.mainScreen.tableViewContacts.reloadData()
                           }
                        }
                    })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat Login"
        
        // Check if token exists in UserDefaults
        let defaults = UserDefaults.standard
        
        if let savedToken = defaults.string(forKey: "sessionToken") {
            // If token is found, set it to User.token and navigate to the main screen
            UserToken.token = savedToken
            print("User is already logged in with token: \(savedToken)")
            
            let mainScreenController = MainScreenController()
            self.navigationController?.pushViewController(mainScreenController, animated: false)
            
        } else {
            // Setup the sign-up and login buttons if not logged in
            loginView.signUpButon.addTarget(self, action: #selector(onSignUpBarButtonTapped), for: .touchUpInside)
            loginView.loginButton.addTarget(self, action: #selector(onLoginUpBarButtonTapped), for: .touchUpInside)
        }
    }
    
    //MARK: viewWillDisappear, Lifecyccle where handle the logic right before the screen disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handleAuth!)
    }
}

