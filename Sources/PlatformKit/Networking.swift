//
//  Networking.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/24/25.
//

import Foundation

/// High‑level networking abstraction used by feature modules.
///
/// Exposes generic operations for fetching, updating, and deleting
/// models from the backend‑for‑frontend (BFF) layer.
public protocol Networking: Sendable {
    
    /// Updates a single record at the given BFF path.
    func updateRecord<T: FeatureDataModel>(
        bffPath: String,
        type: T.Type,
        record: T
    ) async throws -> T
    
    /// Deletes a single record identified by `id` at the given BFF path.
    func deleteRecord<T: FeatureDataModel>(
        bffPath: String,
        type: T.Type,
        withID id: Int
    ) async throws
    
    /// Fetches a single model instance from the given BFF path.
    func fetchSingle<T: FeatureDataModel>(
        bffPath: String,
        type: T.Type
    ) async throws -> T
    
    /// Fetches a list of model instances from the given BFF path.
    func fetchList<T: FeatureDataModel>(
        bffPath: String,
        type: T.Type
    ) async throws -> [T]
}

/// Default implementation of `Networking` backed by `URLSession`.
///
/// Uses the JSONPlaceholder test API as the backend‑for‑frontend (BFF)
/// for this demo app.
public final class NetworkingImpl: Networking {
    
    /// Base URL of the demo BFF (JSONPlaceholder).
    public let bffBase = "https://jsonplaceholder.typicode.com"
    
    public init() {}
    
    /// Fetches a single resource from the given BFF path and decodes it as `T`.
    public func fetchSingle<T: FeatureDataModel>(bffPath: String, type: T.Type) async throws -> T {
        guard let url = URL(string: "\(bffBase)/\(bffPath)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// Fetches a list of resources from the given BFF path and decodes them as `[T]`.
    public func fetchList<T: FeatureDataModel>(bffPath: String, type: T.Type) async throws -> [T] {
        guard let url = URL(string: "\(bffBase)/\(bffPath)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([T].self, from: data)
    }
    
    /// Sends a PUT request to update the given record and returns the decoded response.
    public func updateRecord<T: FeatureDataModel>(bffPath: String, type: T.Type, record: T) async throws -> T {
        let uploadData = try JSONEncoder().encode(record)
        
        guard let url = URL(string: "\(bffBase)/\(bffPath)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData

        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let updatedRecord = try JSONDecoder().decode(T.self, from: data)
        return updatedRecord
    }
    
    /// Sends a DELETE request to remove a record with the given `id`.
    ///
    /// Logs the outcome for demo purposes and throws if the status code
    /// is not a successful delete response.
    public func deleteRecord<T: FeatureDataModel>(bffPath: String, type: T.Type, withID id: Int) async throws {
        guard let url = URL(string: "\(bffBase)/\(bffPath)/\(id)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
            print("Record \(id) deleted successfully! Status code: \(httpResponse.statusCode)")
        } else {
            print("Failed to delete record \(id). Status code: \(httpResponse.statusCode)")
            if let errorData = String(data: data, encoding: .utf8) {
                print("Server response: \(errorData)")
            }
            throw URLError(.cannotDecodeContentData)
        }
    }
}
