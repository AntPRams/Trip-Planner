struct InjectedValues {
    private static var current = InjectedValues()
    
    static subscript<T>(key: T.Type) -> T.Value where T: InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    static subscript<K>(_ keyPath: WritableKeyPath<InjectedValues, K>) -> K {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}
