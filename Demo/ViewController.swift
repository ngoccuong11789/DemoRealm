//
//  ViewController.swift
//  Demo
//
//  Created by Rea Won Kim on 3/24/17.
//  Copyright © 2017 Rea Won Kim. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let textCellIdentifier = "UserCell"
    var results : Results<UserList>!
    var currentCreateAction:UIAlertAction!
    var converted : List<UserList>!
    //var listConvertedUser : List<UserList>!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //let results: Results<MyObject> = ...
        
        results = try! Realm().objects(UserList.self)
        
        converted = results.reduce(List<UserList>()) { (list, element) -> List<UserList> in
            list.append(element)
            return list
        }
        readUsersAndUpateUI()
    }
    
    fileprivate func readUsersAndUpateUI() {
        //lists = uiRealm?.objects(UserList.self)
        results = try! Realm().objects(UserList.self)
        
        converted = results.reduce(List<UserList>()) { (list, element) -> List<UserList> in
            list.append(element)
            return list
        }

        tableView.setEditing(false, animated: true)
        tableView.reloadData()
        //tableView.deleteRows(at: [IndexPath], with: <#T##UITableViewRowAnimation#>)
    }
    
    @IBAction func displayAlertToAddTask(_ sender: Any) {
        showAlertToAddUser(nil)
        
    }
    
    func listNameFieldDidChange(_ textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    fileprivate func addUserToRealDB(mode : Bool, updatedList : UserList!, listUser: String) {
        UserHelper.sharedInstance.addListUser(listUser: listUser, update: mode, updateList: updatedList) { (success) in
            //converted.append(listUser)
            self.readUsersAndUpateUI()
            //converted.append(updatedList)
            print("converted: \(converted)")
        }
    }
    
   fileprivate func showAlertToAddUser(_ updatedList : UserList!) {
        var title = "Add User"
        var doneTitle = "Create"
        let alertController = UIAlertController(title: title, message: "Add a user to list", preferredStyle: UIAlertControllerStyle.alert)
        
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default) { (action) in
            let listUser = alertController.textFields?.first?.text
            
            if updatedList != nil {
                title = "Update User"
                doneTitle = "Update"
            }
            
            if updatedList != nil {
                // update mode
                self.addUserToRealDB(mode:  true, updatedList: updatedList, listUser: listUser!)
            }else {
                self.addUserToRealDB(mode: false, updatedList: updatedList, listUser: listUser!)
            }
            print("List User : \(listUser)")
        }
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alertController.addTextField { (textField) in
            textField.placeholder = "List User"
            textField.addTarget(self, action: #selector(self.listNameFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            if updatedList != nil {
                textField.text = updatedList.name
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let usersList = converted {
            return usersList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let list = converted[indexPath.row]
        cell.titleLable.text = list.name
        cell.detailTextLabel?.text = "\(list.users.count) Users"
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailVC", sender: self)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (deleteAction, indexPath) in
            let listToBeDelete = self.converted[indexPath.row]
            UserHelper.sharedInstance.deleteListUser(userList: listToBeDelete, completion: { _ in
                self.converted.remove(objectAtIndex: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                
            })
        }
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit") { (editAction, indexPath) in
            let listToBeEdit = self.converted[indexPath.row]
            
            self.showAlertToAddUser(listToBeEdit)
        }
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let detailVC = segue.destination as? DetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC?.selectedUserList = converted[indexPath.row]
            detailVC?.sendIndexPath = indexPath
            detailVC?.delegate = self
        }
    }
}

extension ViewController : DetailViewControllerDelegate {

    func deleteFunc(userList: UserList, indexPath: IndexPath) {
        
        UserHelper.sharedInstance.deleteListUser(userList: userList) {_ in
            self.converted.remove(objectAtIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}
