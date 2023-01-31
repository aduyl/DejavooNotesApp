import UIKit

struct TasksAssembly: Assembly {
    func buildViewController(_ data: AnyObject?) -> UIViewController {
        let viewController = TasksViewController()
        guard let listItem = data as? ListItem else { return UIViewController() }
        let presenter = TasksPresenter(view: viewController, listItem: listItem)

        viewController.output = presenter
        viewController.presenter = presenter
        return viewController
    }

}


