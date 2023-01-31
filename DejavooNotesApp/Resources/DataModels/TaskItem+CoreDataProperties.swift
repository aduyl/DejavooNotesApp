//
//  TaskItem+CoreDataProperties.swift
//  
//
//  Created by mac on 29.01.2023.
//
//

import Foundation
import CoreData


extension TaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var name: String?
    @NSManaged public var list: ListItem?
    
    public var wrappedName: String {
        name ?? "Name"
    }
    
    public var wrappedIsDone: Bool {
        isDone
    }

}
extension TaskItem: DataDelegate {}
