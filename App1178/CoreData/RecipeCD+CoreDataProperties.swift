import Foundation
import CoreData


extension RecipeCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeCD> {
        return NSFetchRequest<RecipeCD>(entityName: "RecipeCD")
    }

    @NSManaged public var uuid: UUID
    @NSManaged public var image: Data
    @NSManaged public var name: String
    @NSManaged public var technique: String
    @NSManaged public var portions: String
    @NSManaged public var time: Int32
    @NSManaged public var category: String
    @NSManaged public var ingredients: String
    @NSManaged public var preparations: String
    @NSManaged public var state: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var currentTime: Int32

}

extension RecipeCD : Identifiable {

}
