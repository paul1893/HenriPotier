import Foundation

protocol BasketRepository {
    func getDiscount(isbns: [String]) throws -> Discount
}

class BasketRepositoryImpl : BasketRepository {
    private let caller: Caller
    private let parser: BasketParser
    private func apiUrl(isbns: [String]) -> String  {
        return "http://henri-potier.xebia.fr/books/\(isbns.joined(separator: ","))/commercialOffers"
    }
    
    init(_ caller: Caller = CallerImpl(), _ parser: BasketParser = BasketParser()) {
        self.caller = caller
        self.parser = parser
    }
    
    func getDiscount(isbns: [String]) throws -> Discount {
        if let url = URL(string: apiUrl(isbns: isbns)) {
            let (receivedData, error) = caller.get(with: url)
            guard error == nil else { throw RepositoryError.serverError }
            guard let data = receivedData else { throw RepositoryError.serverError }
            
            guard let discount = try parser.parse(data).offers.first else { throw RepositoryError.serverError }
            
            return Discount(value: discount.value)
        } else {
            throw RepositoryError.wrongUrl
        }
    }
}
