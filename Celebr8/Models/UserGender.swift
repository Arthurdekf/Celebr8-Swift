//
//  UserGender.swift
//  Celebr8
//
//  Created by Arthur Fedeli on 12/07/26.
//

enum UserGender: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case female
    case male
    case nonBinary
    case preferNotToSay
    
    var id: Self {
        self
    }
    
    var displayName: String {
        switch self {
        case .female:
            return "Feminino"
            
        case .male:
            return "Masculino"
            
        case .nonBinary:
            return "Não binário"
            
        case .preferNotToSay:
            return "Prefiro não informar"
        }
    }
}
