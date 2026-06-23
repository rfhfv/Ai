//
//  NetworkManager.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint, body: Encodable?, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() {}
    
    func request<T: Decodable>(endpoint: APIEndpoint, body: Encodable? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        guard let url = endpoint.url else{
            completion(.failure(.invalidURL))
            return
        }
        
        guard let token = KeychainManager.shared.get(forKey: KeychainKey.apiToken) else {
            completion(.failure(.tokenMissing))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
