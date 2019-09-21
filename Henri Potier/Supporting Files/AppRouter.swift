import UIKit

protocol Router {
    func go(to: Link)
}

enum Link: Equatable {
    case books
    case basket
}

class AppRouter {
    var tabBarController: UITabBarController!
    
    func rootViewController() -> UITabBarController {
        tabBarController = UITabBarController()
        tabBarController.addChild(HenriPotierModule.booksViewController())
        tabBarController.addChild(HenriPotierModule.basketViewController())
        return tabBarController
    }
    
    fileprivate func showBooksViewController() {
        tabBarController.selectedViewController = HenriPotierModule.booksViewController()
    }
    
    fileprivate func showBasketViewController() {
        tabBarController.selectedViewController = HenriPotierModule.basketViewController()
    }
}

extension AppRouter: Router {
    func go(to link: Link) {
        switch link {
        case .books: showBooksViewController()
        case .basket: showBasketViewController()
        }
    }
}
