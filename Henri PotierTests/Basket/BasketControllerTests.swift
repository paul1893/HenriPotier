import XCTest
@testable import Henri_Potier

class BasketControllerTests: XCTestCase {
    
    class MockInteractor : BasketInteractor {
        var loadBasketFunction = false
        
        func loadBasket() {
            loadBasketFunction = true
        }
    }
    
    func testViewWillAppear() {
        // GIVEN
        let interactor = MockInteractor()
        let controller = BasketControllerImpl(with: interactor, executor: MockExecutor())
        
        // WHEN
        controller.viewWillAppear()
        
        // THEN
        XCTAssertTrue(interactor.loadBasketFunction)
    }
    
}
