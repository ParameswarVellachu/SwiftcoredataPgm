//
//  ViewController.swift
//  SwiftcoredataPgm
//
//  Created by Paramswar on 18/01/17.
//  Copyright © 2017 MTPL. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var i : Int = 1
        while i<5
        {
            let fileName = "myFileName\(i).txt"
            var filePath = ""
            
            // Fine documents directory on device
            let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
            
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/MyFolder111")
            
            
            do {
                try FileManager.default.createDirectory(atPath: filePath, withIntermediateDirectories: false, attributes: nil)
            }catch {
            }
            
            if dirs.count > 0 {
                //                let dir = dirs[0] //documents directory
                filePath = filePath.appending("/" + fileName)
                
                print("Local path = \(filePath)")
            } else {
                print("Could not find local directory to store file")
                return
            }
            
            
            if !FileManager.default.fileExists(atPath: filePath)
            {
                
                // Set the contents
                let fileContentToWrite = "12345"
                
                do {
                    // Write contents to file
                    try fileContentToWrite.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
                }
                catch let error as NSError {
                    print("An error took place: \(error)")
                }
                
            }
            else
            {
                print("No New File Created")
                let fileContentToWrite = "1234578"
                do {
                    try fileContentToWrite.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
                }
                catch {
                }
            }
            
            
            // Read file content. Example in Swift
            do {
                // Read file content
                let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
                print(contentFromFile)
            }
            catch let error as NSError {
                print("An error took place: \(error)")
            }
            i += 1
        }
        
        
    }
    
    
    @IBAction func btnSavAction(_ sender: Any)
    {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "ParamsEntity",
                                                 in:managedContext)
        let device = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        var arrList = NSArray()
        arrList = ["p","pa","par","para","param","params"]
        print(arrList);
        let data = NSKeyedArchiver.archivedData(withRootObject: arrList)
        let strUser = "7358666640"
        
        if ((entity) != nil)
        {
            do
            {
                device.setValue(data, forKey: "content")
                device.setValue(strUser, forKey: "regid")
                try managedContext.save()
            }
            catch let error as NSError
            {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        }
        else
        {
            print("Already Exists")
            
        }
        
        
        
    }
    @IBAction func btnDispAction(_ sender: Any)
    {
        self.getDisVal()
    }

    func getDisVal()
    {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ParamsEntity")
        let resultPredicate = NSPredicate(format: "(regid = %@)", "7358666640")
        fetchRequest.predicate = resultPredicate
        
        do {
            let records = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            for record in records
            {
                print(record.value(forKey: "regid") as! NSString)
                let data = (record.value(forKey: "content") as! NSData)
                let arrList = NSKeyedUnarchiver.unarchiveObject(with: data as Data)!
                print(arrList);
                
            }
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

