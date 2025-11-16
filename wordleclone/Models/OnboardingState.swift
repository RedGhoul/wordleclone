//
//  OnboardingState.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import Foundation

enum UserExperienceLevel: String, Codable, CaseIterable {
    case never = "Never played before"
    case few = "Played a few times"
    case regular = "Play regularly"
    case expert = "Wordle expert"

    var suggestedDifficulty: DifficultyLevel {
        switch self {
        case .never:
            return .beginner
        case .few:
            return .casual
        case .regular:
            return .standard
        case .expert:
            return .hard
        }
    }

    var icon: String {
        switch self {
        case .never:
            return "🌱"
        case .few:
            return "🌿"
        case .regular:
            return "🌳"
        case .expert:
            return "🏆"
        }
    }
}
