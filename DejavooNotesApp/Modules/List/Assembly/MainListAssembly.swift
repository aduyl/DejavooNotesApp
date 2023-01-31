import UIKit
protocol Assembly {
    func buildViewController(_ data: AnyObject?) -> UIViewController
}

struct MainListAssembly: Assembly {
    func buildViewController(_ data: AnyObject? = nil) -> UIViewController {
        let viewController = MainListViewController()
        let router = MainListRouter(viewController: viewController)
        let presenter = MainListPresenter(router: router, view: viewController)
        
        viewController.output = presenter
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}


