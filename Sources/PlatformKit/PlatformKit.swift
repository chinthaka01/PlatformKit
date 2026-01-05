import Foundation
import SwiftUI
import UIKit

/**
 *  The protocol that to be confirmed by each micro frontends
 */
public protocol MicroFeature {
    var id: String { get }
    var title: String { get }
    var tabIcon: UIImage { get }
    var selectedTabIcon: UIImage { get }

    func makeRootView() -> AnyView
}

/**
 *  Factory used by the shell app to create a feature.
 *  Keeps feature construction and wiring outside the shell UI code.
 */
public protocol FeatureFactory {
    func makeFeature() -> MicroFeature
}

/**
 *  Base protocol for all feature network APIs.
 *  Provides shared networking infrastructure.
 */
public protocol FeatureAPI {
    var networking: Networking { get }
}

/**
 *  Feed feature API used by the Feed module.
 *  In a real app this would call the Feed BFF.
 */
public protocol FeedFeatureAPI: FeatureAPI, Sendable {
    func fetchFeeds() async throws -> [Post]
    func updatePost(_ post: Post) async throws -> Post
    func deletePost(_ post: Post) async throws
}

/**
 *  Friends feature API used by the Friends module.
 */
public protocol FriendsFeatureAPI: FeatureAPI, Sendable {
    func fetchFriends() async throws -> [User]
}

/**
 *  Profile feature API used by the Profile module.
 */
public protocol ProfileFeatureAPI: FeatureAPI, Sendable {
    func fetchProfile() async throws -> User
}

/**
 *  Dependencies required by each feature.
 *  The shell app creates these and injects them into the feature factories.
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
 *  App-wide broadcast message names.
 *  Used to send simple events between features in this demo.
 */
public enum AppBroadcast {

    //  Notification name for the count of posts of the logged-in user.
    public static let selfPostsCount = Notification.Name("selfPostsCount")
}
