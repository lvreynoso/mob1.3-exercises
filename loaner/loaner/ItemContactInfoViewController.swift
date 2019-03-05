//
//  ItemContactInfoViewController.swift
//  loaner
//
//  Created by Erick Sanchez on 8/17/18.
//  Copyright © 2018 LinnierGames. All rights reserved.
//

import UIKit
import ContactsUI

class ItemContactInfoViewController: UIViewController {

    var item: Item!
    
    func updateUI() {
        labelTitle.text = "Contact Info"
        imageViewItem.image = item.itemImage
        labelItemTitle.text = item.itemTitle
        if item.notes.isEmpty {
            labelItemNotes.text = "No Notes"
        } else {
            labelItemNotes.text = item.notes
        }
        
        updateContactInfo()
    }
    
    func updateContactInfo() {
        if let contact = item.loanee {
            buttonAddContact.isHidden = true
            stackViewContactInfo.isHidden = false
            imageViewContact.image = contact.profileImage
            labelContactName.text = contact.name
            labelContactNumber.text = contact.contactNumber ?? "No Number"
            
        } else {
            buttonAddContact.isHidden = false
            stackViewContactInfo.isHidden = true
        }
    }
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var labelItemTitle: UILabel!
    @IBOutlet weak var labelItemNotes: UILabel!
    @IBOutlet weak var buttonAddContact: UIButton!
    @IBAction func pressAddContact(_ sender: UIButton) {
        let contactVc = CNContactPickerViewController()
        contactVc.delegate = self
        contactVc.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        
        present(contactVc, animated: true)
    }
    
    @IBOutlet weak var stackViewContactInfo: UIStackView!
    @IBOutlet weak var imageViewContact: UIImageView!
    @IBOutlet weak var labelContactName: UILabel!
    @IBOutlet weak var labelContactNumber: UILabel!
    @IBAction func pressDeleteContact(_ sender: UIButton) {
        item.assignLoanee(to: nil)
        updateContactInfo()
    }
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBAction func pressSave(_ sender: UIButton) {
        
        //validate the user has selected a contact
        guard item.loanee != nil else {
            let alertMissingContact = UIAlertController(
                title: "Saving New Item",
                message: "please select a contact that has a phone number",
                preferredStyle: .alert
            )
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
            alertMissingContact.addAction(dismissAction)
            
            present(alertMissingContact, animated: true)
            
            return
        }
        
        performSegue(withIdentifier: "unwind from saving new item", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
}

extension ItemContactInfoViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        item.assignLoanee(to: contact)
        updateContactInfo()
    }
}
