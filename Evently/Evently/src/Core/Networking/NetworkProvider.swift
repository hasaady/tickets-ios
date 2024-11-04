//
//  NetworkManager.swift
//  Evently
//
//  Created by Hanan on 01/11/2024.
//

import Foundation

public protocol NetworkProvider {
    func get<T: Decodable>(path: String) async throws -> T
    func post<T: Decodable, U: Encodable>(path: String, body: U) async throws -> T
}

extension NetworkProvider {
    var baseURL: String { "http://192.168.1.103:8080" }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}

class NetworkProviderImp: NetworkProvider {

    init() {}

    func get<T: Decodable>(path: String) async throws -> T {
        let urlString = baseURL.appending(path)
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard
            let httpResponse = response as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode
        else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    func post<T: Decodable, U: Encodable>(path: String, body: U) async throws -> T {
        
        let urlString = baseURL.appending(path)
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let httpResponse = response as? HTTPURLResponse,
            200...299 ~= httpResponse.statusCode
        else {
            throw NetworkError.invalidResponse
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
