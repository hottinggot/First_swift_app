//
//  DataManager.swift
//  Text me
//
//  Created by 서정 on 2021/01/23.
//

import UIKit
import CoreData
import WebP

class DataManager{
    static let shared = DataManager()
    
    init() {}
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName = "Memo"
    var memoList = [Memo]()
    
    func fetchMemo() {
        
        if let context = context {
            let request : NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            let sortByDateDesc = NSSortDescriptor(key: "updateDate", ascending: false)
            request.sortDescriptors = [sortByDateDesc]
            
            do{
                if let resultSet : [Memo] = try context.fetch(request) as? [Memo] {
                    memoList = resultSet
                }
                
            } catch {
                print("Could not fetch: \(error)")
            }
        }
        
    }
    
    func saveMemo(memo: MemoVO) {
        
        let imageName = ImageManager.shared.saveImage(image: memo.refImage!)
        
        if let imageName = imageName, let context = context , let entity :NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: context) {
                if let newMemo: Memo = NSManagedObject(entity: entity, insertInto: context) as? Memo {
                    if let isNew = memo.isNew {
                        newMemo.isNew = isNew
                    }
                    
//                    let encoder = WebPEncoder()
//                    let webPData = try! encoder.encode(memo.refImage!, config: .preset(.picture, quality: 95))
//                    newMemo.refImage = webPData
                    
                    
                    newMemo.refImage = imageName
                    newMemo.mainText = memo.mainText
                    
                    newMemo.subText = memo.subText
                    newMemo.updateDate = Date()
                    newMemo.titleText = memo.titleText
                    
                    memoList.insert(newMemo, at: 0 )
                    
                }
            
                do { try context.save() } catch { print(error.localizedDescription) }
            }

    }
    
    func updateMemo() {
        if let context = context {
            do { try context.save() } catch { print(error.localizedDescription) }
        }
    }
    
    func deleteMemo(indexNum: Int) {
        
        if let context = context {
            context.delete(memoList[indexNum])
            do { try context.save() } catch { print(error.localizedDescription) }
        }
    }
    
}
