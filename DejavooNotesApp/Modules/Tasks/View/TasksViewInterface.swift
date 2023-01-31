import Foundation

protocol TasksViewInput: AnyObject {
    func updateTableView(data: ListItem)
    func performError(string: String)
}

protocol TasksViewOutput: AnyObject {
    func updateItems()
    func addTask(title: String)
    func deleteTask(item: TaskItem)
    func editTask(item: TaskItem, title: String?, state: Bool?)
}

protocol CellDelegate: AnyObject {
    func updateButtonState(_ isDone: Bool)
}

