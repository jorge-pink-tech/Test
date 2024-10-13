//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Logging
import Vapor

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        
        try LoggingSystem.bootstrap(from: &env)
        
        let app = try await Application.make(env)
        
        do {
            let appBootstrapper = AppBootstrapper(application: app)
            let routeProvider = RouteProvider(application: app)
            
            try await appBootstrapper.bootstrap()
            try await routeProvider.register()
        } catch {
            app.logger.report(error: error)
            throw error
        }
        
        try await app.execute()
        try await app.asyncShutdown()
    }
}
