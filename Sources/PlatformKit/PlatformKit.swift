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

/**
 *  APIs
 */

public protocol FeatureAPI {
    var networking: Networking { get }
}

public protocol FeedFeatureAPI: FeatureAPI, Sendable {
    func fetchFeeds() async throws -> [Post]
    func updatePost(_ post: Post) async throws -> Post
    func deletePost(_ post: Post) async throws
}

public protocol FriendsFeatureAPI: FeatureAPI, Sendable {
    func fetchFriends() async throws -> [User]
}

public protocol ProfileFeatureAPI: FeatureAPI, Sendable {
    func fetchProfile() async throws -> User
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
 *  Broadcast
 */

public enum AppBroadcast {

    //  Notification name for the count of posts of the logged-in user.
    public static let selfPostsCount = Notification.Name("selfPostsCount")
}
