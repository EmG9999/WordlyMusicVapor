//
//  UserController.swift
//
//
//  Created by Apprenant 165 on 18/10/2024.
//

import Fluent
import Vapor
import FluentSQL

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("user")
        
        users.get(use: self.index)
        users.post(use: self.create)
        users.get("byemail", use: self.getUserByEmail)
        users.group(":userID")  {users in
            users.get(use: getUserByID)
            users.delete(use: delete)
            users.put(use: update)
        }
    }
    
    @Sendable
    func index(req: Request) async throws -> [User] {
        return try await User.query(on: req.db).all()
    }
    @Sendable
    func create(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user
    }
    @Sendable
    func getUserByID(req: Request) async throws -> User {
        guard let user = try await
                User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }
    @Sendable
    func getUserByEmail(req: Request) async throws -> User {
        guard let email = req.query["email"] as String? else {
            throw Abort(.badRequest, reason: "Le parametre 'email' est invalide ou manquant.")
        }
        if let sql = req.db as? SQLDatabase {
            let users = try await sql.raw("SELECT * from User WHERE email = \(bind: email)")
                .all(decodingFluent: User.self)
            
            guard let user = users.first else {
                throw Abort(.notFound, reason: "Utilisateur non trouvé")
            }
            return user
        }
        throw Abort(.internalServerError, reason: "La base de données n'est pas SQL.")
    }
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let users = try await
                User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await users.delete(on: req.db)
        return .noContent
    }
    @Sendable
    func update(req: Request) async throws -> User {
        
        guard let utilisateurIDString = req.parameters.get ("userID"),
              let utilisateurID = UUID(uuidString: utilisateurIDString) else {
            throw Abort(.badRequest, reason: "ID d'utilisateur invalide.")
        }
        let updatedUtilisateur = try req.content.decode(User.self)
        
        guard let users = try await User.find(utilisateurID, on: req.db) else {
            throw Abort(.notFound, reason: "Utilisateur non trouvé.")
        }
        
        // Mise à jour des propriétés
        users.nom = updatedUtilisateur.nom
        users.email = updatedUtilisateur.email
        users.mdp = updatedUtilisateur.mdp
        users.pseudo = updatedUtilisateur.pseudo
        users.photoProfil = updatedUtilisateur.photoProfil
        users.bioProfil = updatedUtilisateur.bioProfil
       
        
        try await users.save(on: req.db)
        return users
    }
}

