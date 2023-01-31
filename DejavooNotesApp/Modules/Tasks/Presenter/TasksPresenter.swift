import UIKit

class TasksPresenter {
    private weak var view: TasksViewInput?
    private var listItem: ListItem
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistanteContainer.viewContext
    
    init(view: TasksViewInput,
         listItem: ListItem) {
        self.view = view
        self.listItem = listItem
    }
}

extension TasksPresenter: TasksViewOutput {
    func updateItems() {
        self.view?.updateTableView(data: listItem)
    }
    
    func addTask(title: String) {
        let newTask = TaskItem(context: context)
        newTask.name = title
        newTask.isDone = false
        newTask.list = listItem
        performContextAction(text: FetchErrors.addError.rawValue)
    }
    
    func deleteTask(item: TaskItem) {
        context.delete(item)
        performContextAction(text: FetchErrors.deleteError.rawValue)
    }
    
    func editTask(item: TaskItem, title: String?, state: Bool?) {
        if let title = title {
            item.name = title
        } else if let _ = state {
            item.isDone.toggle()
        }
        performContextAction(text: FetchErrors.editError.rawValue)
    }
}

extension TasksPresenter {
    private func performContextAction(text: String) {
        do {
            try context.save()
            updateItems()
        } catch {
            view?.performError(string: text.localized)
        }
    }
}
