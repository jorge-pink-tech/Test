//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import UserDatabase
import UserDatabaseTesting
import Utility
import Vapor
import XCTest
import XCTVapor

@testable import UserApi

final class UserRepositoryTests: XCTestCase {
    private var app: Application!
    private var userDatabase: Database!

    // MARK: Overriden methods
    
    override func setUpWithError() throws {
        app = Application(.testing)
        userDatabase = try app.testableUserDatabase()
    }

    override func tearDownWithError() throws {
        userDatabase = nil
        app.shutdown()
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    
    func testThatFindShouldSuccess() async throws {
        // Given
        let user = try await UserDTO.createMock(on: userDatabase)
        let sut = UserRepositoryImpl(userDatabase: userDatabase)
        
        // When
        let result = try await sut.find(by: user.email)
        
        // Then
        XCTAssertEqual(result, try .from(user))
    }
    
    func testThatFindShouldThrowANotFoundErrorWhenTheUserDoesNotExists() async throws {
        // Given
        var error: KountyAbortError!
        let sut = UserRepositoryImpl(userDatabase: userDatabase)
        
        // When
        do {
            _ = try await sut.find(by: "email@email.com")
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(error.reason, "Usuario no encontrado")
        XCTAssertEqual(error.localizedDescription, "Usuario no encontrado")
        XCTAssertEqual(error.status, .notFound)
    }
}
