//
//  ViewController.swift
//  SkillCoreData
//
//  Created by adeveloper on 20.05.17.
//  Copyright © 2017 adeveloper. All rights reserved.
//

import UIKit
import CoreData
import Fakery

class AgregateExampleVC: UIViewController {

    var container: NSPersistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer as NSPersistentContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        find()
        
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
    
    
    func addDemoData(){

        for _ in 1...100 {
            self.personAdd()
        }
    }
    
    
    
    func loadDemoData(){

        let persons = Person.fetch(in: getContext())
    
        for person in persons {

            if let name = person.name{
                print("name: \(name) visits: \(person.visitCount)")
            }
        }
        
    }
    
    func find(){
       // let predicate = NSPredicate(format: "visitCount > 500")
        let predicate = NSPredicate(format: "visitCount == max(visitCount)")
        
        let request = NSFetchRequest<Person>()
        request.entity = Person.entity()
        request.predicate = predicate
        
        let persons = try! getContext().fetch(request)
        
        print("count: \(persons.count)")
        
        for person in persons {
            
            if let name = person.name{
                print("name: \(name) visits: \(person.visitCount)")
            }
        }

        
    }
    
    
    func getRandomCount() -> Int64 {
        return Int64(arc4random_uniform(998) + 1)
    }
    
    func getFakeName() -> String {
        let faker = Faker(locale: "ru")
        return faker.name.name()
    }
    
    func personAdd(){
    
        guard let person = NSEntityDescription.insertNewObject(forEntityName: Person.entityName, into: getContext()) as? Person else {
            fatalError("Wrong Object Type")
        }
        
        person.name = getFakeName()
        person.id = -1 // for sync with remote server
        person.date = Date() as NSDate
        person.visitCount = getRandomCount()
        try! persistentContainer.viewContext.save()
    }

    func personDeleteAll(){
        for person in Person.fetch(in: getContext()) {
            getContext().delete(person)
        }
        try! getContext().save()
    }
    
    func personDelete(){
        
    }
    
    
}

