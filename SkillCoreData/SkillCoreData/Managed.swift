//
//  Managed.swift
//  SkillCoreData
//
//  Created by adeveloper on 20.05.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import CoreData


protocol Managed: class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}


extension Managed {
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] { return [] }
}

extension Managed where Self: NSManagedObject {
   
    static var entityName: String {
        if let name = entity().name {
            return name
        }
        else {
           return getEntityName()
        }
        
    }
    
    static func getEntityName() -> String {
        return String(describing: Mirror(reflecting: self).subjectType).components(separatedBy: ".").first!
    }
    
    
}

extension Managed where Self: NSManagedObject {
    static func fetch(in context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<Self>)->() = {_ in}) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return try! context.fetch(request)
    }
}


