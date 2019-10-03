import Foundation

class BooksController {
    private let interactor: BooksInteractor
    private let executor: Executor
    
    init(
        with interactor: BooksInteractor,
        executor: Executor = Executor()
        ) {
        self.interactor = interactor
        self.executor = executor
    }
    
    func viewDidLoad() {
        executor.run { [weak self] in
            self?.interactor.loadBooks()
        }
    }
    
    func pullToRefresh() {
        executor.run { [weak self] in
            self?.interactor.loadBooks()
        }
    }
    
    func checkChange(isbn: String, isSelected: Bool) {
        executor.run { [weak self] in
            self?.interactor.setSelected(for: isbn, to: isSelected)
        }
    }
}
