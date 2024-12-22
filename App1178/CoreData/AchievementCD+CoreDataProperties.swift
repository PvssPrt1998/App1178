import Foundation
import CoreData


extension AchievementCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AchievementCD> {
        return NSFetchRequest<AchievementCD>(entityName: "AchievementCD")
    }

    @NSManaged public var title: String
    @NSManaged public var progress: Double

}

extension AchievementCD : Identifiable {

}
