//
//  DataManager.swift
//  Text me
//
//  Created by 서정 on 2021/01/19.
//

import Foundation
import CoreData
import UIKit

class DataManager {
    
    static let shared = DataManager()
    private init() {
        //Singleton
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var memoList = [Memo]()
    
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key: "insetDate", ascending: false)
        
        request.sortDescriptors = [sortByDateDesc]
        
        do{
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
        
    }
    
    func insertNewMemo(_ memo: MemoVO) {
        let newMemo = Memo(context: mainContext)
        newMemo.titleText = memo.titleText
        newMemo.mainText = memo.mainText
        newMemo.subText = memo.subText
        
        if let image = memo.refImage {
            newMemo.refImage = image.pngData()
        }
        
        saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Text_me")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
