import UIKit

class HenriPotierModule {
    static var router: Router!
    
    static func booksViewController() -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: BooksViewController.self)) as! BooksViewController
        viewController.controller = BooksController(
            with: BooksInteractorImpl(
                remoteRepository: RemoteBooksRepositoryImpl(),
                localRepository: LocalBooksRepositoryImpl(),
                presenter: BooksPresenterImpl(
                    view: viewController
                ),
                deviceManager: DeviceManagerImpl()
            )
        )
        return viewController
    }
    
    static func basketViewController() -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: BasketViewController.self)) as! BasketViewController
        viewController.controller = BasketControllerImpl(
            with: BasketInteractorImpl(
                repository: BasketRepositoryImpl(),
                localBooksRepository: LocalBooksRepositoryImpl(),
                presenter: BasketPresenterImpl(view: viewController)
            )
        )
        return viewController
    }
}
