//
//  ViewController.swift
//  Contact_List_Storyboard
//
//  Created by Aldongarov Nuraskhan on 24.10.2024.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var contacts: [Contact] = [
        Contact(name: "John Doe", phoneNumber: "123-456-7890"),
        Contact(name: "Jane Smith", phoneNumber: "987-654-3210")
    ]
    var searchingNames = [Contact]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search contacts"
        // Do any additional setup after loading the view.
        tableView.delegate=self
        tableView.dataSource = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddContactForm" {
            let destinationVC = segue.destination as! ContactDetailViewController
            destinationVC.delegate = self
        }
    }
    @IBAction func btnAdd(_sender:Any){
        let sb = UIStoryboard(name:"Main" , bundle: nil)
        let screen = sb.instantiateViewController(withIdentifier:"ContactDetailViewController" ) as! ContactDetailViewController
        screen.modalTransitionStyle = .crossDissolve
        screen.delegate = self
        self.navigationController?.pushViewController(screen, animated: true)
    }
    
}
extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("You tapped me!")
    }
    
}
extension ViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)->Int{
        if searching{
            return searchingNames.count
        }else{
            return contacts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if searching{
            let contact = searchingNames[indexPath.row]
            cell.textLabel?.text = contact.name
        }
        else{
            let contact = contacts[indexPath.row]
            cell.textLabel?.text = contact.name
        }
        return cell
    }
}
extension ViewController: ContactDelegate {
    func didAddContact(_ contact: Contact) {
        contacts.append(contact)
        tableView.reloadData()
    }
}
extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // adding trimming v.1.2
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        searchingNames = contacts.filter { contact in
            let nameParts = contact.name.lowercased().split(separator: " ")
            return nameParts.contains { $0.hasPrefix(trimmedSearchText) }
        }
        
        searching = !trimmedSearchText.isEmpty
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching=false
        searchBar.text = ""
    }
}
