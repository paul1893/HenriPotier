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
        executor.run {
            self.interactor.loadBooks()
        }
    }
    
    func checkChange(isbn: String, isSelected: Bool) {
        executor.run {
            self.interactor.setSelected(for: isbn, to: isSelected)
        }
    }
}
