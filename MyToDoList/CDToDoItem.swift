//
//  MyToDoList.swift
//  MyToDoList
//
//  Created by MobileStudio04 on 30/05/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import Foundation
import CoreData

class CDToDoItem: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var done: NSNumber
    @NSManaged var color: AnyObject
    @NSManaged var note: String

}
