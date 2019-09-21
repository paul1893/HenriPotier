import Foundation

struct Book : Equatable {
    var isbn: String
    var title: String
    var price: Int
    var cover: String
    var synopsis: String
    var isSelected: Bool
    
    public init(
        isbn: String,
        title: String,
        price: Int,
        cover: String,
        synopsis: String,
        isSelected: Bool = false
        ) {
        self.isbn = isbn
        self.title = title
        self.price = price
        self.cover = cover
        self.synopsis = synopsis
        self.isSelected = isSelected
    }
}
