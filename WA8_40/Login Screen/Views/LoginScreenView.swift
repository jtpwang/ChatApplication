import UIKit

class LoginScreenView: UIView {
    //MARK: Scroll view
    var contentWrapper: UIScrollView!

    //MARK: TextFields
    var textFieldEmail:UITextField!
    var textFieldPassword:UITextField!
    
    //MARK: Stack View for Buttons
    var buttonStackView: UIStackView!
    
    //MARK: Login & Sign Up Button
    var loginButton: UIButton!
    var signUpButon: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setUpContentWrapper()
        
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupButtons()
        
        initConstraints()
    }
    
    func setUpContentWrapper() {
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
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
    func setupButtons() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.backgroundColor = .systemRed
        loginButton.layer.cornerRadius = 10.0
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        signUpButon = UIButton(type: .system)
        signUpButon.setTitle("Sign Up", for: .normal)
        signUpButon.setTitleColor(.white, for: .normal)
        signUpButon.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signUpButon.backgroundColor = .systemBlue
        signUpButon.layer.cornerRadius = 10.0
        signUpButon.translatesAutoresizingMaskIntoConstraints = false

        // Stack view for buttons
        buttonStackView = UIStackView(arrangedSubviews: [signUpButon, loginButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentWrapper.addSubview(buttonStackView)
    }
    
    func setupLoginButton() {
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Center the text within the button's borders
        loginButton.contentHorizontalAlignment = .center
        loginButton.contentVerticalAlignment = .center

        loginButton.imageView?.contentMode = .scaleAspectFit
        // Background color
        loginButton.backgroundColor = UIColor.systemBlue
        
        // Border settings
        loginButton.layer.borderColor = UIColor.darkGray.cgColor
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.cornerRadius = 10.0 // Rounded corners
        
        // Add menu to show in view
        loginButton.showsMenuAsPrimaryAction = true
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(loginButton)
    }
    
    func setupSiginUpButton() {
        signUpButon = UIButton(type: .system)
        signUpButon.setTitle("Sign Up", for: .normal)
        signUpButon.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        signUpButon.contentHorizontalAlignment = .fill
        signUpButon.contentVerticalAlignment = .fill
        signUpButon.imageView?.contentMode = .scaleAspectFit
        
        // Add menu to show in view
        signUpButon.showsMenuAsPrimaryAction = true
        signUpButon.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(signUpButon)

    }
    
    func initConstraints(){
        let sidePadding: CGFloat = 20
        let topPadding: CGFloat = 32

        NSLayoutConstraint.activate([
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.widthAnchor.constraint(equalTo:self.safeAreaLayoutGuide.widthAnchor),
            contentWrapper.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            textFieldEmail.topAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: 32),
            textFieldEmail.centerXAnchor.constraint(equalTo: self.contentWrapper.centerXAnchor),
            textFieldEmail.leadingAnchor.constraint(equalTo: self.contentWrapper.leadingAnchor, constant: sidePadding),
            textFieldEmail.trailingAnchor.constraint(equalTo: self.contentWrapper.trailingAnchor, constant: -sidePadding),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: self.contentWrapper.centerXAnchor),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.contentWrapper.leadingAnchor, constant: sidePadding),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.contentWrapper.trailingAnchor, constant: -sidePadding),
            
            // Button Stack View Constraints
              buttonStackView.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: topPadding * 1.5),
              buttonStackView.leadingAnchor.constraint(equalTo: contentWrapper.leadingAnchor, constant: sidePadding),
              buttonStackView.trailingAnchor.constraint(equalTo: contentWrapper.trailingAnchor, constant: -sidePadding),
                        
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
