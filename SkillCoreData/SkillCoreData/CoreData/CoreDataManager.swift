//
//  CoreDataManager.swift
//  SkillCoreData
//
//  Created by adeveloper on 21.05.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit
import CoreData


protocol CoreDataAnyModel {
    static var modelAnyType: NSManagedObject.Type { get }
    func setupAny(model: NSManagedObject)
}

protocol CoreDataModel: CoreDataAnyModel {
    associatedtype ModelType: NSManagedObject
    func setup(model: ModelType)
}



class CoreDataManager {
    static var shared: CoreDataManager {
        return CoreDataManager()
    }
    
    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer as NSPersistentContainer
    
    lazy var context: NSManagedObjectContext = {
        [unowned self] in
        return self.container.viewContext
        }()
    
}


extension CoreDataManager {
    
    typealias Model = Person
    
    func getData(_ block: (_ results: [Person]) -> Void) {
         let persons = Model.fetch(in: context)
        block(persons)
    }
    
    func add(_ getValuesForAdd: (_  model: Model) -> Model ){
        guard let person = NSEntityDescription.insertNewObject(forEntityName: Model.entityName, into: context) as? Model else {
            fatalError("Wrong Object Type")
        }
        let changedPerson = getValuesForAdd(person)
        print("after set values \(changedPerson)\n")
        try! context.save()
    }

    func getBy(objectId: NSManagedObjectID) -> Model {
        let persons = context.object(with: objectId)
        return persons as! Model
    }
    
    func getBy(id: Int64 ) -> Model? {

        let predicate = NSPredicate(format: "%K == %d",  #keyPath(Person.id), id)
        let request = NSFetchRequest<Model>()
        request.entity = Model.entity()
        request.predicate = predicate
        request.fetchLimit = 1
        let items = try! context.fetch(request)
        
        return items.first
    }
    
    func deleteBy(id: Int64) {
        if let item = self.getBy(id: id) {
            context.delete(item)
        }
    }
    
    func update(id: Int64, getValuesForUpdate: (_  model: Model) -> Model ){
        if let item = getBy(id: id) {
            _ = getValuesForUpdate(item)
            try! context.save()
        }
       
    }
    
}

