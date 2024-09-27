//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent

extension FieldKey {
    /// Creates a new instance of the `FieldKey` from a raw value.
    ///
    /// - Parameter value: The type that can be converted to and from an associated raw string value.
    public static func string<Value: RawRepresentable>(_ value: Value) -> FieldKey where Value.RawValue == String {
        .string(value.rawValue)
    }
}
