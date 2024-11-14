import UIKit

class MainScreenView: UIView {
    var floatingButtonAddChat: UIButton!
    var tableViewContacts: UITableView!
    var bottomPopupTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupFloatingButtonAddChat()
        setupTableViewContacts()
        
        setupBottomPopupTableView()
        initConstraints()
    }
    
    func setupTableViewContacts(){
        tableViewContacts = UITableView()
        tableViewContacts.register(ContactsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        tableViewContacts.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableViewContacts)
    }
    
    func setupBottomPopupTableView(){
        bottomPopupTableView = UITableView()
        bottomPopupTableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: Configs.tableViewContactsID)
        bottomPopupTableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomPopupTableView)
    }
    

    func setupFloatingButtonAddChat() {
        floatingButtonAddChat = UIButton(type: .system)
        floatingButtonAddChat.translatesAutoresizingMaskIntoConstraints = false
        
        // Set button icon
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let image = UIImage(systemName: "person.crop.circle.fill.badge.plus", withConfiguration: config)
        floatingButtonAddChat.setImage(image, for: .normal)
        floatingButtonAddChat.tintColor = .systemBlue
        
        // Shadow effect
        floatingButtonAddChat.layer.shadowColor = UIColor.black.cgColor
        floatingButtonAddChat.layer.shadowOffset = CGSize(width: 0, height: 2)
        floatingButtonAddChat.layer.shadowRadius = 4
        floatingButtonAddChat.layer.shadowOpacity = 0.3
        
        self.addSubview(floatingButtonAddChat)
    }
    
    
    //MARK: setting up constraints...
    func initConstraints() {
        NSLayoutConstraint.activate([
            tableViewContacts.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableViewContacts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableViewContacts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableViewContacts.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            floatingButtonAddChat.widthAnchor.constraint(equalToConstant: 60),
            floatingButtonAddChat.heightAnchor.constraint(equalToConstant: 60),
            floatingButtonAddChat.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            floatingButtonAddChat.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
