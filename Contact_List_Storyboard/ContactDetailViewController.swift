//
//  ContactDetailViewController.swift
//  Contact_List_Storyboard
//
//  Created by Aldongarov Nuraskhan on 24.10.2024.
//

import Foundation
import UIKit

protocol ContactDelegate: AnyObject {
    func didAddContact(_ contact: Contact)
}

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    weak var delegate: ContactDelegate?
    
    @IBAction func saveContact() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            return
        }
        let newContact = Contact(name: name, phoneNumber: phoneNumber)
        delegate?.didAddContact(newContact)
        navigationController?.popViewController(animated: true)
    }
}
