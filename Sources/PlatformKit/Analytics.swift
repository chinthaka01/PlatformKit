//
//  File.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation

/**
 *  Just for the demo purpose.
 *  Not Using a actual backend analytics tool.
 *  Just printing the analytics log.
 */
public protocol Analytics {
    func track(_ event: AnalyticsEvent)
}

public final class AnalyticsImpl: Analytics {
    
    public init() {}
    
    public func track(_ event: AnalyticsEvent) {
        if let parameters = event.parameters, !parameters.isEmpty {
            print("📊 [Analytics] \(event.name) – \(parameters)")
        } else {
            print("📊 [Analytics] \(event.name)")
        }
    }
}

public enum AnalyticsEvent {
    case appLaunched
    case tabSelected(title: String)
    case itemSelected(id: Int, type: ItemType, pageName: PageName)
}

public enum ItemType: String {
    case post = "post"
    case friend = "friend"
}

public enum PageName: String {
    case feed = "feed"
    case friends = "friends"
    case profile = "profile"
}

public extension AnalyticsEvent {
    var name: String {
        switch self {
            case .appLaunched:  return "app_launched"
            case .tabSelected:  return "tab_selected"
            case .itemSelected: return "item_selected"
        }
    }

    var parameters: [String: String]? {
        switch self {
            case .appLaunched:
                return nil
            case .tabSelected(let title):
                return ["title": title]
            case .itemSelected(id: let id, type: let type, pageName: let pageName):
                return [
                    "id": "\(id)",
                    "type": type.rawValue,
                    "page_name": pageName.rawValue
                ]
            }
    }
}
