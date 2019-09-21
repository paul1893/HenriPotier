import XCTest
@testable import Henri_Potier

class BasketPresenterTests: XCTestCase {    
    class MockView : BasketView {
        var showBasketFunction = false
        var showBasketFunctionValue: BasketViewModel? = nil
        var showDiscountFunction = false
        var showDiscountFunctionValue: DiscountViewModel? = nil
        
        func showBasket(basket: BasketViewModel) {
            showBasketFunction = true
            showBasketFunctionValue = basket
        }
        
        func showDiscount(discount: DiscountViewModel) {
            showDiscountFunction = true
            showDiscountFunctionValue = discount
        }
    }
    
    func testPresentBooks() {
        // GIVEN
        let view = MockView()
        let presenter = BasketPresenterImpl(view: view, executor: MockExecutor())
        
        // WHEN
        presenter.present(books: [
            Book(
                isbn: "isbn1",
                title: "Henri Potier à l'école des sorciers",
                price: 35,
                cover: "http://henri-potier.xebia.fr/hp0.jpg",
                synopsis: ""
            ),
            Book(
                isbn: "isbn2",
                title: "Henri Potier et la chambre des secrets",
                price: 30,
                cover: "http://henri-potier.xebia.fr/hp1.jpg",
                synopsis: ""
            )])
        
        // THEN
        XCTAssertTrue(view.showBasketFunction)
        XCTAssertEqual(view.showBasketFunctionValue, BasketViewModel(
            books: [
            BasketBookViewModel(
                title: "Henri Potier à l'école des sorciers",
                price: "35 €"
            ),
            BasketBookViewModel(
                title: "Henri Potier et la chambre des secrets",
                price: "30 €"
            )
            ],
            numberOfBooks: "x 2",
            totalPrice: "65 €"))
    }
    
    func testPresentDiscount() {
        // GIVEN
        let view = MockView()
        let presenter = BasketPresenterImpl(view: view, executor: MockExecutor())
        
        // WHEN
        presenter.presentDiscount(price: 5)
        
        // THEN
        XCTAssertTrue(view.showDiscountFunction)
        XCTAssertEqual(view.showDiscountFunctionValue, DiscountViewModel(price: "- 5 €"))
    }
}
