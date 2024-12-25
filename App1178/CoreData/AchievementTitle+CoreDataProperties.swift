import Foundation
import CoreData


extension AchievementTitle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AchievementTitle> {
        return NSFetchRequest<AchievementTitle>(entityName: "AchievementTitle")
    }

    @NSManaged public var title: String?
}

extension AchievementTitle : Identifiable {

}
