import Foundation

protocol Parser{
    associatedtype T
    func parse(_ data: Data) throws -> T
}

class BookParser : Parser {
    typealias T = [BookJSON]
    func parse(_ data: Data) throws -> [BookJSON] {
        do {
            return try JSONDecoder().decode([BookJSON].self, from: data)
        } catch {
            throw RepositoryError.parsingError
        }
    }
}

struct BookJSON : Codable {
    var isbn: String
    var title: String
    var price: Int
    var cover: String
    var synopsis: [String]
}
