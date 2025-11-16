//
//  OnboardingViewModel.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var selectedExperience: UserExperienceLevel?
    @Published var selectedDifficulty: DifficultyLevel?
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    let totalPages = 5

    var canProceed: Bool {
        switch currentPage {
        case 0, 1: // Welcome and How to Play
            return true
        case 2: // Experience Question
            return selectedExperience != nil
        case 3: // Difficulty Recommendation
            return selectedDifficulty != nil
        case 4: // Ready to Play
            return true
        default:
            return false
        }
    }

    func nextPage() {
        if currentPage < totalPages - 1 {
            withAnimation {
                currentPage += 1
            }
        }
    }

    func previousPage() {
        if currentPage > 0 {
            withAnimation {
                currentPage -= 1
            }
        }
    }

    func completeOnboarding(dm: WordleDataModel) {
        if let difficulty = selectedDifficulty {
            dm.difficulty = difficulty
        } else if let experience = selectedExperience {
            dm.difficulty = experience.suggestedDifficulty
        }
        hasCompletedOnboarding = true
        dm.newGame()
    }

    func getSuggestedDifficulty() -> DifficultyLevel {
        selectedExperience?.suggestedDifficulty ?? .standard
    }
}
