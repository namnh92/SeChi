//
//  HMRealmService.swift
//  TimXe
//
//  Created by NamNH-D1 on 6/25/19.
//  Copyright © 2019 Hypertech Mobile. All rights reserved.
//

import UIKit
import RealmSwift

class HMRealmService {
    // MARK: - Singleton
    static var instance = HMRealmService()
    
    // MARK: - Supporting function
    func write(_ handler: ((_ realm: Realm) -> Void)) {
        do {
            let realm = try Realm()
            try realm.write {
                handler(realm)
            }
        } catch { }
    }
    
    func load<T: Object>(listOf: T.Type, filter: String? = nil) -> [T] {
        do {
            var objects = try Realm().objects(T.self)
            if let filter = filter {
                objects = objects.filter(filter)
            }
            var list = [T]()
            for obj in objects {
                list.append(obj)
            }
            return list
        } catch { }
        return []
    }
}
