//
//  Continent.swift
//  
//
//  Created by Apprenant 165 on 18/10/2024.
//

import Fluent
import struct Foundation.UUID
import Vapor

final class Continent: Model, Content, @unchecked Sendable {
    static let schema = "Continent"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "nom")
    var nom: String
    
    @Field(key: "image")
    var image: String
        
    init() { }
    
    init(id: UUID? = nil, nom: String, image: String) {
        self.id = id
        self.nom = nom
        self.image = image
    }
}
