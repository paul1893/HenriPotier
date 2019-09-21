import XCTest
@testable import Henri_Potier

class BasketInteractorTests: XCTestCase {
    
    class MockRepository : BasketRepository {
        private let error : RepositoryError?
        
        init(error: RepositoryError? = nil) {
            self.error = error
        }
        
        func getDiscount(isbns: [String]) throws -> Discount {
            if let error = error {
                throw error
            }
            return Discount(percentage: 0, minus: 0, slice: Slice(sliceValue: 0, value: 0))
        }
    }
    class MockPresenter : BasketPresenter {
        var presentDiscountFunction = false
        var presentFunction = false
        var presentFunctionValue: [Book]? = nil
        
        func present(books: [Book]) {
            presentFunction = true
            presentFunctionValue = books
        }
        
        func presentDiscount(price: Int) {
            presentDiscountFunction = true
        }
    }
    
    func testLoadBooks() {
        // GIVEN
        let book1 = Book(
            isbn: "isbn",
            title: "title",
            price: 0,
            cover: "cover1",
            synopsis: "synopsis",
            isSelected: true
        )
        let book2 = Book(
            isbn: "isbn",
            title: "title",
            price: 0,
            cover: "cover2",
            synopsis: "synopsis",
            isSelected: true
        )
        let repository = MockRepository()
        let localBooksRepository = MockLocalBooksRepository()
        localBooksRepository.books = [book2, book1]
        let presenter = MockPresenter()
        let interactor = BasketInteractorImpl(
            repository: repository,
            localBooksRepository: localBooksRepository,
            presenter: presenter
        )
        
        // WHEN
        interactor.loadBasket()
        
        // THEN
        XCTAssertTrue(presenter.presentFunction)
        XCTAssertEqual(presenter.presentFunctionValue, [book1, book2])
        XCTAssertTrue(presenter.presentDiscountFunction)
    }
    
    func testLoadBooks_WhenBasketRepositoryThrowError() {
        // GIVEN
        let book = Book(
            isbn: "isbn",
            title: "title",
            price: 0,
            cover: "cover",
            synopsis: "synopsis",
            isSelected: true
        )
        let repository = MockRepository(error: RepositoryError.serverError)
        let localBooksRepository = MockLocalBooksRepository()
        localBooksRepository.books = [book]
        let presenter = MockPresenter()
        let interactor = BasketInteractorImpl(
            repository: repository,
            localBooksRepository: localBooksRepository,
            presenter: presenter
        )
        
        // WHEN
        interactor.loadBasket()
        
        // THEN
        XCTAssertTrue(presenter.presentFunction)
        XCTAssertEqual(presenter.presentFunctionValue, [book])
        XCTAssertFalse(presenter.presentDiscountFunction)
    }
    
}
