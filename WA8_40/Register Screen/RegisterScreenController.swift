import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterScreenController: UIViewController {
    let registerView = RegisterScreenView()
    let childProgressView = ProgressSpinnerViewController()
    
    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Setup the sign up button
        registerView.signUpButon.addTarget(self, action: #selector(onSignUpBarButtonTapped), for: .touchUpInside)
    }
    
    @objc func onSignUpBarButtonTapped() {
        if let name = registerView.textFieldName.text,
            let email = registerView.textFieldEmail.text,
            let password = registerView.textFieldPassword.text,
            let confirmPassword = registerView.textFieldConfirmPassword.text {
            
            if name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                self.showEmptyAlert()
            } else if password != confirmPassword {
                //MARK: Check if confirmPassword is same as passsword
                self.showPasswordNotEqualAlert()
            } else if !isValidEmail(email) {
                self.showInvalidEmailAlert()
            } else {
                //MARK: Register new account through Firebase
                self.registerNewAccount()
                
                //MARK: Show alert if signup Successfully
                self.showSignUpSuccessInAlert()

            }
        }
    }
    
    //MARK: show details in alert...
    func showSignUpSuccessInAlert(){
            //MARK: show alert...
            let message = "Click ok to login"
            let alert = UIAlertController(title: "Sigin Up Succeed", message: message, preferredStyle: .alert)
            //MARK: Click ok to go back to login page
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
        
            self.present(alert, animated: true)
    }
    
    //MARK: Validations
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func showPasswordNotEqualAlert() {
        let alert = UIAlertController(title: "Error!", message: "Password is not equal!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
