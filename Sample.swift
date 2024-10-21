//
//  Sample.swift
//
//
//  Created by Apprenant 165 on 18/10/2024.
//

import Fluent
import struct Foundation.UUID
import Vapor

final class Sample: Model, Content, @unchecked Sendable {
    static let schema = "Sample"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "titre")
    var titre: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "URL")
    var URL: String
    
    @Field(key: "type_instrument")
    var typeInstrument: String
    
    @Field(key: "pays_instrument")
    var paysInstrument: String
    
    @Field(key: "id_user")
    var id_user: UUID?
    
    @Field(key: "id_continent")
    var id_continent: UUID?
    
    @Field(key: "favoris")
    var favoris: Int
    
    
    init() { }
    
    init(id: UUID? = nil, titre: String, description: String, image: String, URL: String, typeInstrument: String, paysInstrument: String, id_user: UUID? = nil, id_continent: UUID? = nil, favoris: Int) {
        self.id = id
        self.titre = titre
        self.description = description
        self.image = image
        self.URL = URL
        self.typeInstrument = typeInstrument
        self.paysInstrument = paysInstrument
        self.id_continent = id_continent
        self.id_user = id_user
        self.favoris = favoris
    }
}
