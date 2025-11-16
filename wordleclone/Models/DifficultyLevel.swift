//
//  DifficultyLevel.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import Foundation

enum DifficultyLevel: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case casual = "Casual"
    case standard = "Standard"
    case hard = "Hard"
    case expert = "Expert"

    var description: String {
        switch self {
        case .beginner:
            return "6 attempts, common words, hints available"
        case .casual:
            return "6 attempts, standard words"
        case .standard:
            return "6 attempts, all words (classic Wordle)"
        case .hard:
            return "6 attempts, must use revealed clues"
        case .expert:
            return "5 attempts, must use revealed clues"
        }
    }

    var maxAttempts: Int {
        switch self {
        case .beginner, .casual, .standard, .hard:
            return 6
        case .expert:
            return 5
        }
    }

    var requiresHardMode: Bool {
        return self == .hard || self == .expert
    }

    var allowsHints: Bool {
        return self == .beginner
    }

    var wordListFilter: WordListFilter {
        switch self {
        case .beginner:
            return .common  // Most frequent words
        case .casual, .standard, .hard, .expert:
            return .all
        }
    }
}

enum WordListFilter {
    case common
    case all
}
