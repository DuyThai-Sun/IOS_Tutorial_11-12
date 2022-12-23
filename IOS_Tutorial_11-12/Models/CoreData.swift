//
//  CoreData.swift
//  IOS_Tutorial_11-12
//
//  Created by Duy Thai on 23/12/2022.
//

import Foundation
import UIKit
import CoreData

final class CoreData {
    static let shared = CoreData()
    private var appDelegate: AppDelegate?
    
    private init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func addUser(informUser: UserModel?) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteUser", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(informUser?.login, forKey: "login")
        user.setValue(informUser?.avatarUrl, forKey: "avatarUrl")
        user.setValue(informUser?.htmlUrl, forKey: "htmlUrl")
        user.setValue(informUser?.followersUrl, forKey: "followersUrl")
        user.setValue(informUser?.followingUrl, forKey: "followingUrl")
        user.setValue(informUser?.id, forKey: "id")
        user.setValue(informUser?.reposUrl, forKey: "reposUrl")
        user.setValue(informUser?.isFavorited, forKey: "isFavorited")
        user.setValue(informUser?.url, forKey: "url")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Can not save, err: \(error)")
        }
    }
    
    func deleteUser(user: UserModel?) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteUser")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if (item.value(forKey: "id") as? Int == (user?.id ?? 0)) {
                    managedContext.delete(item)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getListUsers(completion: @escaping ([NSManagedObject], Error?) -> (Void)) {
        guard let appDelegate = appDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteUser")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            completion(items, nil)
        } catch let error as NSError {
            completion([], error)
            return
        }
    }
    
    func checkUserInCoreData(informUser: UserModel?) -> Bool {
        guard let appDelegate = appDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteUser")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedContext.fetch(fetchRequest)
            for item in items {
                if (item.value(forKey: "id") as? Int == (informUser?.id )) {
                    return true
                }
            }
        } catch  {
            print("Could not fetch. \(error)")
        }
        return false
    }
}
