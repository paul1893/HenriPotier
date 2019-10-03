import Foundation

protocol RemoteBooksRepository {
    func getBooks() throws -> [Book]
}

class RemoteBooksRepositoryImpl : RemoteBooksRepository {
    private let caller: Caller
    private let parser: BookParser
    private func apiUrl() -> String  {
        return "http://henri-potier.xebia.fr/books"
    }
    
    init(_ caller: Caller = CallerImpl(), _ parser: BookParser = BookParser()) {
        self.caller = caller
        self.parser = parser
    }
    
    func getBooks() throws -> [Book]  {
        if let url = URL(string: apiUrl()) {
            let (receivedData, error) = caller.get(with: url)
            guard error == nil else { throw RepositoryError.serverError }
            guard let data = receivedData else { throw RepositoryError.serverError }
            
            let books = try parser.parse(data)
            return books.map({
                Book(
                    isbn: $0.isbn,
                    title: $0.title,
                    price: $0.price,
                    cover: $0.cover,
                    synopsis: $0.synopsis.joined()
                )
            })
        } else {
            throw RepositoryError.wrongUrl
        }
    }
}

enum RepositoryError: Error {
    case serverError
    case parsingError
    case wrongUrl
}

