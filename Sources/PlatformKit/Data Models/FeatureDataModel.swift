//
//  FeatureDataModel.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/24/25.
//

import Foundation

public protocol FeatureDataModel: Codable, Identifiable, Sendable {
    var id: Int? { get set }
}
