import XCTest
@testable import Henri_Potier

class BooksPresenterTests: XCTestCase {
    private let book = Book(
        isbn: "c8fabf68-8374-48fe-a7ea-a00ccd07afff",
        title: "Henri Potier à l'école des sorciers",
        price: 35,
        cover: "http://henri-potier.xebia.fr/hp0.jpg",
        synopsis: ""
    )
    
    class MockView : BooksView {
        var showEmptyBooksFunction = false
        var showErrorFunction = false
        var showErrorFunctionValue: String? = nil
        var showBooksFunction = false
        var showBooksFunctionValue: [BookViewModel]? = nil
        var showEmptyBadgeFunction = false
        var showBadgeFunction = false
        var showBadgeFunctionValue: Int? = nil
        
        func showEmptyBooks() {
            showEmptyBooksFunction = true
        }
        
        func showError(message: String) {
            showErrorFunction = true
            showErrorFunctionValue = message
        }
        
        func showBooks(with books: [BookViewModel]) {
            showBooksFunction = true
            showBooksFunctionValue = books
        }
        
        func showEmptyBadge() {
            showEmptyBadgeFunction = true
        }
        
        func showBadge(_ badgeCount: Int) {
            showBadgeFunction = true
            showBadgeFunctionValue = badgeCount
        }
    }
    
    func testPresentBooks() {
        // GIVEN
        let view = MockView()
        let presenter = BooksPresenterImpl(view: view, executor: MockExecutor())
        
        // WHEN
        presenter.present(with: [book])
        
        // THEN
        XCTAssertTrue(view.showBooksFunction)
        XCTAssertEqual(view.showBooksFunctionValue, [BookViewModel(
            isbn: "c8fabf68-8374-48fe-a7ea-a00ccd07afff",
            cover: "http://henri-potier.xebia.fr/hp0.jpg"
        )])
    }
    
    func testPresentError() {
        // GIVEN
        let view = MockView()
        let presenter = BooksPresenterImpl(view: view, executor: MockExecutor())
        
        // WHEN
        presenter.presentError()
        
        // THEN
        XCTAssertTrue(view.showErrorFunction)
    }
    
    func testPresentBadge_WhenZero() {
        // GIVEN
        let view = MockView()
        let presenter = BooksPresenterImpl(view: view, executor: MockExecutor())
        
        // WHEN
        presenter.presentBooksBadge(with: 0)
        
        // THEN
        XCTAssertTrue(view.showEmptyBadgeFunction)
    }
    func testPresentBadge_WhenPositive() {
        // GIVEN
        let view = MockView()
        let presenter = BooksPresenterImpl(view: view, executor: MockExecutor())
        
        // WHEN
        presenter.presentBooksBadge(with: 1)
        
        // THEN
        XCTAssertTrue(view.showBadgeFunction)
        XCTAssertEqual(view.showBadgeFunctionValue, 1)
    }
}
