import Foundation
import RealmSwift

enum TaskType: Int {
    case notCompleted = 0
    case completed = 1
    case supportNotCompleted = 2
    case supportCompleted = 3
}
class TaskReminder: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var taskName: String  = ""
    @objc dynamic var taskDay: String  = ""
    @objc dynamic var taskTime: String  = ""
    @objc dynamic var taskType: Int  = TaskType.notCompleted.rawValue
    @objc dynamic var supporter: HMContactModel?
    
    var typeTask: TaskType {
      get {
        return TaskType(rawValue: taskType)!
      }
      set {
        taskType = newValue.rawValue
      }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(TaskReminder.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
