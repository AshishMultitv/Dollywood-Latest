//
//  dataBase.swift
//  Dollywood Play
//
//  Created by Cyberlinks on 15/06/17.
//  Copyright © 2017 Cyberlinks. All rights reserved.
//

import UIKit
import CoreData

class dataBase: NSObject {

    
    
   //MARK:- Save any data with entity name, which key, data
    static func Savedatainentity(entityname:String,key:String,data:NSMutableDictionary)
    {
      
        
            let data1 = NSMutableData()
            let archiver = NSKeyedArchiver.init(forWritingWith: data1)
            // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
            archiver.finishEncoding()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            
            if #available(iOS 10.0, *) {
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: entityname,
                                                        in: managedContext)!
                let person = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
                
                person.setValue(data1, forKeyPath: key)
               // person.setValue(sport_id, forKeyPath: "id")
                
                do {
                    try managedContext.save()
                    print("Successfully save")
                 } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            } else {
                // Fallback on earlier versions
            }
            
 
        
    }
   
    
    
    //MARK:- Save Download video id
    static func savedownloadvideoid(id:String,userid:String)
    {
        
   
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Downloadvideoid",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(id, forKeyPath: "id")
            person.setValue(userid, forKeyPath: "userid")
            
            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
 
        
    }

    
    //MARK:- Save favriout video id
    static func savefavrioutvideoid(id:String,userid:String)
    {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Favriout",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(userid, forKeyPath: "userid")
            person.setValue(id, forKeyPath: "videoid")

            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
   
    
    static func getfavrioutlvideoid(userid:String) -> NSMutableArray
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let downloaddataarray = NSMutableArray()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favriout")
            
            do {
                
                let predicate = NSPredicate(format: "(userid = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    for i in 0..<manageobject.count
                    {
                        let person = manageobject[i]
                        let data = person.value(forKeyPath: "videoid") as! String
                         downloaddataarray.add(data)
                        
                        
                    }
                    print(downloaddataarray)
                    return downloaddataarray
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return downloaddataarray
        
    }
    

    static func deletefavvideoid(userid:String,videoid:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favriout")
            let predicate = NSPredicate(format: "(userid = %@)", userid)
            let predicate1 = NSPredicate(format: "(videoid = %@)", videoid)
            let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate,predicate1])
            fetchRequest.predicate = predicateCompound;
            fetchRequest.returnsObjectsAsFaults = false
            
            do
            {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Detele all data in  error : \(error) \(error.userInfo)")
            }
            
            
            
            
            
        } else {
            // Fallback on earlier versions
        }
        
    }
   
    
    
    
    static func getdownloadvideoid(userid:String) -> NSMutableArray
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let downloaddataarray = NSMutableArray()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Downloadvideoid")
            
            do {
                
                let predicate = NSPredicate(format: "(userid = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    for i in 0..<manageobject.count
                    {
                         let person = manageobject[i]
                          downloaddataarray.add(person.value(forKey: "id") as! String)
                      }
                    print(downloaddataarray)
                    return downloaddataarray
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return downloaddataarray
        
    }
    

    
    
    static func deletedownloadvideoid(videoid:String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Downloadvideoid")
            let predicate = NSPredicate(format: "(id = %@)", videoid)
             fetchRequest.predicate = predicate
             fetchRequest.returnsObjectsAsFaults = false
            
            do
            {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
            } catch let error as NSError {
                print("Detele all data in  error : \(error) \(error.userInfo)")
            }
            
            
            
            
            
        } else {
            // Fallback on earlier versions
        }
        
    }
 
    
    
    
    
    
    //MARK:- Save Homedata Catlist in database
  
    static func Savecatlist(entityname:String,id:String,key:String,data:NSMutableDictionary)
    {
        
        
        let data1 = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data1)
        // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: entityname,
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data1, forKeyPath: key)
            person.setValue(id, forKeyPath: "id")
            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    
    //MARK:- Save Download Video Data
    static func SaveDownloadvideo(Userid:String,Videoid:String,data:NSMutableDictionary,image:NSData)
    {
        
        
        let data1 = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWith: data1)
        // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
        archiver.finishEncoding()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "VideoDownload",
                                                    in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            person.setValue(data1, forKeyPath: "videodownloaddata")
            person.setValue(Userid, forKeyPath: "userid")
            person.setValue(Videoid, forKeyPath: "videoid")
            person.setValue(image, forKeyPath: "image")
            
            do {
                try managedContext.save()
                print("Successfully save")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        
    }
    
    static func getdownloadlistdatabase(userid:String) -> NSMutableArray
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         var downloaddataarray = NSMutableArray()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "VideoDownload")
            
            do {
                
                let predicate = NSPredicate(format: "(userid = %@)", userid)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                      for i in 0..<manageobject.count
                      {
                        var sportsDatabasedictnew = NSMutableDictionary()
                         let person = manageobject[i]
                        let data = person.value(forKeyPath: "videodownloaddata") as! Data
                        let data1 = person.value(forKeyPath: "image") as! Data

                        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                        print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                          sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                        sportsDatabasedictnew.setValue(data1, forKey: "videoimage")
                        downloaddataarray.add(sportsDatabasedictnew)
                        
                        
                    }
                  print(downloaddataarray)
                 return downloaddataarray
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return downloaddataarray
        
    }
    
    
    
    
    //MARK:- Get Homedata Catlist from database

    static func getcatlistdatabase(entityname:String,id:String,key:String) -> NSMutableDictionary
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var sportsDatabasedictnew = NSMutableDictionary()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityname)
            
            do {
                
                 let predicate = NSPredicate(format: "(id = %@)", id)
                 fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    let person = manageobject[0]
                    let data = person.value(forKeyPath: key) as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                    sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                    print("contentListArray>>>",sportsDatabasedictnew)
                    return sportsDatabasedictnew
                    
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return sportsDatabasedictnew
        
        
    }
   
    //MARK:- Get anydata response with emtity name and key

    static func getDatabaseresponseinentity(entityname:String,key:String) -> NSMutableDictionary
    {
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var sportsDatabasedictnew = NSMutableDictionary()
            
            if #available(iOS 10.0, *) {
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityname)
                
                do {
                    
                    
                   // let predicate = NSPredicate(format: "(id = %@)", sport_id)
                   // fetchRequest.predicate = predicate
                     var manageobject: [NSManagedObject] = []
                     manageobject = try managedContext.fetch(fetchRequest)
                    
                    if (manageobject.count>0)
                    {
                        
                        let person = manageobject[0]
                        let data = person.value(forKeyPath: key) as! Data
                        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                        print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                        sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                        print("contentListArray>>>",sportsDatabasedictnew)
                        return sportsDatabasedictnew
                        
                        
                    }
                    else
                    {
                        
                    }
                    
                    
                    
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
            } else {
                // Fallback on earlier versions
            }
            
         return sportsDatabasedictnew   
        
        
    }
    
    //MARK:- Delete data base with perticular entity
 
