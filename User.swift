//
//  User.swift
//
//
//  Created by Apprenant 165 on 18/10/2024.
//

import Fluent
import struct Foundation.UUID
import Vapor

final class User: Model, Content, @unchecked Sendable {
    static let schema = "User"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "nom")
    var nom: String
    
    @Field(key: "prenom")
    var prenom: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "mdp")
    var mdp: String
    
    @Field(key: "pseudo")
    var pseudo: String
    
    @Field(key: "photo_profil")
    var photoProfil: String
    
    @Field(key: "bio_profil")
    var bioProfil: String
    
   
    
    init() { }

    init(id: UUID? = nil, nom: String, prenom: String, email: String, mdp: String, pseudo: String, photoProfil: String, bioProfil: String) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.mdp = mdp
        self.pseudo = pseudo
        self.photoProfil = photoProfil
        self.bioProfil = bioProfil
        
    }
    
}
