//private struct NetworkProviderKey: InjectionKey {
//    static var currentValue: NetworkProviderInterface = NetworkProvider()
//}
//
//private struct MainViewModelKey: InjectionKey {
//    static var currentValue: MainViewModelInterface = MainViewModel()
//}
//
//extension InjectedValues {
//    var networkProvider: NetworkProviderInterface {
//        get { Self[NetworkProviderKey.self] }
//        set { Self[NetworkProviderKey.self] = newValue }
//    }
//    
//    var mainViewModel: MainViewModelInterface {
//        get { Self[MainViewModelKey.self] }
//        set { Self[MainViewModelKey.self] = newValue }
//    }
//}
