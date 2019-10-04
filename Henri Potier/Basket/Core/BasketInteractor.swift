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
            .sorted(by: \.cover)
            .filter(by: \.isSelected)
        presenter.present(books: books)
        do {
            let discount = try repository.getDiscount(isbns: books.map(\.isbn)).value
            presenter.presentDiscount(price: discount)
        } catch {
            /* do nothing */
        }
    }
}
