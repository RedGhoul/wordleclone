//
//  DifficultyRecommendationView.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

struct DifficultyRecommendationView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(spacing: 25) {
            // Title
            Text("Choose Your Difficulty")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            // Recommendation badge
            if let suggested = onboardingVM.selectedExperience?.suggestedDifficulty {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("We recommend **\(suggested.rawValue)** for you")
                        .font(.subheadline)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.yellow.opacity(0.15))
                .cornerRadius(20)
            }

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(DifficultyLevel.allCases, id: \.self) { level in
                        DifficultyOptionButton(
                            level: level,
                            isSelected: onboardingVM.selectedDifficulty == level,
                            isRecommended: level == onboardingVM.getSuggestedDifficulty()
                        ) {
                            onboardingVM.selectedDifficulty = level
                        }
                    }
                }
                .padding(.horizontal, 30)
            }

            Spacer()

            // Continue button
            Button(action: {
                onboardingVM.nextPage()
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(onboardingVM.canProceed ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!onboardingVM.canProceed)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

struct DifficultyOptionButton: View {
    let level: DifficultyLevel
    let isSelected: Bool
    let isRecommended: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(level.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    if isRecommended {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    }
                }

                Text(level.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
    }
}

struct DifficultyRecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyRecommendationView()
            .environmentObject(OnboardingViewModel())
    }
}
