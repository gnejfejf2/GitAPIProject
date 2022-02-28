import UIKit

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let userDefaults = UserDefaults.standard
    var isEmpty: Bool {
        return userDefaults.object(forKey: key) == nil
    }

    var wrappedValue: T? {
        get { return userDefaults.object(forKey: key) as? T }
        set { userDefaults.setValue(newValue, forKey: key) }
    }

    var projectedValue: Self {
        get { self }
        set { self = newValue }
    }

    mutating func delete() {
        userDefaults.removeObject(forKey: key)
    }

}



//구조체 저장하기위해서 사용
@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "인코딩실패"
    case noValue = "해당값이없음"
    case unableToDecode = "디코딩실패"
    
    var errorDescription: String? {
        rawValue
    }
}
