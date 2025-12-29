import Foundation
import SwiftUI
import UIKit

public protocol MicroFeature {
    var id: String { get }
    var title: String { get }
    var tabIcon: UIImage { get }
    var selectedTabIcon: UIImage { get }

    func makeRootView() -> AnyView
}

public protocol FeatureFactory {
    func makeFeature() -> MicroFeature
}

public protocol Analytics {
    func track(event: String)
}

/**
 *  APIs
 */

public protocol FeatureAPI {
    var networking: Networking { get }
}

public protocol FeedFeatureAPI: FeatureAPI {
    func fetchFeeds() async throws -> FeedDTO
}

public protocol FriendsFeatureAPI: FeatureAPI {
    func fetchFeeds() async throws -> FriendsDTO
}

public protocol ProfileFeatureAPI: FeatureAPI {
    func fetchFeeds() async throws -> ProfileDTO
}

/**
 *  Dependencies
 */

public protocol FeedDependencies {
    var feedAPI: FeedFeatureAPI { get }
    var analytics: Analytics { get }
}

public protocol FriendsDependencies {
    var friendsAPI: FriendsFeatureAPI { get }
    var analytics: Analytics { get }
}

public protocol ProfileDependencies {
    var profileAPI: ProfileFeatureAPI { get }
    var analytics: Analytics { get }
}

/**
 * DTOs
 */

public protocol FeedDTO {
    
}

public protocol FriendsDTO {
    
}

public protocol ProfileDTO {
    
}
