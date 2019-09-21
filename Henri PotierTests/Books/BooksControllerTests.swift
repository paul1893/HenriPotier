import XCTest
@testable import Henri_Potier

class BooksControllerTests: XCTestCase {

    class MockInteractor : BooksInteractor {
        var loadBooksFunction = false
        var setSelectedFunction = false
        var setSelectedFunctionParam1: String? = nil
        var setSelectedFunctionParam2: Bool? = nil
        
        func loadBooks() {
            loadBooksFunction = true
        }
        
        func setSelected(for isbn: String, to isSelected: Bool) {
            setSelectedFunction = true
            setSelectedFunctionParam1 = isbn
            setSelectedFunctionParam2 = isSelected
        }
    }

    func testViewDidLoad() {
        // GIVEN
        let interactor = MockInteractor()
        let controller = BooksController(with: interactor, executor: MockExecutor())
        
        // WHEN
        controller.viewDidLoad()
        
        // THEN
        XCTAssertTrue(interactor.loadBooksFunction)
    }
    
    func testPullToRefresh() {
        // GIVEN
        let interactor = MockInteractor()
        let controller = BooksController(with: interactor, executor: MockExecutor())
        
        // WHEN
        controller.pullToRefresh()
        
        // THEN
        XCTAssertTrue(interactor.loadBooksFunction)
    }
    
    func testCheckChange() {
        // GIVEN
        let interactor = MockInteractor()
        let controller = BooksController(with: interactor, executor: MockExecutor())
        
        // WHEN
        controller.checkChange(isbn: "isbn", isSelected: true)
        
        // THEN
        XCTAssertTrue(interactor.setSelectedFunction)
        XCTAssertEqual(interactor.setSelectedFunctionParam1, "isbn")
        XCTAssertEqual(interactor.setSelectedFunctionParam2, true)
    }

}
