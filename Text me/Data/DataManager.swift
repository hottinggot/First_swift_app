//
//  DataManager.swift
//  Text me
//
//  Created by 서정 on 2021/01/23.
//

import UIKit
import CoreData

class DataManager{
    static let shared = DataManager()
    
    init() {}
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName = "Memo"
    var memoList = [MemoVO]()
    
    func fetchMemo() {
        
        if let context = context {
            let request : NSFetchRequest<Memo> = Memo.fetchRequest()
            let sortByDateDesc = NSSortDescriptor(key: "updateDate", ascending: false)
            request.sortDescriptors = [sortByDateDesc]
            
            do{
                let resultSet = try context.fetch(request)
                
                for result in resultSet {
                    let data = MemoVO()
                    data.mainText = result.mainText
                    data.subText = result.subText
                    data.isNew = false
                    data.titleText = result.titleText
                    data.upadateDate = result.updateDate
                    
                    if let image = result.refImage {
                        data.refImage = UIImage(data: image)
                    }
                    memoList.append(data)
                }
                
            } catch {
                print("Could not fetch: \(error)")
            }
        }
        
    }
    
    func saveMemo(memo: MemoVO) {
        
        if let context = context {
            let newMemo = Memo(context: context)
            if let isNew = memo.isNew {
                newMemo.isNew = isNew
            }
            newMemo.mainText = memo.mainText
            newMemo.refImage = memo.refImage?.pngData()
            newMemo.subText = memo.subText
            newMemo.updateDate = Date()
            newMemo.titleText = memo.titleText
            
            memoList.insert(memo, at: 0 )
            
            do { try context.save() } catch { print(error.localizedDescription) }
            
        }
    }
    
}
