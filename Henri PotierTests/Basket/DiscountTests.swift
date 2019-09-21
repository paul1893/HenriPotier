import XCTest
@testable import Henri_Potier

class DiscountTests: XCTestCase {
    
    func testGetBestDiscount() {
        // GIVEN
        let discountA = Discount(
            percentage: 5,
            minus: 15,
            slice: Slice(sliceValue: 100, value: 12)
            )
        let discountB = Discount(
            percentage: 50,
            minus: 15,
            slice: Slice(sliceValue: 100, value: 12)
        )
        let discountC = Discount(
            percentage: 5,
            minus: 15,
            slice: nil
        )
        
        // WHEN - THEN
        XCTAssertEqual(discountA.getBestDiscount(forPrice: 65), 15)
        XCTAssertEqual(discountA.getBestDiscount(forPrice: 247), 24)
        XCTAssertEqual(discountB.getBestDiscount(forPrice: 65), 50)
        XCTAssertEqual(discountB.getBestDiscount(forPrice: 247), 50)
        XCTAssertEqual(discountC.getBestDiscount(forPrice: 65), 15)
        XCTAssertEqual(discountC.getBestDiscount(forPrice: 247), 15)
    }
}