//    static func deletedataentity(entityname:String)
//    {
//        
//        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if #available(iOS 10.0, *) {
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
//           // let predicate = NSPredicate(format: "(id = %@)", sport_id)
//           // fetchRequest.predicate = predicate
//            fetchRequest.returnsObjectsAsFaults = false
//            
//            do
//            {
//                let results = try managedContext.fetch(fetchRequest)
//                for managedObject in results
//                {
//                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                    managedContext.delete(managedObjectData)
//                }
//            } catch let error as NSError {
//                print("Detele all data in \(entityname) error : \(error) \(error.userInfo)")
//            }
//            
//            
//            
//            
//            
//        } else {
//            // Fallback on earlier versions
//        }
//
//        
//        
//    }
    
    
    static func deletedownloaddata(userid:String,videoid:String){
        
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                if #available(iOS 10.0, *) {
                    let managedContext = appDelegate.persistentContainer.viewContext
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "VideoDownload")
                    let predicate = NSPredicate(format: "(userid = %@)", userid)
                    let predicate1 = NSPredicate(format: "(videoid = %@)", videoid)
                    let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates: [predicate,predicate1])
                    fetchRequest.predicate = predicateCompound;
                    fetchRequest.returnsObjectsAsFaults = false
        
                    do
                    {
                        let results = try managedContext.fetch(fetchRequest)
                        for managedObject in results
                        {
                            let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                            managedContext.delete(managedObjectData)
                        }
                    } catch let error as NSError {
                        print("Detele all data in  error : \(error) \(error.userInfo)")
                    }
        
                    
                    
                    
                    
                } else {
                    // Fallback on earlier versions
                }
        
    }
    
   static func deletedataentity(entityname:String){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entityname))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    
    //MARK:- Save Zonerdata in database
    
    func savezonerdataindatabase(data:NSMutableDictionary,zonerid:String)
 {
    
    let data1 = NSMutableData()
    let archiver = NSKeyedArchiver.init(forWritingWith: data1)
    // var archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encode(data, forKey: "dictpropertyinmanagedobject1")
    archiver.finishEncoding()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    
    if #available(iOS 10.0, *) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Zonerlistdata",
                                                in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(data1, forKeyPath: "zonerlistdatadict")
        person.setValue(zonerid, forKeyPath: "zonerid")
        do {
            try managedContext.save()
            print("Successfully save")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    } else {
        // Fallback on earlier versions
    }
    

    }
    
    //MARK:- Get Homedata Catlist from database
    
    static func getZonerdata(id:String) -> NSMutableDictionary
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var sportsDatabasedictnew = NSMutableDictionary()
        
        if #available(iOS 10.0, *) {
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Zonerlistdata")
            
            do {
                let predicate = NSPredicate(format: "(zonerid = %@)", id)
                fetchRequest.predicate = predicate
                var manageobject: [NSManagedObject] = []
                manageobject = try managedContext.fetch(fetchRequest)
                
                if (manageobject.count>0)
                {
                    let person = manageobject[0]
                    let data = person.value(forKeyPath: "zonerlistdatadict") as! Data
                    let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                    print(unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as Any)
                    sportsDatabasedictnew = unarchiver.decodeObject(forKey: "dictpropertyinmanagedobject1") as! NSMutableDictionary
                    print("contentListArray>>>",sportsDatabasedictnew)
                    return sportsDatabasedictnew
                    
                    
                }
                else
                {
                    
                }
                
                
                
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return sportsDatabasedictnew
        
        
    }

    
}
