import XCTest
@testable import Henri_Potier

class RemoteBooksRepositoryTests: XCTestCase {
    
    class MockCaller : Caller {
        var data: Data? = Data()
        var error: Error? = nil
        
        func get(with url: URL) -> (Data?, Error?) {
            return (data, error)
        }
    }
    
    class MockParser : BookParser {
        private let error: RepositoryError?
        
        init(error: RepositoryError? = nil) {
            self.error = error
        }
        
        override func parse(_ data: Data) throws -> [BookJSON?] {
            if let error = error {
                throw error
            }
            return [
                BookJSON(isbn: "isbn", title: "Henri Potier", price: 35, cover: "cover", synopsis: "synopsis"),
                nil,
                BookJSON(isbn: "isbn", title: "Henri Potier", price: 35, cover: "cover", synopsis: "synopsis")
            ]
        }
    }
    
    func testGetBooks() {
        // GIVEN
        let mockCaller = MockCaller()
        let mockParser = MockParser()
        
        // WHEN
        let repository = RemoteBooksRepositoryImpl(mockCaller, mockParser)
        
        do {
            let result = try repository.getBooks()
            
            // THEN
            XCTAssertEqual(result[0], Book(isbn: "isbn", title: "Henri Potier", price: 35, cover: "cover", synopsis: "synopsis"))
            XCTAssertEqual(result[1], Book(isbn: "isbn", title: "Henri Potier", price: 35, cover: "cover", synopsis: "synopsis"))
            XCTAssertEqual(result.count, 2)
        } catch  {
            XCTFail()
        }
    }
    
    func testGetBooks_WhenServerError_BecauseErrorNotNil() {
        // GIVEN
        let mockCaller = MockCaller()
        mockCaller.error = RepositoryError.serverError
        let mockParser = MockParser()
        
        // WHEN
        let repository = RemoteBooksRepositoryImpl(mockCaller, mockParser)
        
        do {
            _ = try repository.getBooks()
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
    
    func testGetBooks_WhenServerError_BecauseDataIsNil() {
        // GIVEN
        let mockCaller = MockCaller()
        mockCaller.data = nil
        let mockParser = MockParser()
        
        // WHEN
        let repository = RemoteBooksRepositoryImpl(mockCaller, mockParser)
        
        do {
            _ = try repository.getBooks()
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
    
    func testGetBooks_WhenParserError() {
        // GIVEN
        let mockCaller = MockCaller()
        let mockParser = MockParser(error: RepositoryError.parsingError)
        
        // WHEN
        let repository = RemoteBooksRepositoryImpl(mockCaller, mockParser)
        
        do {
            _ = try repository.getBooks()
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
}
