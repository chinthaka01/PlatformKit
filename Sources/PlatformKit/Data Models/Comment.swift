//
//  Comment.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/24/25.
//

import Foundation

public struct Comment: FeatureDataModel {
    public var id: Int?
    public var postId: Int
    public var name: String
    public var email: String
    public var body: String
}
