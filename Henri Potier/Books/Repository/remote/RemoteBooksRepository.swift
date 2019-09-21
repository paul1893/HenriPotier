import Foundation

protocol RemoteBooksRepository {
    func getBooks() throws -> [Book]
}

class RemoteBooksRepositoryImpl : RemoteBooksRepository {
    private let caller: Caller
    private let parser: BookParser
    private func apiUrl() -> String  {
        return "http://henri-potier.xebia.fr/books" //TODO PBA
    }
    
    init(_ caller: Caller = CallerImpl(), _ parser: BookParser = BookParser()) {
        self.caller = caller
        self.parser = parser
    }
    
    func getBooks() throws -> [Book]  {
        // TODO PBA
        if let url = URL(string: apiUrl()) {
            let (receivedData, error) = caller.get(with: url)
            guard error == nil else { throw RepositoryError.serverError }
            guard let data = receivedData else { throw RepositoryError.serverError }
            
            let books = try parser.parse(data)
                .compactMap({$0})
            
            return books.map({ (bookJSON) -> Book in
                Book(
                    isbn: bookJSON.isbn,
                    title: bookJSON.title,
                    price: bookJSON.price,
                    cover: bookJSON.cover,
                    synopsis: bookJSON.synopsis
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

