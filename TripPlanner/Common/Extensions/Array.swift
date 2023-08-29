import Foundation

extension Array {
    public var isNotEmpty: Bool {
        !isEmpty
    }
}

extension Array where Element: Hashable {
    
    ///Will return a new array without duplicates
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    ///Will remove duplicates from a mutable array
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
