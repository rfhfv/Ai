//
//  NetworkError.swift
//  Ai
//
//  Created by admin on 23.06.2026.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(Int)
    case tokenMissing
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Неверный URL"
        case .noData: return "Нет данных"
        case .decodingError(let error): return "Ошибка декодирования: \(error)"
        case .serverError(let code): return "Ошибка сервера: \(code)"
        case .tokenMissing: return "Токен не найден"
        case .unknown(let error): return error.localizedDescription
        }
    }
}
