# SkillCoreData
Core Data Agregate

```Swift
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
                person.id = personId
                person.date = Date() as NSDate
                person.visitCount = getRandomCount()
                return person
            }
        }
```
