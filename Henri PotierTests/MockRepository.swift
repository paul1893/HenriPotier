@testable import Henri_Potier

class MockLocalBooksRepository : LocalBooksRepository {
    var books = [Book]()
    var deleteBooksFunction = false
    var deleteBookFunction = false
    var saveBooksFunction = false
    var saveBooksFunctionValue : [Book]? = nil
    var saveBookFunction = false
    var saveBookFunctionValue : Book? = nil
    
    func getBooks() -> [Book] {
        return books
    }
    
    func deleteBooks() {
        deleteBooksFunction = true
    }
    func deleteBook(isbn: String) {
        deleteBookFunction = true
    }
    func save(books: [Book]) {
        saveBooksFunction = true
        saveBooksFunctionValue = books
    }
    func save(book: Book) {
        saveBookFunction = true
        saveBookFunctionValue = book
    }
}
