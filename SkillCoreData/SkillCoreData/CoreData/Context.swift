//
//  Context.swift
//  SkillCoreData
//
//  Created by adeveloper on 20.05.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    
    public func saveOrRollback() -> Bool {
        do{
            try save()
            return true
        } catch {
            rollback()
            return false
        }
    }
    
    public func performChanges(block: @escaping ()->()){
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
    
}


extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject> () -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A
            else { fatalError("Wrong object type") }
        return obj
    }
}
