//
//  Memo.swift
//  Text me
//
//  Created by 서정 on 2021/01/18.
//

import Foundation

class Memo {
    var title: String
    var content: String
    var insertDate: Date
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        insertDate = Date()
    }
    
    static var dummyMemoList = [ Memo(title: "first memo", content: "first memo content")]
    
}
