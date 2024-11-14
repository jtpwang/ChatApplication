import Foundation
import UIKit

extension MainScreenController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Configs.tableViewContactsID, for: indexPath) as! ContactsTableViewCell
        
        let contact = contactsList[indexPath.row]
        cell.labelName.text = contact.name
        cell.labelText.text = contact.lastMessage ?? "No messages yet"
        
        if let lastMessageTime = contact.lastMessageTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd HH:mm"
            cell.labelTime.text = dateFormatter.string(from: lastMessageTime)
        }
        
        cell.unreadIndicator.isHidden = !(contact.hasUnreadMessages ?? false)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contactsList[indexPath.row]
        let chatVC = ChatViewController(contact: selectedContact)
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}