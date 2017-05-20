//
//  ViewController.swift
//  SkillCoreData
//
//  Created by adeveloper on 20.05.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit
import CoreData

class AgregateExampleVC: UIViewController {

    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer as NSPersistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()

     //  insertDemoData()
       loadDemoData()
        

        
        
        
    }

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SkillCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func saveDemoData(){
  //      let person = Person.findOrCreate(with: "Alex", context: container.viewContext)
        
    //    try! container.viewContext.save()
    }
    
    
    
    func loadDemoData(){
        
        print(Person.entityName)

       // guard let personEntity = NSEntityDescription.entity(forEntityName: Person.entityName, in: getContext()) else { return }
        let persons = Person.fetch(in: getContext())
        
        //let persons = Person.fetch(in: persistentContainer.viewContext)
        for person in persons {
            if let name = person.name {
                print(name)
            }
        }
        //let request = Person.fetchRequest<Person>()
        
        // request.fetchBatchSize = 20
        
        
    }
    
    func getRandomCount() -> Int64 {
        
        return Int64(arc4random_uniform(998) + 1)
    }
    
    
    func insertDemoData(){
        
        print("insert demo data")
        print(Person.entityName)
        
        
        
        
        guard let person = NSEntityDescription.insertNewObject(forEntityName: Person.entityName, into: getContext()) as? Person else {
            fatalError("Wrong Object Type")
        }
        
        person.name = "Mark"
        person.id = 2
        person.date = Date() as NSDate
        person.visitCount = getRandomCount()
        
        try! persistentContainer.viewContext.save()
    }
    

}

