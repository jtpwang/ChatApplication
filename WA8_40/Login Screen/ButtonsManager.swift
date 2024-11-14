import UIKit
import FirebaseAuth

extension ViewController{
    @objc func onSignUpBarButtonTapped() {
        let registerScreenController = RegisterScreenController()
        self.navigationController?.pushViewController(registerScreenController,animated: true)
    }

    @objc func onLoginUpBarButtonTapped() {
        print("login button tapped")
        self.showActivityIndicator()
        
        if let email = loginView.textFieldEmail.text,
           let password = loginView.textFieldPassword.text{
            
            // MARK: Validation check
            if email.isEmpty || password.isEmpty {
                showEmptyAlert()
            } else if !isValidEmail(email) {
                showInvalidEmailAlert()
            } else {
                //MARK: Perform login action
                performLogin(email: email, password: password)
            }
        } else {
            
        }
    }
    
    func performLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password:password, completion: {(result, error) in
            if error == nil {
                self.hideActivityIndicator()
                //MARK: Setup user token
                let mainScreenController = MainScreenController()
                self.navigationController?.pushViewController(mainScreenController, animated: true)
            } else{
                //MARK: Alert no user or incorrect password or other error
                self.hideActivityIndicator()
                let alert = UIAlertController(title: "Error!", message: "Incorrect Password or User not found!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        })
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    func showEmptyAlert() {
        let alert = UIAlertController(title: "Error!", message: "Fields cannot be empty!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showInvalidEmailAlert() {
        let alert = UIAlertController(title: "Error!", message: "Invalid Email!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
