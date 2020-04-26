//
//  HMContactModel.swift
//  SeChi
//
//  Created by Nguyễn Nam on 4/25/20.
//  Copyright © 2020 Hypertech Mobile. All rights reserved.
//

import UIKit
import RealmSwift

class HMContactModel: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String  = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    class func incrementID() -> Int {
//        let realm = try! Realm()
//        return (realm.objects(HMContactModel.self).max(ofProperty: "id") as Int? ?? 0) + 1
//    }
}
