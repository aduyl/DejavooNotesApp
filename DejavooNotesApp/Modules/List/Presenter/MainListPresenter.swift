import UIKit

class MainListPresenter {
    private weak var view: MainListViewInput?
    private let router: MainListRouterInput
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistanteContainer.viewContext
    
    init(router: MainListRouterInput,
         view: MainListViewInput) {
        self.router = router
        self.view = view
    }
}

extension MainListPresenter: MainListViewOutput {
    func updateItems() {
        do {
            let items = try context.fetch(ListItem.fetchRequest())
            self.view?.updateTableView(data: items)
        } catch {
            view?.performError(string: FetchErrors.downloadError.rawValue.localized)
        }
    }
    
    func addItem(title: String) {
        let newItem = ListItem(context: context)
        newItem.title = title
        performContextAction(text: FetchErrors.addError.rawValue)
    }
    
    func deleteItem(item: ListItem) {
        context.delete(item)
        performContextAction(text: FetchErrors.deleteError.rawValue)
    }
    
    func editItem(item: ListItem, title: String) {
        item.title = title
        performContextAction(text: FetchErrors.editError.rawValue)
    }
    
    func openTaskVC(item: ListItem) {
        router.openTaskList(item)
    }
}

extension MainListPresenter {
    private func performContextAction(text: String) {
        do {
            try context.save()
            updateItems()
        } catch {
            view?.performError(string: text.localized)
        }
    }
}
