//
//  DetailViewController.swift
//  Demo
//
//  Created by Rea Won Kim on 3/27/17.
//  Copyright © 2017 Rea Won Kim. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate : class {
    func deleteFunc(userList : UserList, indexPath: IndexPath)
}
class DetailViewController: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    var selectedUserList : UserList!
    var sendIndexPath : IndexPath!
    weak var delegate : DetailViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("SelectedUser : \(selectedUserList)")
        print("Send Index : \(sendIndexPath)")
        nameLbl.text = selectedUserList.name
    }

    @IBAction func deleteAction(_ sender: Any) {
        nameLbl.text = ""
        if delegate != nil {
            delegate?.deleteFunc(userList: selectedUserList, indexPath: sendIndexPath)
        }
        _ = navigationController?.popViewController(animated: true)
    }
}
