//
//  ExperienceQuestionView.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

struct ExperienceQuestionView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text("How familiar are you with Wordle?")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 60)
                .padding(.horizontal)

            Text("This helps us set the right difficulty for you")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            // Experience options
            VStack(spacing: 16) {
                ForEach(UserExperienceLevel.allCases, id: \.self) { level in
                    ExperienceButton(
                        level: level,
                        isSelected: onboardingVM.selectedExperience == level
                    ) {
                        onboardingVM.selectedExperience = level
                        // Auto-set suggested difficulty
                        onboardingVM.selectedDifficulty = level.suggestedDifficulty
                        // Wait a moment then proceed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onboardingVM.nextPage()
                        }
                    }
                }
            }
            .padding(.horizontal, 30)

            Spacer()
            Spacer()
        }
    }
}

struct ExperienceButton: View {
    let level: UserExperienceLevel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(level.icon)
                    .font(.title)

                VStack(alignment: .leading, spacing: 4) {
                    Text(level.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct ExperienceQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceQuestionView()
            .environmentObject(OnboardingViewModel())
    }
}
