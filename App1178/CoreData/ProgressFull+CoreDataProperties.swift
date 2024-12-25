import Foundation
import CoreData


extension ProgressFull {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressFull> {
        return NSFetchRequest<ProgressFull>(entityName: "ProgressFull")
    }

    @NSManaged public var isFull: Bool

}

extension ProgressFull : Identifiable {

}
