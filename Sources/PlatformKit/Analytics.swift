//
//  File.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation

public final class AnalyticsImpl: Analytics {
    
    public init() {
        
    }
    
    public func track(_ event: String, parameters: [String : String]?) {
        if let parameters = parameters, !parameters.isEmpty {
            print("📊 [Analytics] \(event) – \(parameters)")
        } else {
            print("📊 [Analytics] \(event)")
        }
    }
}
