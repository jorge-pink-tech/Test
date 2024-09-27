//
// Copyright © 2024 PinkTech. All rights reserved.
//

import UserDatabase
import XCTest

@testable import UserApi

final class UserTests: XCTestCase {

    // MARK: Overriden methods
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Tests

    func testThatUserInitialization() {
        // Given
        let id = UUID()
        let countryCode = "US"
        let createdAt = Date()
        let email = "user@example.com"
        let firstName = "John"
        let lastName = "Doe"
        let phone = "123-456-7890"
        let updatedAt = Date()

        // When
        let user = User(
            id: id,
            countryCode: countryCode,
            createdAt: createdAt,
            email: email,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            updatedAt: updatedAt
        )

        // Then
        XCTAssertEqual(user.id, id)
        XCTAssertEqual(user.countryCode, countryCode)
        XCTAssertEqual(user.createdAt, createdAt)
        XCTAssertEqual(user.email, email)
        XCTAssertEqual(user.firstName, firstName)
        XCTAssertEqual(user.lastName, lastName)
        XCTAssertEqual(user.phone, phone)
        XCTAssertEqual(user.updatedAt, updatedAt)
    }
    
    func testThatUserFromDTO() throws {
        // Given
        let userDTO = UserDTO(
            id: UUID(),
            countryCode: "US",
            email: "user@example.com",
            firstName: "John",
            lastName: "Doe",
            phone: "123-456-7890"
        )

        // When
        let user = try User.from(userDTO)

        // Then
        XCTAssertEqual(user.id, try userDTO.requireID())
        XCTAssertEqual(user.countryCode, userDTO.countryCode)
        XCTAssertEqual(user.createdAt, userDTO.createdAt)
        XCTAssertEqual(user.email, userDTO.email)
        XCTAssertEqual(user.firstName, userDTO.firstName)
        XCTAssertEqual(user.lastName, userDTO.lastName)
        XCTAssertEqual(user.phone, userDTO.phone)
        XCTAssertEqual(user.updatedAt, userDTO.updatedAt)
    }
}
