//
//  DBUtil.swift
//  GyanMatrix
//
//  Created by Sushant kumar on 12/03/17.
//  Copyright © 2017 Sushant kumar. All rights reserved.
//

import CoreData
import UIKit

class DBUtil : NSObject {
    
    static var favoritePlayer: [NSManagedObject] = []
    
    static func save(player: Player) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "PlayerDetail",
                                                in: managedContext)!
        
        let tempPlayer = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        tempPlayer.setValue(player.name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            favoritePlayer.append(tempPlayer)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func fetch()  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PlayerDetail")
        do {
            favoritePlayer = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func delete(player: Player) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        for tempPlayer in DBUtil.favoritePlayer {
            if player.name == tempPlayer.value(forKeyPath: "name") as! String {
                managedContext.delete(tempPlayer)
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
}
