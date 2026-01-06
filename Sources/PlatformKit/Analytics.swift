//
//  File.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/23/25.
//

import Foundation

/// High‑level analytics abstraction used across the app.
///
/// Feature modules depend on this protocol instead of a concrete
/// analytics SDK so that the shell can decide how events are handled.
public protocol Analytics {
    
    /// Tracks a single analytics event.
    ///
    /// - Parameter event: A predefined `AnalyticsEvent` describing the action.
    func track(_ event: AnalyticsEvent)
}

/// Simple demo implementation of `Analytics`.
///
/// This implementation doesn't talk to a real backend analytics tool.
/// It just prints events and their parameters to the console for debugging.
public final class AnalyticsImpl: Analytics {
    
    public init() {}
    
    /// Prints the analytics event to the console.
    ///
    /// In a real app, this is where you'd forward the event to
    /// a third‑party analytics SDK or your own backend.
    public func track(_ event: AnalyticsEvent) {
        if let parameters = event.parameters, !parameters.isEmpty {
            print("📊 [Analytics] \(event.name) – \(parameters)")
        } else {
            print("📊 [Analytics] \(event.name)")
        }
    }
}

/// Predefined analytics events used in the app.
public enum AnalyticsEvent {
    
    /// Fired when the app successfully launches.
    case appLaunched
    
    /// Fired when the user selects a tab in the main shell.
    ///
    /// - Parameter title: The visible title of the selected tab.
    case tabSelected(title: String)
    
    /// Fired when a user selects a specific item on a given page of a list.
    ///
    /// - Parameters:
    ///   - id: id of the selected item.
    ///   - type: High‑level type of the item (for example, post or friend).
    ///   - pageName: The page where the selection happened.
    case itemSelected(id: Int, type: ItemType, pageName: PageName)
}

public extension AnalyticsEvent {
    
    /// Canonical event name used by the analytics backend.
    var name: String {
        switch self {
            case .appLaunched:  return "app_launched"
            case .tabSelected:  return "tab_selected"
            case .itemSelected: return "item_selected"
        }
    }

    /// Optional key‑value parameters attached to the event.
    ///
    /// Values are encoded as strings to make them easy to log
    /// and send to external analytics providers.
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

/// Types of the selected item's domain model.
///
/// Used to categorize `itemSelected` events.
public enum ItemType: String {
    case post = "post"
    case friend = "friend"
}

/// High‑level names of the pages in the app.
///
/// Used to describe where an event originated from.
public enum PageName: String {
    case feed = "feed"
    case friends = "friends"
    case profile = "profile"
}
