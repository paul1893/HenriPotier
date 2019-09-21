import Foundation

protocol BooksInteractor {
    func loadBooks()
    func setSelected(for isbn: String, to isSelected: Bool)
}

class BooksInteractorImpl : BooksInteractor {
    private let remoteRepository: RemoteBooksRepository
    private let localRepository: LocalBooksRepository
    private let presenter: BooksPresenter
    private let deviceManager: DeviceManager
    
    init(
        remoteRepository : RemoteBooksRepository,
        localRepository: LocalBooksRepository,
        presenter: BooksPresenter,
        deviceManager: DeviceManager
        ) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
        self.presenter = presenter
        self.deviceManager = deviceManager
    }
    
    func loadBooks() {
        if (!deviceManager.isOnline()) { // TODO PBA T.U
            let books = self.localRepository.getBooks()
            presenter.present(with: books)
            return
        }
        
        do {
            let books = try remoteRepository.getBooks()
            presenter.present(with: books)
            localRepository.deleteBooks() // TODO PBA T.U
            localRepository.save(books: books)
        } catch {
            presenter.presentError()
        }
    }
    
    func setSelected(for isbn: String, to isSelected: Bool) {
        if var book = localRepository.getBooks().first(where: { (book) -> Bool in
            book.isbn == isbn
        }) {
            book.isSelected = isSelected
            localRepository.deleteBook(isbn: isbn)
            localRepository.save(book: book)
        }
        presenter.presentBooksBadge(with: localRepository.getBooks().filter({$0.isSelected}).count)
    }
}
