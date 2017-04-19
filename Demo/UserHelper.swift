//
//  UserHelper.swift
//  Demo
//
//  Created by Rea Won Kim on 3/28/17.
//  Copyright © 2017 Rea Won Kim. All rights reserved.
//

import RealmSwift

struct UserHelper {
    let uiRealm: Realm?
    static let sharedInstance = UserHelper()
    
    private init () {
        uiRealm = try? Realm()
    }
    
    func addListUser(listUser : String, update: Bool,updateList: UserList!, completion: (Bool) -> ()) {
        let userList = UserList()
        userList.name = listUser
        
        guard let realm = uiRealm else {
            completion(false)
            return
        }
        
        do {
            try realm.write({
                if update == false {
                    realm.add(userList, update: update)
                }else {
                    updateList.name = listUser
                }
            })
            completion(true)
            
        } catch {
            completion(false)
        }
        
    }
    
    /*func editListUser(updatedList : UserList!, listUser: String, completion: (Bool) -> ()) {
        do {
            try uiRealm?.write({
                updatedList.name = listUser
            })
            completion(true)
        }catch {
            completion(false)
        }
    }*/
    
    func deleteListUser(userList : UserList, completion: (Bool) -> ()) {
        do {
            try uiRealm?.write({
                uiRealm?.delete(userList)
            })
            completion(true)
        }catch {
            completion(false)
        }
        
    }
}
