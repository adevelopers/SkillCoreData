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


/*
 
 let personId:Int64 = 31337
 
 if (db.getBy(id: personId) != nil){
 db.update(id: personId){ person in
 person.name = "Худяков Кирилл"
 person.visitCount = 3
 return person
 }
 }
 else {
 print("Нет такой записи, добавляем")
 db.add { person in
 person.name = getFakeName()
 person.id = 31337
 person.date = Date() as NSDate
 person.visitCount = getRandomCount()
 return person
 }
 }
 
 if let person = db.getBy(id: personId) {
 print("name: \(person.name!) visits: \(person.visitCount)")
 }
 */

extension UIApplication {
    func incrementBadge(){
        self.applicationIconBadgeNumber += 1
        print("Badge number: \(applicationIconBadgeNumber)")
    }
}

class AgregateExampleVC: UIViewController {
    
    //MARK: CoreData Properties
    lazy var context: NSManagedObjectContext = {
       return CoreDataManager.shared.context
    }()
    
    lazy var db: CoreDataManager = {
        return CoreDataManager.shared
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.incrementBadge()
        
        printEvents()
        
    }
    
    //MARK: Print methods
    func printMembers(){
        let memberModel = MemberModel()
        memberModel.getData{ items in
            for item in items {
                print(item)
            }
        }

    }
    func printEvents(){
        
        let eventsTable = EventModel()
        eventsTable.getData{ events in
            for item in events {
                print("Event: \(item.theme!)")
            }
        }
    }
    func printPersons(){
        let personModel = PersonModel()
        personModel.getData{ items in
            for item in items {
                print("Name: \(String(describing: item.name))")
            }
        }
    }
    
    
    //MARK: Add methods
    func addDemoEvents(){
        addEvent(name: "Встреча в Avito в среду")
        addEvent(name: "Встреча в StarBucks по субботам")
    }
    
    
    func addMemeber(name: String, email: String){
        let memberModel = MemberModel()
        memberModel.add{ member in
            member.name = name
            member.email = email
            return member
        }
    }
    
    func addPerson(name: String){
        let personModel = PersonModel()
        personModel.add{ person in
            person.name = name
            return person
        }
    }
    
    func addEvent(name: String){
        let eventModel = EventModel()
        eventModel.add{ event in
            event.theme = name
            event.isOpen = true
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.mm.YYYY"
            event.dateStart = formatter.date(from: "11.07.2017")! as NSDate
            return event
        }
        
    }
    
    
    //MARK: demo methods
    func addDemoData(){
        for _ in 1...100 {
            self.personAdd()
        }
    }
    
    func personAdd(){
        db.add { person in
            person.name = getFakeName()
            person.id = -1 // for sync with remote server
            person.date = Date() as NSDate
            person.visitCount = getRandomCount()
            
            return person
        }
    }

    func loadDemoData(){
        db.getData { persons in
            print("fetching data")
            for person in persons {
                
                if let name = person.name{
                    print("name: \(name) visits: \(person.visitCount)")
                }
            }
            
        }
    }
    
    //TODO: fix this
    func find(){
        // let predicate = NSPredicate(format: "visitCount > 500")
        // let predicate = NSPredicate(format: "visitCount == max(visitCount)")
        let predicate = NSPredicate(format: "visitCount == average(visitCount)")
        let request = NSFetchRequest<Person>()
        request.entity = Person.entity()
        request.predicate = predicate
        
        let persons = try! context.fetch(request)
        
        print("count: \(persons.count)")
        print(persons)
        
        for person in persons {
            
            if let name = person.name{
                print("name: \(name) visits: \(person.visitCount)")
            }
        }
    }
    
    //TODO: fix average
    func calcAvg(){
        let request = NSFetchRequest<Person>()
         request.entity = Person.entity()
        request.resultType = .managedObjectResultType
        
        let salaryExp = NSExpressionDescription()
        salaryExp.expressionResultType = .integer64AttributeType
        
        let kp = #keyPath(Person.visitCount)
        print(kp)
        
        salaryExp.expression = NSExpression(forFunction: "average:", arguments: [NSExpression(forKeyPath: #keyPath(Person.visitCount))])
        salaryExp.name = "avgVisits"
        request.propertiesToGroupBy = nil
        request.propertiesToFetch = [salaryExp]
        
        
        let result = try! CoreDataManager.shared.context.fetch(request)
        
        print(result)
    }
    
    
    //MARK: help function
    func getRandomCount() -> Int64 {
        return Int64(arc4random_uniform(998) + 1)
    }
    
    func getFakeName() -> String {
        let faker = Faker(locale: "ru")
        return faker.name.name()
    }


    
    
}

