//
//  HowToPlayView.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

struct HowToPlayView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel

    var body: some View {
        VStack(spacing: 25) {
            // Title
            Text("How to Play")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // Introduction
                    Text("After each guess, the color of the tiles will change to show how close your guess was to the word.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    Divider()

                    // Green example
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 4) {
                            ColoredTile(letter: "W", color: .correct)
                            ColoredTile(letter: "E", color: .unused)
                            ColoredTile(letter: "A", color: .unused)
                            ColoredTile(letter: "R", color: .unused)
                            ColoredTile(letter: "Y", color: .unused)
                        }
                        .padding(.horizontal)

                        Text("**W** is in the word and in the correct spot")
                            .font(.body)
                            .padding(.horizontal)
                    }

                    Divider()

                    // Yellow example
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 4) {
                            ColoredTile(letter: "P", color: .unused)
                            ColoredTile(letter: "I", color: .misplaced)
                            ColoredTile(letter: "L", color: .unused)
                            ColoredTile(letter: "L", color: .unused)
                            ColoredTile(letter: "S", color: .unused)
                        }
                        .padding(.horizontal)

                        Text("**I** is in the word but in the wrong spot")
                            .font(.body)
                            .padding(.horizontal)
                    }

                    Divider()

                    // Gray example
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 4) {
                            ColoredTile(letter: "V", color: .unused)
                            ColoredTile(letter: "A", color: .unused)
                            ColoredTile(letter: "G", color: .unused)
                            ColoredTile(letter: "U", color: .wrong)
                            ColoredTile(letter: "E", color: .unused)
                        }
                        .padding(.horizontal)

                        Text("**U** is not in the word in any spot")
                            .font(.body)
                            .padding(.horizontal)
                    }
                }
            }

            Spacer()

            // Next button
            Button(action: {
                onboardingVM.nextPage()
            }) {
                Text("Next")
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
    }
}

struct ColoredTile: View {
    let letter: String
    let color: Color

    var body: some View {
        Text(letter)
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(color == .unused ? .primary : .white)
            .frame(width: 50, height: 50)
            .background(color)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color == .unused ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 2)
            )
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
            .environmentObject(OnboardingViewModel())
    }
}
