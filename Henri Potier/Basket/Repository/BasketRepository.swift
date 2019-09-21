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
            
            let discount = try parser.parse(data)
            
            var slice: Slice? = nil
            if let sliceValue = discount?.slice?.sliceValue,
                let value = discount?.slice?.value {
                slice = Slice(sliceValue: sliceValue, value: value)
            }
            
            return Discount(
                percentage: discount?.percentage,
                minus: discount?.minus,
                slice: slice
            )
        } else {
            throw RepositoryError.wrongUrl
        }
    }
}
