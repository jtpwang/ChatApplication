import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

extension RegisterScreenController{
    func registerNewAccount(){
        //MARK: display the progress indicator...
        self.showActivityIndicator()
        
        //MARK: create a Firebase user with email and password...
        if let name = registerView.textFieldName.text,
           let email = registerView.textFieldEmail.text,
           let password = registerView.textFieldPassword.text{
            //Validations....
            Auth.auth().createUser(withEmail: email, password: password, completion: {result, error in
                if error == nil{
                    //MARK: the user creation is successful...
                    let friend = Contact(name: name, email: email)
                    self.setNameOfTheUserInFirebaseAuth(name: name)
                    self.saveFriendToFirestore(friend: friend)
                }else{
                    //MARK: there is a error creating the user...
                    print(error)
                }
            })
        }
    }
    
    //MARK: We set the name of the user after we create the account...
    func setNameOfTheUserInFirebaseAuth(name: String){
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges(completion: {(error) in
            if error == nil{
                //MARK: hide the progress indicator...
                self.hideActivityIndicator()

                //MARK: the profile update is successful...
                self.navigationController?.popViewController(animated: true)
            }else{
                //MARK: there was an error updating the profile...
                print("Error occured: \(String(describing: error))")
            }
        })
    }
    
    //MARK: logic to add a contact to Firestore...
    func saveFriendToFirestore(friend: Contact) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        
        // Save user information to the users collection
        let userRef = db.collection("users").document(friend.email)
        
        do {
            try userRef.setData(from: friend) { error in
                if let error = error {
                    print("Error saving user to Firestore: \(error.localizedDescription)")
                } else {
                    print("User successfully saved to Firestore.")
                    
                    // Create empty initial contact data
                    let initialContactData: [String: Any] = [
                        "name": friend.name,
                        "email": friend.email,
                        "lastMessage": "",
                        "lastMessageTime": Date()
                    ]
                    
                    // Create a contact collection for new users
                    let contactsRef = db.collection("users")
                        .document(friend.email)
                        .collection("contacts")
                    
                    // Add an empty contact document
                    contactsRef.document().setData(initialContactData) { error in
                        if let error = error {
                            print("Error creating initial contacts: \(error.localizedDescription)")
                        } else {
                            print("Initial contacts created successfully")
                        }
                    }
                }
            }
        } catch {
            print("Error encoding friend data: \(error.localizedDescription)")
        }
    }

}
