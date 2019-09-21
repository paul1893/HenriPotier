import Foundation

protocol BooksPresenter {
    func presentError()
    func present(with books: [Book])
    func presentBooksBadge(with badgeCount: Int)
}

protocol BooksView : class {
    func showError(message: String)
    func showBooks(with books: [BookViewModel])
    func showEmptyBooks() // TODO PBA
    func showEmptyBadge()
    func showBadge(_ badgeCount: Int)
}

class BooksPresenterImpl : BooksPresenter {
    private weak var view : BooksView?
    private let executor: Executor
    
    init(view: BooksView, executor: Executor = Executor()) {
        self.view = view
        self.executor = executor
    }
    
    func presentError() {
        executor.runOnMain {
            self.view?.showError(message:
                "Something went wrong cannot get the books".localized
            )
        }
    }
    
    func present(with books: [Book]) {
        if books.count == 0 {
            executor.runOnMain {
                self.view?.showEmptyBooks()
            }
        } else {
            let booksViewModel = books.map({ (book) -> BookViewModel in
                return BookViewModel(
                    isbn: book.isbn,
                    cover: book.cover,
                    isSelected: book.isSelected
                )
            })
            executor.runOnMain {
                self.view?.showBooks(with: booksViewModel)
            }
        }
    }
    
    func presentBooksBadge(with badgeCount: Int) {
        if badgeCount == 0 {
            executor.runOnMain {
                self.view?.showEmptyBadge()
            }
        } else {
            executor.runOnMain {
                self.view?.showBadge(badgeCount)
            }
        }
    }
}
