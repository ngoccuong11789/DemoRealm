//
//  TaskList.swift
//  Demo
//
//  Created by Rea Won Kim on 3/24/17.
//  Copyright © 2017 Rea Won Kim. All rights reserved.
//

import RealmSwift

class UserList: Object {
  dynamic var name = ""
  dynamic var createdAt = NSDate()
  let users = List<User>()
}
