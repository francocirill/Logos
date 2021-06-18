//
//  PersistenceManager.swift
//  App2
//
//  Created by Marco Venere on 15/02/21.
//

import UIKit
import CoreData

class PersistenceManager {
    static let name = "UserProfile"
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    static func newProfile (name: String, outLoud: Bool, showPics: Bool, avatar: String) -> UserProfile {
        let context = getContext()
        let profile = NSEntityDescription.insertNewObject(forEntityName: self.name, into: context) as! UserProfile
        profile.name = name
        profile.outLoud = outLoud
        profile.showPics = showPics
        profile.avatar = avatar
        profile.lastLevel = 0
        profile.points = 0
        saveContext()
        return profile
    }
    static func fetchData() -> [UserProfile] {
        var users = [UserProfile]()
        let context = getContext()
        let fetchRequest = NSFetchRequest<UserProfile>(entityName: name)
        do {
            try users = context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Errore in fetch \(error.code)")
        }
        saveContext()
        return users
    }
    static func saveContext() {
        let context = getContext()
        do {
            try context.save()
        } catch {}
    }
    
}
