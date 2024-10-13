//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility
import XCTest

@testable import Storage

final class StorageTests: XCTestCase {

    // MARK: Tests

    func testThatSaveInformationShouldSucceed() async throws {
        // Given
        let sut = InMemoryStorage()

        // When
        try await sut.write("Test1", forKey: "key")
        let value = try await sut.read(String.self, forKey: "key")

        // Then
        XCTAssertEqual(value, "Test1")
    }

    func testThatReadInformationShouldFailOnDataTypeIsIncorrect() async throws {
        // Given
        let sut = InMemoryStorage()
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

    func testThatReadInformationShouldNil() async throws {
        // Given
        let sut = InMemoryStorage()

        // When
        try await sut.write("Test1", forKey: "key2")
        let value = try await sut.read(String.self, forKey: "key")

        // Then
        XCTAssertNil(value)
    }

    func testThatDeleteInformation() async throws {
        // Given
        let sut = InMemoryStorage()
        var values: [String] = []

        // When
        try await sut.write("Test1", forKey: "key2")
        values.append(try await sut.read(String.self, forKey: "key2") ?? "")

        try await sut.delete(key: "key2")
        values.append(try await sut.read(String.self, forKey: "key2") ?? "")

        // Then
        XCTAssertEqual(values, ["Test1", ""])
    }
}
