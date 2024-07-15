import Foundation
import UIKit

class DIContainer {
    
    public static let shared = DIContainer()
    
    private var factories = [ServiceKey: ((DIContainer) -> Any)]()
    private var singletons = [ServiceKey: Any]()
    
    func register<T: Any>(forClass: T.Type, type: FactoryType, factory: @escaping ((DIContainer) -> T)) {
        factories[ServiceKey(objectIdentifier: ObjectIdentifier(forClass), factoryType: type)] = factory
    }
    
    func provide<T: Any>(ofClass: T.Type) -> T {
        let classObjectIdentifier = ObjectIdentifier(ofClass)
        guard let serviceKey = factories.keys.first(where: { $0.objectIdentifier == classObjectIdentifier }) else {
            fatalError("Unresolved Injection of type \( ofClass )")
        }
        switch serviceKey.factoryType {
        case .factory:
            print("DI: creating new instance of \( ofClass )")
            return factories[serviceKey]!(self) as! T
        case .singleton:
            var result: T!
            synced(singletons) {
                if let singleton = singletons[serviceKey] {
                    result = singleton as? T
                } else {
                    print("DI: creating singleton instance of \( ofClass )")
                    let singleton = factories[serviceKey]!(self) as! T
                    singletons[serviceKey] = singleton
                    result = singleton
                }
            }
            return result
        }
    }
}

private func synced(_ lock: Any, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

class ServiceInjector {
    static func provide<T: Any>(ofClass: T.Type, forOwner _: UIViewController) -> T {
        return DIContainer.shared.provide(ofClass: ofClass)
    }
    
    static func provide<T: Any>(ofClass: T.Type, forOwner _: AppDelegate) -> T {
        return DIContainer.shared.provide(ofClass: ofClass)
    }
}

enum FactoryType {
    case singleton
    case factory
}

private struct ServiceKey {
    let objectIdentifier: ObjectIdentifier
    let factoryType: FactoryType
}

extension ServiceKey: Hashable {
    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        return lhs.objectIdentifier == rhs.objectIdentifier && lhs.factoryType == rhs.factoryType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(objectIdentifier.hashValue)
        hasher.combine(self.factoryType.hashValue)
    }
}
