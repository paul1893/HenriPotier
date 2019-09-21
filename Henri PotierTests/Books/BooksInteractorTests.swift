import XCTest
@testable import Henri_Potier

class BooksInteractorTests: XCTestCase {
    private let book = Book(
        isbn: "c8fabf68-8374-48fe-a7ea-a00ccd07afff",
        title: "Henri Potier à l'école des sorciers",
        price: 35,
        cover: "http://henri-potier.xebia.fr/hp0.jpg",
        synopsis: "Après la mort de ses parents (Lily et James Potier), Henri est recueilli par sa tante Pétunia (la sœur de Lily) et son oncle Vernon à l'âge d'un an. Ces derniers, animés depuis toujours d'une haine féroce envers les parents du garçon qu'ils qualifient de gens \" bizarres \", voire de \" monstres \", traitent froidement leur neveu et demeurent indifférents aux humiliations que leur fils Dudley lui fait subir. Henri ignore tout de l'histoire de ses parents, si ce n'est qu'ils ont été tués dans un accident de voiture\n"
    )

    class MockRemoteRepository : RemoteBooksRepository {
        var books = [Book]()
        var loadBooksFunction = false
        
        private let error : RepositoryError?
        
        init(error: RepositoryError? = nil) {
            self.error = error
        }
        
        func getBooks() throws -> [Book] {
            loadBooksFunction = true
            if let error = error {
                throw error
            }
            return books
        }
    }
    class MockPresenter : BooksPresenter {
        var presentFunction = false
        var presentFunctionValue: [Book]? = nil
        var presentErrorFunction = false
        var presentBooksBadgeFunction = false
        var presentBooksBadgeFunctionValue: Int? = nil
        
        func present(with books: [Book]) {
            presentFunction = true
            presentFunctionValue = books
        }
        
        func presentError() {
            presentErrorFunction = true
        }
        
        func presentBooksBadge(with badgeCount: Int) {
            presentBooksBadgeFunction = true
            presentBooksBadgeFunctionValue = badgeCount
        }
    }
    
    class MockDeviceManager : DeviceManager {
        private var online: Bool
        init(online : Bool) {
            self.online = online
        }
        func isOnline() -> Bool {
            return online
        }
    }
    
    func testLoadBooks() {
        // GIVEN
        let remoteRepository = MockRemoteRepository()
        remoteRepository.books = [book]
        let localRepository = MockLocalBooksRepository()
        let presenter = MockPresenter()
        let deviceManager = MockDeviceManager(online: true)
        let interactor = BooksInteractorImpl(
            remoteRepository: remoteRepository,
            localRepository: localRepository,
            presenter: presenter,
            deviceManager: deviceManager
        )
        
        // WHEN
        interactor.loadBooks()
        
        // THEN
        XCTAssertTrue(remoteRepository.loadBooksFunction)
        XCTAssertTrue(presenter.presentFunction)
        XCTAssertEqual(presenter.presentFunctionValue, [book])
        XCTAssertTrue(localRepository.deleteBooksFunction)
        XCTAssertTrue(localRepository.saveBooksFunction)
        XCTAssertEqual(localRepository.saveBooksFunctionValue, [book])
    }
    
    func testLoadBooks_WhenRepositoryThrowError() {
        // GIVEN
        let mockRemoteRepository = MockRemoteRepository(error: RepositoryError.serverError)
        let localRepository = MockLocalBooksRepository()
        let mockPresenter = MockPresenter()
        let deviceManager = MockDeviceManager(online: true)
        let interactor = BooksInteractorImpl(
            remoteRepository: mockRemoteRepository,
            localRepository: localRepository,
            presenter: mockPresenter,
            deviceManager: deviceManager
        )
        
        // WHEN
        interactor.loadBooks()
        
        // THEN
        XCTAssertTrue(mockPresenter.presentErrorFunction)
    }
    
    func testLoadBooksWhenOffline() {
        // GIVEN
        let remoteRepository = MockRemoteRepository()
        remoteRepository.books = [book]
        let localRepository = MockLocalBooksRepository()
        localRepository.books = [Book(
            isbn: "isbn",
            title: "title",
            price: 0,
            cover: "cover",
            synopsis: "synopsis",
            isSelected: false
            )]
        let presenter = MockPresenter()
        let deviceManager = MockDeviceManager(online: false)
        let interactor = BooksInteractorImpl(
            remoteRepository: remoteRepository,
            localRepository: localRepository,
            presenter: presenter,
            deviceManager: deviceManager
        )
        
        
        // WHEN
        interactor.loadBooks()
        
        // THEN
        XCTAssertTrue(presenter.presentFunction)
        XCTAssertEqual(presenter.presentFunctionValue, [Book(
            isbn: "isbn",
            title: "title",
            price: 0,
            cover: "cover",
            synopsis: "synopsis",
            isSelected: false
            )])
    }
    
    func testSetSelected() {
        // GIVEN
        let mockRemoteRepository = MockRemoteRepository(error: RepositoryError.serverError)
        let localRepository = MockLocalBooksRepository()
        localRepository.books = [book]
        let mockPresenter = MockPresenter()
        let deviceManager = MockDeviceManager(online: true)
        let interactor = BooksInteractorImpl(
            remoteRepository: mockRemoteRepository,
            localRepository: localRepository,
            presenter: mockPresenter,
            deviceManager: deviceManager
        )
        
        
        // WHEN
        interactor.setSelected(for: "c8fabf68-8374-48fe-a7ea-a00ccd07afff", to: true)
        
        // THEN
        let expectedBook = Book(
        isbn: "c8fabf68-8374-48fe-a7ea-a00ccd07afff",
        title: "Henri Potier à l'école des sorciers",
        price: 35,
        cover: "http://henri-potier.xebia.fr/hp0.jpg",
        synopsis: "Après la mort de ses parents (Lily et James Potier), Henri est recueilli par sa tante Pétunia (la sœur de Lily) et son oncle Vernon à l'âge d'un an. Ces derniers, animés depuis toujours d'une haine féroce envers les parents du garçon qu'ils qualifient de gens \" bizarres \", voire de \" monstres \", traitent froidement leur neveu et demeurent indifférents aux humiliations que leur fils Dudley lui fait subir. Henri ignore tout de l'histoire de ses parents, si ce n'est qu'ils ont été tués dans un accident de voiture\n",
        isSelected: true
        )
        XCTAssertTrue(localRepository.deleteBookFunction)
        XCTAssertTrue(localRepository.saveBookFunction)
        XCTAssertEqual(localRepository.saveBookFunctionValue, expectedBook)
        XCTAssertTrue(mockPresenter.presentBooksBadgeFunction)
        XCTAssertEqual(mockPresenter.presentBooksBadgeFunctionValue, 0)
    }
    
}
