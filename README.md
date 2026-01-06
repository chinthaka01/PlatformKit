# PlatformKit

PlatformKit is a lightweight shared module that provides:

- Common **feature contracts** (`MicroFeature`, `FeatureFactory`, `FeatureAPI`, and dependencies)
- A simple **analytics abstraction** with predefined events
- A generic **networking layer** backed by `URLSession` and a demo BFF (JSONPlaceholder)

Feature modules (Feed, Friends, Profile) depend on PlatformKit instead of the shell app, which keeps them reusable and easy to integrate in different hosts.

***

## Modules & Responsibilities

### 1. Feature contracts

PlatformKit defines the core protocols that every micro‑feature and its APIs must conform to:

- `MicroFeature`
  - Common interface that the shell uses to render features as tabs.
  - Each feature exposes:
    - `id`: Unique identifier for tab selection and lookup.
    - `title`: Human‑readable tab title.
    - `tabIcon` / `selectedTabIcon`: `UIImage` icons used in the tab bar.
    - `makeRootView() -> AnyView`: Root SwiftUI view for the feature.
- `FeatureFactory`
  - Used by the shell to construct features without knowing their internals.
  - Each feature module exposes a factory that returns a configured `MicroFeature`.
- `FeatureAPI`
  - Base protocol for all feature‑specific network APIs.
  - Exposes a shared `networking: Networking` dependency.
- Feature‑specific APIs:
  - `FeedFeatureAPI`: Fetch, update, and delete `Post` models for the feed.
  - `FriendsFeatureAPI`: Fetch `User` models for the friends list.
  - `ProfileFeatureAPI`: Fetch the current user’s `User` profile.

PlatformKit also defines the dependency contracts that the shell must provide to features:

- `FeedDependencies`:
  - `feedAPI: FeedFeatureAPI`
  - `analytics: Analytics`
- `FriendsDependencies`:
  - `friendsAPI: FriendsFeatureAPI`
  - `analytics: Analytics`
- `ProfileDependencies`:
  - `profileAPI: ProfileFeatureAPI`
  - `analytics: Analytics`

This separation allows the shell to own composition (which concrete implementations to inject) while features only rely on small, focused protocols.

PlatformKit includes an `AppBroadcast` enum with app‑wide notification names such as `selfPostsCount`, which features can use for simple cross‑feature communication via `NotificationCenter`.

***

### 2. Analytics

PlatformKit defines a simple analytics abstraction and a demo implementation:

- `Analytics` protocol
  - Single method `track(_ event: AnalyticsEvent)` used by features and the shell to record user actions.
- `AnalyticsImpl`
  - Demo implementation that prints events to the console instead of sending them to a real backend.
  - If an event has parameters, it prints them alongside the event name.

Predefined analytics events:

- `AnalyticsEvent.appLaunched`
  - App successfully launched (e.g., called from the shell `ContentView` on appear).
- `AnalyticsEvent.tabSelected(title: String)`
  - User selected a tab; `title` describes which tab.
- `AnalyticsEvent.itemSelected(id:type:pageName:)`
  - User selected a specific item on a page.
  - Parameters:
    - `id`: Identifier of the selected item.
    - `type: ItemType`: Domain type (e.g., `.post`, `.friend`).
    - `pageName: PageName`: Origin page (e.g., `.feed`, `.friends`, `.profile`).

Each event exposes:

- `name: String`
  - Canonical event name (e.g., `"app_launched"`, `"tab_selected"`, `"item_selected"`).
- `parameters: [String: String]?`
  - Optional parameters encoded as strings for easy logging and backend integration.

Supporting enums:

- `ItemType`
  - `.post`, `.friend`
- `PageName`
  - `.feed`, `.friends`, `.profile`

These small enums provide consistent values for analytics parameters across the app.

***

### 3. Networking

PlatformKit provides a generic `Networking` protocol and a concrete `NetworkingImpl` backed by `URLSession` and JSONPlaceholder as the BFF:

- `Networking` protocol (constrained to `FeatureDataModel`)
  - `fetchSingle(bffPath:type:) async throws -> T`
    - Fetch a single model from `bffBase/bffPath` and decode to `T`.
  - `fetchList(bffPath:type:) async throws -> [T]`
    - Fetch a list of models from `bffBase/bffPath` and decode to `[T]`.
  - `updateRecord(bffPath:type:record:) async throws -> T`
    - Encode `record` as JSON, send a `PUT` to `bffBase/bffPath`, and decode the updated model.
  - `deleteRecord(bffPath:type:withID:) async throws`
    - Send a `DELETE` to `bffBase/bffPath/id` and validate the response.

- `NetworkingImpl`
  - `bffBase = "https://jsonplaceholder.typicode.com"`
    - Uses JSONPlaceholder as a free, fake REST API for demo purposes.
  - Uses `URLSession.shared` with Swift concurrency (`async/await`) for all operations.
  - Handles:
    - URL construction and `.badURL` errors.
    - Status code validation (2xx for reads and `200`/`204` for delete).
    - JSON encoding/decoding via `JSONEncoder` / `JSONDecoder`.
  - Logs delete success/failure messages to the console for debugging.

Features do not talk to `URLSession` directly; instead, they depend on their specific `FeatureAPI` (e.g., `FeedFeatureAPI`), which composes `Networking` internally. This keeps the network layer consistent and testable.

***

## How PlatformKit fits into the app

In the Wefriendz shell:

- `WefriendzApp` creates shared instances of:
  - `AnalyticsImpl` (as `Analytics`)
  - `NetworkingImpl` (as `Networking`)
- The shell builds:
  - Feature API clients (e.g., `FeedFeatureAPIClient(networking: networking)`).
  - Dependency containers (`FeedDependenciesImpl`, `FriendsDependenciesImpl`, `ProfileDependenciesImpl`) that conform to the PlatformKit dependency protocols.
  - Feature factories (`FeedFeatureFactory`, `FriendsFeatureFactory`, `ProfileFeatureFactory`) that conform to `FeatureFactory`.
- The shell collects all `MicroFeature`s from factories and passes them into `ContentView`, which renders them as tabs and calls `analytics.track(...)` for app and tab events.

This design allows each feature to be:

- **Isolated**: Features depend only on PlatformKit protocols and their own module code.
- **Composable**: The shell can add or remove features by updating the factories and `features` array.
- **Testable**: Analytics and networking can be mocked by providing different implementations of `Analytics` and `Networking` that still conform to the same protocols.
