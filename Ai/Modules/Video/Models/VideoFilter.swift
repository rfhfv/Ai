//
//  VideoFilter.swift
//  Ai
//
//  Created by admin on 27.06.2026.
//

import Foundation

enum VideoFilter: String, CaseIterable {
    case popular, funny, sad, trends,dance
    
    var title: String {
        switch self {
        case .popular: return "Popular"
        case .funny: return "Funny"
        case .sad: return "Sad"
        case .trends: return "Trends"
        case .dance: return "Dance"
        }
    }
}
