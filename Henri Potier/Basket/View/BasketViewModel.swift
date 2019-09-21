struct BasketViewModel : Equatable {
    var books: [BasketBookViewModel]
    var numberOfBooks: String
    var totalPrice: String
    
    init(books: [BasketBookViewModel], numberOfBooks: String, totalPrice: String) {
        self.books = books
        self.numberOfBooks = numberOfBooks
        self.totalPrice = totalPrice
    }
}

struct BasketBookViewModel : Equatable {
    var title: String
    var price: String
    
    init(title: String, price: String) {
        self.title = title
        self.price = price
    }
}

struct DiscountViewModel : Equatable {
    var price: String
    init(price: String) {
        self.price = price
    }
}
