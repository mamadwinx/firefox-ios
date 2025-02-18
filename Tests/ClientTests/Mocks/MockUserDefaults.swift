// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

@testable import Client

class MockUserDefaults: UserDefaultsInterface {
    // MARK: - Properties
    public var savedData: [String: Any?]

    // MARK: - Initializers
    init() {
        self.savedData = [:]
    }

    // MARK: - Public interface
    func set(_ value: Any?, forKey defaultName: String) {
        savedData[defaultName] = value
    }

    func object(forKey defaultName: String) -> Any? {
        return savedData[defaultName] ?? nil
    }

    func set(_ value: Bool, forKey defaultName: String) {
        savedData[defaultName] = value
    }

    func bool(forKey defaultName: String) -> Bool {
        return savedData[defaultName] as? Bool ?? false
    }

    func string(forKey defaultName: String) -> String? {
        return savedData[defaultName] as? String
    }

    func float(forKey defaultName: String) -> Float {
        return savedData[defaultName] as? Float ?? 0
    }

    func register(defaults registrationDictionary: [String: Any]) {}
}
