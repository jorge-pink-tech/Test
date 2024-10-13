//
// Copyright © 2024 PinkTech. All rights reserved.
//

import RediStack
import Utility
import XCTest

@testable import Storage

final class RedisStorageTests: XCTestCase {

    // MARK: Tests

    func testThatSaveInformationShouldSucceed() async throws {
        // Given
        let sut = try await RedisStorage.make(hostname: "localhost")

        // When
        try await sut.write("Value", forKey: "key")
        let value = try await sut.read(String.self, forKey: "key")

        // Then
        XCTAssertEqual(value, "Value")
    }

    func testThatDeleteInformationShouldSucceed() async throws {
        // Given
        let sut = try await RedisStorage.make(hostname: "localhost")
        var values: [String] = []

        // When
        try await sut.write("Value", forKey: "key")
        values.append(try await sut.read(String.self, forKey: "key") ?? "")

        try await sut.delete(key: "key")
        values.append(try await sut.read(String.self, forKey: "key") ?? "")

        // Then
        XCTAssertEqual(values, ["Value", ""])
    }

    func testThatReadInformationShouldFail() async throws {
        // Given
        let sut = try await RedisStorage.make(hostname: "localhost")
        var kountyError: KountyError?

        // When
        do {
            try await sut.write("Test1", forKey: "key")
            let _ = try await sut.read(Int.self, forKey: "key")
        } catch {
            kountyError = error as? KountyError
        }

        // Then
        XCTAssertEqual(kountyError?.kind as? StorageErrorReason, StorageErrorReason.readFailed)
    }
}
