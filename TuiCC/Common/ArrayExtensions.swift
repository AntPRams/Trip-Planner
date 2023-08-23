import Foundation

extension Array {
    
    @inlinable
    public var isNotEmpty: Bool {
        self.count > 0
    }
}

extension Array where Element: Hashable {
    
    mutating func removeDuplicates() {
        var addedDict = [Element: Bool]()
        
        self = filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
