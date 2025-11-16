//
//  ReadyToPlayView.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

struct ReadyToPlayView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var dm: WordleDataModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Celebration icon
            Text("🎉")
                .font(.system(size: 80))

            // Title
            Text("You're All Set!")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Summary
            VStack(spacing: 12) {
                if let difficulty = onboardingVM.selectedDifficulty {
                    HStack(spacing: 8) {
                        Text("Difficulty:")
                            .foregroundColor(.secondary)
                        Text(difficulty.rawValue)
                            .fontWeight(.semibold)
                    }
                    .font(.title3)

                    Text(difficulty.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                if let difficulty = onboardingVM.selectedDifficulty, difficulty.allowsHints {
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("Hints are available!")
                            .font(.caption)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.yellow.opacity(0.15))
                    .cornerRadius(20)
                }
            }

            Spacer()

            // Motivational text
            VStack(spacing: 8) {
                Text("Ready to play?")
                    .font(.title3)
                    .fontWeight(.semibold)

                Text("You can change difficulty anytime in settings")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            // Start Playing button
            Button(action: {
                onboardingVM.completeOnboarding(dm: dm)
                dismiss()
            }) {
                Text("Start Playing")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

struct ReadyToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        ReadyToPlayView()
            .environmentObject(OnboardingViewModel())
            .environmentObject(WordleDataModel())
    }
}
