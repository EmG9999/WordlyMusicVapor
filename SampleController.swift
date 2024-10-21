//
//  SampleController.swift
//
//
//  Created by Apprenant 165 on 18/10/2024.
//

import Fluent
import Vapor
import FluentSQL

struct SampleController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let samples = routes.grouped("sample")
        
        samples.get(use: self.index)
        samples.post(use: self.create)
        samples.get("bypays", use: self.getSampleByPays)
        samples.get("byinstruments", use: self.getSampleByInstrument)
        samples.get("byUser", use: self.getSampleByUser)
        samples.get("byContinent", use: self.getSampleByContinent)
        samples.group(":sampleID")  { samples in
            samples.get(use: getSampleByID)
            samples.delete(use: delete)
            samples.put(use: update)
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [Sample] {
        return try await Sample.query(on: req.db).all()
    }
    @Sendable
    func create(req: Request) async throws -> Sample {
        let sample = try req.content.decode(Sample.self)
        try await sample.save(on: req.db)
        return sample
    }
    @Sendable
    func getSampleByID(req: Request) async throws -> Sample {
        guard let sample = try await
                Sample.find(req.parameters.get("sampleID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return sample
    }
   /*
    @Sendable
    func getSampleByInstrument(req: Request) async throws -> Sample {
        guard let instrument = req.query["instrument"] as String? else {
            throw Abort(.badRequest, reason: "Le parametre 'instrument' est invalide ou manquant.")
        }
        if let sql = req.db as? SQLDatabase {
            //let samples = try await sql.raw("SELECT * from Sample WHERE type_instrument = \(bind: instrument)")
            
            let samples = try await sql.raw("SELECT * from Sample WHERE type_instrument = \(bind: instrument)")
                .all(decodingFluent: Sample.self)
            
            guard let sample = samples.first else {
                throw Abort(.notFound, reason: "Sample non trouvé")
            }
            return sample
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
    */
    @Sendable
    func getSampleByInstrument(req: Request) async throws -> Sample {
        guard let instrument = req.query["instrument"] as String? else {
            throw Abort(.badRequest, reason: "Le parametre 'instrument' est invalide ou manquant.")
        }
        if let sql = req.db as? SQLDatabase {
            let samplees = try await sql.raw("SELECT * from Sample WHERE type_instrument = \(bind: instrument)")
                .all(decodingFluent: Sample.self)
            
            guard let samplee = samplees.first else {
                throw Abort(.notFound, reason: "Utilisateur non trouvé")
            }
            return samplee
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
    
    @Sendable
    func getSampleByPays(req: Request) async throws -> Sample {
        guard let pays = req.query["pays"] as String? else {
            throw Abort(.badRequest, reason: "Le parametre 'pays' est invalide ou manquant.")
        }
        if let sql = req.db as? SQLDatabase {
            let pays = try await sql.raw("SELECT * from Sample WHERE pays_instrument = \(bind: pays)")
                .all(decodingFluent: Sample.self)
            
            guard let pays = pays.first else {
                throw Abort(.notFound, reason: "Sample non trouvé")
            }
            return pays
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
    
    @Sendable
    func getSampleByUser(req: Request) async throws -> Sample {
        guard let user = req.query["user"] as String? else {
            throw Abort(.badRequest, reason: "Le parametre 'user' est invalide ou manquant.")
        }
        if let sql = req.db as? SQLDatabase {
            let user = try await sql.raw("SELECT * from Sample WHERE id_user = \(bind: user))")
                .all(decodingFluent: Sample.self)
            
            guard let users = user.first else {
                throw Abort(.notFound, reason: "Sample non trouvé")
            }
            return users
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
    
    @Sendable
    func getSampleByContinent(req: Request) async throws -> Sample {
        guard let continent = req.query["continent"] as String? else {
            throw Abort(.badRequest, reason: "Le parametre 'continent' est invalide ou manquant.")
        }
        if let sql = req.db as? SQLDatabase {
            let continent = try await sql.raw("SELECT * from Sample WHERE id_continent = \(bind: continent))")
                .all(decodingFluent: Sample.self)
            
            guard let continents = continent.first else {
                throw Abort(.notFound, reason: "Sample non trouvé")
            }
            return continents
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let users = try await
                Sample.find(req.parameters.get("sampleID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await users.delete(on: req.db)
        return .noContent
    }
    @Sendable
    func update(req: Request) async throws -> Sample {
        
        guard let sampleIDString = req.parameters.get ("sampleID"),
              let sampleID = UUID(uuidString: sampleIDString) else {
            throw Abort(.badRequest, reason: "ID d'utilisateur invalide.")
        }
        let updatedSample = try req.content.decode(Sample.self)
        
        guard let samples = try await Sample.find(sampleID, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé.")
        }
        
        // Mise à jour des propriétés
        samples.titre = updatedSample.titre
        samples.description = updatedSample.description
        samples.image = updatedSample.image
        samples.URL = updatedSample.URL
        samples.typeInstrument = updatedSample.typeInstrument
        samples.paysInstrument = updatedSample.paysInstrument
        samples.favoris = updatedSample.favoris
        
        
        try await samples.save(on: req.db)
        return samples
    }
}

