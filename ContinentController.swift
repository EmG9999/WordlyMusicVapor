//
//  ContinentController.swift
//
//
//  Created by Apprenant 165 on 18/10/2024.
//

import Fluent
import Vapor
import FluentSQL

struct ContinentController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let continents = routes.grouped("continent")
        
        continents.get(use: self.index)
        continents.post(use: self.create)
    }
    
    @Sendable
    func index(req: Request) async throws -> [Continent] {
        return try await Continent.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) async throws -> Continent {
        let continent = try req.content.decode(Continent.self)
        try await continent.save(on: req.db)
        return continent
    }
}

