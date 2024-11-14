import UIKit

class RegisterScreenView: UIView {
    //MARK: Scroll view
    var contentWrapper: UIScrollView!

    //MARK: TextFields
    var textFieldName:UITextField!
    var textFieldEmail:UITextField!
    var textFieldPassword:UITextField!
    var textFieldConfirmPassword:UITextField!
    
    //MARK: Login & Sign Up Button
    var signUpButon: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setUpContentWrapper()
        
        setupTextFieldName()
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupTextFieldConfirmPassword()
        setupSiginUpButton()
        
        initConstraints()
    }
    
    func setUpContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }

    func setupTextFieldName() {
        textFieldName = UITextField()
        textFieldName.placeholder = "Name"
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        textFieldName.borderStyle = .roundedRect
        contentWrapper.addSubview(textFieldName)
    }

    func setupTextFieldEmail() {
        textFieldEmail = UITextField()
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.placeholder = "Email"
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        textFieldEmail.borderStyle = .roundedRect
        contentWrapper.addSubview(textFieldEmail)
    }
    
    func setupTextFieldPassword() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        contentWrapper.addSubview(textFieldPassword)
    }
    
    func setupTextFieldConfirmPassword() {
        textFieldConfirmPassword = UITextField()
        textFieldConfirmPassword.placeholder = "Confirm Password"
        textFieldConfirmPassword.translatesAutoresizingMaskIntoConstraints = false
        textFieldConfirmPassword.borderStyle = .roundedRect
        textFieldConfirmPassword.isSecureTextEntry = true
        contentWrapper.addSubview(textFieldConfirmPassword)
    }
    
    func setupSiginUpButton() {
        signUpButon = UIButton(type: .system)
        signUpButon.setTitle("Sign Up", for: .normal)
        signUpButon.setTitleColor(.white, for: .normal)
        signUpButon.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signUpButon.backgroundColor = .systemBlue
        signUpButon.layer.cornerRadius = 10.0
        signUpButon.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(signUpButon)

    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            textFieldName.topAnchor.constraint(equalTo: self.contentWrapper.topAnchor, constant: 64),
            textFieldName.centerXAnchor.constraint(equalTo: self.contentWrapper.centerXAnchor),
            textFieldName.leadingAnchor.constraint(equalTo: self.contentWrapper.leadingAnchor, constant: 40),
            textFieldName.trailingAnchor.constraint(equalTo: self.contentWrapper.trailingAnchor, constant: -40),
            
            textFieldEmail.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 16),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.contentWrapper.centerXAnchor),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.contentWrapper.leadingAnchor, constant: 40),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.contentWrapper.trailingAnchor, constant: -40),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: self.contentWrapper.centerXAnchor),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.contentWrapper.leadingAnchor, constant: 40),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.contentWrapper.trailingAnchor, constant: -40),
            
            textFieldConfirmPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 16),
            textFieldConfirmPassword.centerXAnchor.constraint(equalTo: self.contentWrapper.centerXAnchor),
            textFieldConfirmPassword.leadingAnchor.constraint(equalTo: self.contentWrapper.leadingAnchor, constant: 40),
            textFieldConfirmPassword.trailingAnchor.constraint(equalTo: self.contentWrapper.trailingAnchor, constant: -40),
                        
            signUpButon.topAnchor.constraint(equalTo: textFieldConfirmPassword.bottomAnchor, constant: 60),
            signUpButon.centerXAnchor.constraint(equalTo: self.contentWrapper.centerXAnchor),
            signUpButon.leadingAnchor.constraint(equalTo: self.contentWrapper.leadingAnchor, constant: 40),
            signUpButon.trailingAnchor.constraint(equalTo: self.contentWrapper.trailingAnchor, constant: -40),

        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
