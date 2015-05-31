//
//  Person.swift
//  MyToDoList
//
//  Created by MobileStudio04 on 30/05/15.
//  Copyright (c) 2015 MobileStudio. All rights reserved.
//

import Foundation
import CoreData

class Person: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var age: NSNumber

}
