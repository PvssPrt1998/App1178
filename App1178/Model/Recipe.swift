import Foundation

struct Recipe: Hashable {
    let uuid: UUID
    var image: Data
    var name: String
    var technique: String
    var portions: String
    var time: Int
    var category: String
    var ingredients: String
    var preparation: String
    var state: Int
    var isFavorite: Bool
    
    var currentTime: Int
}

struct Achievement: Hashable {
    let title: String
    let description: String
    let image: String
    var progress: Double
}
