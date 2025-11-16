//
//  WelcomeView.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Large WORDLE title
            Text("WORDLE")
                .font(.system(size: 50, weight: .heavy))
                .foregroundColor(.primary)

            // Example tiles showing W-E-A-R-Y
            HStack(spacing: 4) {
                WelcomeTile(letter: "W", color: .correct)
                WelcomeTile(letter: "E", color: .misplaced)
                WelcomeTile(letter: "A", color: .wrong)
                WelcomeTile(letter: "R", color: .wrong)
                WelcomeTile(letter: "Y", color: .correct)
            }
            .padding(.vertical)

            // Description
            VStack(spacing: 12) {
                Text("Guess the 5-letter word")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("You have 6 tries to guess the word")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            // Get Started button
            Button(action: {
                onboardingVM.nextPage()
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .padding()
    }
}

struct WelcomeTile: View {
    let letter: String
    let color: Color

    var body: some View {
        Text(letter)
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(color)
            .cornerRadius(4)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(OnboardingViewModel())
    }
}
