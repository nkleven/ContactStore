//
//  TableViewController.swift
//  Address Book
//
//  Created by Nathan Kleven on 5/30/16.
//  Copyright © 2016 nwiss. All rights reserved.
//

import UIKit
import AddressBook
import Contacts
import ContactsUI

class TableViewController: UITableViewController {
    
    var store = CNContactStore()
    var allContacts = [CNContact]()
    
    @IBOutlet var contactTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        switch CNContactStore.authorizationStatusForEntityType(.Contacts){
        case .Authorized:
            print("Authorized")
            self.allContacts = self.getContacts()
            print(self.allContacts.count)
            self.contactTable.reloadData()
        case .Denied:
            print("Denied")
        case .NotDetermined:
            store.requestAccessForEntityType(.Contacts, completionHandler: { (succeeded, error) in
                if succeeded {
                    print("Now Authorized")
                    self.allContacts = self.getContacts()
                    print(self.allContacts.count)
                    self.contactTable.reloadData()
                }else{
                    print("Not Authorized")
                }
            })
            print("Not Determined")
        default:
            print("Restricted")
            break

            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allContacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        let name = "\(allContacts[indexPath.row].givenName) \(allContacts[indexPath.row].familyName)"
        cell.nameLabel.text = name
        if (allContacts[indexPath.row].isKeyAvailable(CNContactPhoneNumbersKey)){
            for phoneNumber:CNLabeledValue in allContacts[indexPath.row].phoneNumbers{
                let a = phoneNumber.value as! CNPhoneNumber
                print("Label: \(phoneNumber.label)")
                print("Value: \(phoneNumber.value)")
                print("CNPhoneNumber: \(a.stringValue)")
                print("Digits: \(a.valueForKey("digits")!)")
            }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getContacts() ->[CNContact]{

        var contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containersMatchingPredicate(nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainerWithIdentifier(container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContactsMatchingPredicate(fetchPredicate, keysToFetch: keysToFetch)
                    results.appendContentsOf(containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            return results
        }()
        return contacts
    }
    
    
}
