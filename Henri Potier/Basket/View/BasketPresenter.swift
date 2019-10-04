protocol BasketView : class {
    func showBasket(basket: BasketViewModel)
    func showDiscount(discount: DiscountViewModel)
}
    
protocol BasketPresenter {
    func present(books: [Book])
    func presentDiscount(price: Int)
}

class BasketPresenterImpl: BasketPresenter {
    private weak var view : BasketView?
    private let executor: Executor
    
    init(view: BasketView, executor: Executor = Executor()) {
        self.view = view
        self.executor = executor
    }
    
    func present(books: [Book]) {
        executor.runOnMain {
            self.view?.showBasket(basket: BasketViewModel(
                books: books.map({ (book) -> BasketBookViewModel in
                    BasketBookViewModel(
                        title: book.title,
                        price: "\(book.price) €"
                    )
                }),
                numberOfBooks: "x \(books.count)",
                totalPrice: "\(books.map(\.price).reduce(0, +)) €"
            ))
        }
    }
    
    func presentDiscount(price: Int) {
        executor.runOnMain {
            self.view?.showDiscount(discount:
                DiscountViewModel(
                    price: "- \(price) €"
                )
            )
        }
    }
}
