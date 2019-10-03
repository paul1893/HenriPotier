import Foundation

class BasketParser : Parser {
    typealias T = BasketJSON
    func parse(_ data: Data) throws -> BasketJSON {
        do {
            return try JSONDecoder().decode(BasketJSON.self, from: data)
        } catch {
            throw RepositoryError.parsingError
        }
    }
}

struct BasketJSON : Codable {
    var offers: [DiscountJSON]
}

struct DiscountJSON : Codable {
    var type: String
    var value: Int
    var sliceValue: Int?
}
