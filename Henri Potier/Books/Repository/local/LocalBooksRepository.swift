import Foundation
import CoreData

protocol LocalBooksRepository {
    func deleteBooks()
    func deleteBook(isbn: String)
    func getBooks() -> [Book]
    func save(books: [Book])
    func save(book: Book)
}

class LocalBooksRepositoryImpl: LocalBooksRepository {
    
    private let tableName = "BookDb"
    private let context: NSManagedObjectContext
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Henri_Potier")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    init() {
        self.context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = persistentContainer.viewContext
    }
    
    func deleteBooks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            // Do nothing
        }
    }
    
    func deleteBook(isbn: String) {
        let fetchRequest: NSFetchRequest<BookDb> = BookDb.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            let objects = try context.fetch(fetchRequest)
            for obj in objects {
                context.delete(obj)
            }
        } catch {
            // Do nothing
        }
    }
    
    func getBooks() -> [Book] {
        var books = [Book]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                books.append(
                    Book(
                        isbn: data.value(forKey: "isbn") as! String,
                        title: data.value(forKey: "title") as! String,
                        price: data.value(forKey: "price") as! Int,
                        cover: data.value(forKey: "cover") as! String,
                        synopsis: data.value(forKey: "synopsis") as! String,
                        isSelected: data.value(forKey: "isSelected") as! Bool
                    )
                )
            }
        } catch {
            // Do nothing
        }
        return books
            .compactMap({$0})
        }
    
    func save(books: [Book]) {
        books.forEach { (book) in
            save(book: book)
        }
    }
    
    func save(book: Book) {
        if let entity = NSEntityDescription.entity(forEntityName: tableName, in: context) {
            let newBook = NSManagedObject(entity: entity, insertInto: context)
            newBook.setValue(book.isbn, forKey: "isbn")
            newBook.setValue(book.title, forKey: "title")
            newBook.setValue(book.price, forKey: "price")
            newBook.setValue(book.cover, forKey: "cover")
            newBook.setValue(book.synopsis, forKey: "synopsis")
            newBook.setValue(book.isSelected, forKey: "isSelected")
        }
        do {
            try context.save()
            try context.parent?.save()
        } catch {
            // Do nothing
        }
    }
}
