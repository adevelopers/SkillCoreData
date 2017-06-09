//
//  Person.swift
//  SkillCoreData
//
//  Created by adeveloper on 20.05.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit
import CoreData

class Person: NSManagedObject {

    static var entityName: String = "Person"
    
    class func findOrCreate(with name:String,context: NSManagedObjectContext) -> Person{
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Person
        entity.name = name
        return entity
    }
}

/*
extension Person: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [ NSSortDescriptor(key: #keyPath(self.date), ascending: false)]
    }
}
*/
 

extension Person: Managed {}









