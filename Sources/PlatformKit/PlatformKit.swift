import Foundation
import SwiftUI
import UIKit

/// Protocol that each micro feature must conform to.
///
/// The shell uses this to render features as tabs without knowing
/// their internal implementation details.
public protocol MicroFeature {
    
    /// Unique identifier for the feature, used for tab selection and lookups.
    var id: String { get }
    
    /// Title shown in the tab bar and analytics.
    var title: String { get }
    
    /// Default icon image for the tab bar item.
    var tabIcon: UIImage { get }
    
    /// Icon image used when the tab is selected.
    var selectedTabIcon: UIImage { get }

    /// Root SwiftUI view for the feature.
    ///
    /// The shell embeds this view inside its navigation hierarchy.
    func makeRootView() -> AnyView
}

/// Factory used by the shell app to create a feature.
///
/// Keeps feature construction and dependency wiring outside the
/// shell UI code so each feature can be composed independently.
public protocol FeatureFactory {
    
    /// Builds and returns a fully configured `MicroFeature`.
    func makeFeature() -> MicroFeature
}

/// Base protocol for all feature network APIs.
///
/// Provides access to the shared networking infrastructure
/// without exposing concrete implementation details.
public protocol FeatureAPI {
    
    /// Shared networking implementation used by the feature.
    var networking: Networking { get }
}

/// Feed feature API used by the Feed module.
///
/// This talk to the Feed BFF and map
/// responses into `Post` models.
public protocol FeedFeatureAPI: FeatureAPI, Sendable {
    
    /// Fetches all posts for the feed.
    func fetchFeeds() async throws -> [Post]
    
    /// Updates a single post and returns the updated model.
    func updatePost(_ post: Post) async throws -> Post
    
    /// Deletes a single post.
    func deletePost(_ post: Post) async throws
}

/// Friends feature API used by the Friends module.
///
/// Responsible for loading the list of friends for the current user.
public protocol FriendsFeatureAPI: FeatureAPI, Sendable {
    
    /// Fetches all friends for the current user.
    func fetchFriends() async throws -> [User]
}

/// Profile feature API used by the Profile module.
///
/// Responsible for loading the current user's profile.
public protocol ProfileFeatureAPI: FeatureAPI, Sendable {
    
    /// Fetches the current user's profile.
    func fetchProfile() async throws -> User
}

/// Dependencies required by the Feed feature.
///
/// The shell app creates a concrete implementation and injects it
/// into `FeedFeatureFactory` when building the feature.
public protocol FeedDependencies {
    
    /// API client used by the Feed feature to talk to the BFF.
    var feedAPI: FeedFeatureAPI { get }
    
    /// Analytics implementation used to track user actions.
    var analytics: Analytics { get }
}

/// Dependencies required by the Friends feature.
public protocol FriendsDependencies {
    
    /// API client used by the Friends feature to talk to the BFF.
    var friendsAPI: FriendsFeatureAPI { get }
    
    /// Analytics implementation used to track user actions.
    var analytics: Analytics { get }
}

/// Dependencies required by the Profile feature.
public protocol ProfileDependencies {
    
    /// API client used by the Profile feature to talk to the BFF.
    var profileAPI: ProfileFeatureAPI { get }
    
    /// Analytics implementation used to track user actions.
    var analytics: Analytics { get }
}

/// App‑wide broadcast message names.
///
/// Used to send simple notifications between features in this demo.
public enum AppBroadcast {

    /// Notification name for the count of posts belonging
    /// to the currently logged‑in user.
    public static let selfPostsCount = Notification.Name("selfPostsCount")
}
