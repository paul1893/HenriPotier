struct BookViewModel : Equatable {
    let isbn : String
    let cover : String
    var isSelected : Bool
    
    init(isbn: String, cover: String, isSelected: Bool = false) {
        self.isbn = isbn
        self.cover = cover
        self.isSelected = isSelected
    }
}
