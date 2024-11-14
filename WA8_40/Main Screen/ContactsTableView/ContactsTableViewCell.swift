import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var profilePic: UIImageView!
    var labelName: UILabel!
    var labelText: UILabel!
    var labelTime: UILabel!
    let unreadIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupLabelName()
        setupProfilePic()
        setupLabelText()
        setupLabelTime()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.4
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(wrapperCellView)
    }
    
    func setupProfilePic(){
        profilePic = UIImageView()
        profilePic.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profilePic.contentMode = .scaleToFill
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(profilePic)
    }
    
    func setupLabelName(){
        labelName = UILabel()
        labelName.font = UIFont.boldSystemFont(ofSize: 18)
        labelName.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelName)
        wrapperCellView.addSubview(unreadIndicator) // Red circle for reading
    }
    
    func setupLabelText(){
        labelText = UILabel()
        labelText.font = UIFont.boldSystemFont(ofSize: 14)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelText)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.font = .systemFont(ofSize: 10) 
        labelTime.textColor = .gray
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        labelTime.setContentHuggingPriority(.required, for: .horizontal)
        labelTime.setContentCompressionResistancePriority(.required, for: .horizontal)
        wrapperCellView.addSubview(labelTime)
    }
   
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            
            profilePic.widthAnchor.constraint(equalToConstant: 32),
            profilePic.heightAnchor.constraint(equalToConstant: 32),
            profilePic.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            profilePic.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 16),
            
            labelTime.centerYAnchor.constraint(equalTo: labelName.centerYAnchor),
            labelTime.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            labelTime.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            labelName.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelName.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 16),
            labelName.trailingAnchor.constraint(equalTo: labelTime.leadingAnchor, constant: -8),
            
            labelText.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
            labelText.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 16),
            labelText.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -16),
            labelText.bottomAnchor.constraint(equalTo: wrapperCellView.bottomAnchor, constant: -8),
            labelText.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            labelText.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor, constant: -48),
            labelText.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
        
            unreadIndicator.widthAnchor.constraint(equalToConstant: 10),
            unreadIndicator.heightAnchor.constraint(equalToConstant: 10),
            unreadIndicator.centerYAnchor.constraint(equalTo: labelName.centerYAnchor),
            unreadIndicator.leadingAnchor.constraint(equalTo: labelName.trailingAnchor, constant: 8)
        
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        wrapperCellView.layoutIfNeeded()
    }

}
