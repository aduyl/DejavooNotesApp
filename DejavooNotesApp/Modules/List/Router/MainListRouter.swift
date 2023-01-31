import UIKit

class MainListRouter: MainListRouterInput {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func openTaskList(_ data: ListItem) {
        guard let vc = viewController else { return }
        let nextView = TasksAssembly().buildViewController(data)
        vc.navigationController?.pushViewController(nextView, animated: true)
    }
}
