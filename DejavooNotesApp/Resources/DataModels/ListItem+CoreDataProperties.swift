//
//  ListItem+CoreDataProperties.swift
//  
//
//  Created by mac on 29.01.2023.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var title: String?
    @NSManaged public var task: NSSet?
    
    public var wrappedTitle: String {
        title ?? "Title"
    }
    
    public var taskArray: [TaskItem] {
        let set = task as? Set<TaskItem> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for task
extension ListItem {

    @objc(insertObject:inTaskAtIndex:)
    @NSManaged public func insertIntoTask(_ value: ListItem, at idx: Int)

    @objc(removeObjectFromTaskAtIndex:)
    @NSManaged public func removeFromTask(at idx: Int)

    @objc(insertTask:atIndexes:)
    @NSManaged public func insertIntoTask(_ values: [ListItem], at indexes: NSIndexSet)

    @objc(removeTaskAtIndexes:)
    @NSManaged public func removeFromTask(at indexes: NSIndexSet)

    @objc(replaceObjectInTaskAtIndex:withObject:)
    @NSManaged public func replaceTask(at idx: Int, with value: ListItem)

    @objc(replaceTaskAtIndexes:withTask:)
    @NSManaged public func replaceTask(at indexes: NSIndexSet, with values: [ListItem])

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: ListItem)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: ListItem)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSOrderedSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSOrderedSet)

}

extension ListItem: DataDelegate {}
