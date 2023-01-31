import Foundation

protocol MainListViewInput: AnyObject {
    func updateTableView(data: [ListItem])
    func performError(string: String)
}

protocol MainListViewOutput: AnyObject {
    func updateItems()
    func addItem(title: String)
    func deleteItem(item: ListItem)
    func editItem(item: ListItem, title: String)
    func openTaskVC(item: ListItem)
}


