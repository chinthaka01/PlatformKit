//
//  Networking.swift
//  PlatformKit
//
//  Created by Chinthaka Perera on 12/24/25.
//

import Foundation

public protocol Networking: Sendable {
    func updateRecord<T: FeatureDataModel>(url: URL, type: T.Type, record: T) async throws -> T
    func deleteRecord<T: FeatureDataModel>(url: URL, type: T.Type, withID id: Int) async throws
    
    func fetchSingle<T: FeatureDataModel>(url: String,  type: T.Type) async throws -> T
    func fetchList<T: FeatureDataModel>(url: String, type: T.Type) async throws -> [T]
}

public final class NetworkingImpl: Networking {
    
    public init() {}
    
    public func updateRecord<T: FeatureDataModel>(url: URL, type: T.Type, record: T) async throws -> T {
        let uploadData = try JSONEncoder().encode(record)

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
    
    public func deleteRecord<T: FeatureDataModel>(url: URL, type: T.Type, withID id: Int) async throws {
        guard let url = URL(string: "\(url)/\(id)") else {
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
    
    public func fetchSingle<T: FeatureDataModel>(url: String, type: T.Type) async throws -> T {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public func fetchList<T: FeatureDataModel>(url: String, type: T.Type) async throws -> [T] {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([T].self, from: data)
    }
}
