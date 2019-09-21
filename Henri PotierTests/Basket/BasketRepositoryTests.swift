import XCTest
@testable import Henri_Potier

class BasketRepositoryTests: XCTestCase {
    
    class MockCaller : Caller {
        var data: Data? = Data()
        var error: Error? = nil
        
        func get(with url: URL) -> (Data?, Error?) {
            return (data, error)
        }
    }
    
    class MockParser : BasketParser {
        private let error: RepositoryError?
        var json = BasketJSON(percentage: 5, minus: 15, slice: SliceJSON(sliceValue: 100, value: 12))
        
        init(error: RepositoryError? = nil) {
            self.error = error
        }
        
        override func parse(_ data: Data) throws -> BasketJSON? {
            if let error = error {
                throw error
            }
            return json
        }
    }
    
    func testGetDiscount() {
        // GIVEN
        let caller = MockCaller()
        let parser = MockParser()
        
        // WHEN
        let repository = BasketRepositoryImpl(caller, parser)
        
        do {
            let result = try repository.getDiscount(isbns: ["isbn1", "isbn2"])
            
            // THEN
            XCTAssertEqual(result, Discount(percentage: 5, minus: 15, slice: Slice(sliceValue: 100, value: 12)))
        } catch  {
            XCTFail()
        }
    }
    
    func testGetDiscount_WhenValueIsNil() {
        // GIVEN
        let caller = MockCaller()
        let parser = MockParser()
        parser.json = BasketJSON(percentage: nil, minus: nil, slice: nil)
        
        // WHEN
        let repository = BasketRepositoryImpl(caller, parser)
        
        do {
            let result = try repository.getDiscount(isbns: ["isbn1", "isbn2"])
            
            // THEN
            XCTAssertEqual(result, Discount(percentage: nil, minus: nil, slice: nil))
        } catch  {
            XCTFail()
        }
    }
    
    func testGetDiscount_WhenServerError_BecauseErrorNotNil() {
        // GIVEN
        let mockCaller = MockCaller()
        mockCaller.error = RepositoryError.serverError
        let mockParser = MockParser()
        
        // WHEN
        let repository = BasketRepositoryImpl(mockCaller, mockParser)
        
        do {
            _ = try repository.getDiscount(isbns: [])
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
    
    func testGetDiscount_WhenServerError_BecauseDataIsNil() {
        // GIVEN
        let mockCaller = MockCaller()
        mockCaller.data = nil
        let mockParser = MockParser()
        
        // WHEN
        let repository = BasketRepositoryImpl(mockCaller, mockParser)
        
        do {
            _ = try repository.getDiscount(isbns: [])
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
    
    func testGetDiscount_WhenParserError() {
        // GIVEN
        let mockCaller = MockCaller()
        let mockParser = MockParser(error: RepositoryError.parsingError)
        
        // WHEN
        let repository = BasketRepositoryImpl(mockCaller, mockParser)
        
        do {
            _ = try repository.getDiscount(isbns: [])
            XCTFail()
        } catch {
            // THEN
            XCTAssertTrue(true)
        }
    }
}
