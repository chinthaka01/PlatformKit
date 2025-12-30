//
//  User.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/24/25.
//

import Foundation

public struct User: FeatureDataModel {
    public var id: Int
    public var name: String
    public var username: String
    public var address: Address
    public var phone: String
    public var website: String
    public var company: Company
}

public struct Address: Codable, Identifiable, Sendable {
    public var id: Int?
    public var street: String
    public var suite: String
    public var city: String
    public var zipcode: String
    public var geo: Geo
}

public struct Company: Codable, Identifiable, Sendable {
    public var id: Int?
    public var name: String
    public var catchPhrase: String
    public var bs: String
}

public struct Geo: Codable, Identifiable, Sendable {
    public var id: Int?
    public var lat: String
    public var lng: String
}
