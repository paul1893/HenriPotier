protocol BasketInteractor {
    func loadBasket()
}

class BasketInteractorImpl : BasketInteractor {
    private let repository: BasketRepository
    private let localBooksRepository: LocalBooksRepository
    private let presenter: BasketPresenter
    
    init(
        repository : BasketRepository,
        localBooksRepository: LocalBooksRepository,
        presenter: BasketPresenter
        ) {
        self.repository = repository
        self.localBooksRepository = localBooksRepository
        self.presenter = presenter
    }
    
    func loadBasket() {
        let books = localBooksRepository.getBooks()
            .sorted {$0.cover < $1.cover}
            .filter { (book) -> Bool in
            return book.isSelected
        }
        presenter.present(books: books)
        do {
            let discount = try repository.getDiscount(isbns: books.map({ $0.isbn })).value
            presenter.presentDiscount(price: discount)
        } catch {
            /* do nothing */
        }
    }
}
