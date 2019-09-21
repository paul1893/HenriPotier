import Foundation
import SwiftyJSON

protocol Parser{
    associatedtype T
    func parse(_ data: Data) throws -> T
}

class BookParser : Parser {
    typealias T = [BookJSON?]
    func parse(_ data: Data) throws -> [BookJSON?] {
        do {
            return try JSON(data: data).arrayValue.map({(json) -> [String : JSON] in json.dictionaryValue }).map({(arg0) -> BookJSON? in
                if let isbn = arg0["isbn"]?.stringValue,
                    let title = arg0["title"]?.stringValue,
                    let price = arg0["price"]?.intValue,
                    let cover = arg0["cover"]?.stringValue,
                    let synopsis = arg0["synopsis"]?.stringValue
                {
                    return BookJSON(
                        isbn: isbn,
                        title: title,
                        price: price,
                        cover: cover,
                        synopsis: synopsis
                    )
                } else {
                    return nil
                }
            })
        } catch {
            throw RepositoryError.parsingError
        }
    }
}

struct BookJSON {
    var isbn: String
    var title: String
    var price: Int
    var cover: String
    var synopsis: String
    
    init(
        isbn: String,
        title: String,
        price: Int,
        cover: String,
        synopsis: String
        ) {
        self.isbn = isbn
        self.title = title
        self.price = price
        self.cover = cover
        self.synopsis = synopsis
    }
}
