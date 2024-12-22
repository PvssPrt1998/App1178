import Foundation
import CoreData


extension CurrentAchievementIndex {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentAchievementIndex> {
        return NSFetchRequest<CurrentAchievementIndex>(entityName: "CurrentAchievementIndex")
    }

    @NSManaged public var index: Int32

}

extension CurrentAchievementIndex : Identifiable {

}
