//
//  Task.swift
//  Demo
//
//  Created by Rea Won Kim on 3/24/17.
//  Copyright © 2017 Rea Won Kim. All rights reserved.
//

import RealmSwift

class User: Object {
  dynamic var name = ""
  dynamic var createdAt = NSDate()
  dynamic var notes = ""
  dynamic var isComplete = false
    
    
}
