//
//  OnboardingContainerView.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var onboardingVM = OnboardingViewModel()
    @EnvironmentObject var dm: WordleDataModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Main content
            TabView(selection: $onboardingVM.currentPage) {
                WelcomeView()
                    .tag(0)
                    .environmentObject(onboardingVM)

                HowToPlayView()
                    .tag(1)
                    .environmentObject(onboardingVM)

                ExperienceQuestionView()
                    .tag(2)
                    .environmentObject(onboardingVM)

                DifficultyRecommendationView()
                    .tag(3)
                    .environmentObject(onboardingVM)

                ReadyToPlayView()
                    .tag(4)
                    .environmentObject(onboardingVM)
                    .environmentObject(dm)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .interactiveDismissDisabled()

            // Skip button (only on first few pages)
            if onboardingVM.currentPage < 2 {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            // Skip directly to experience question
                            withAnimation {
                                onboardingVM.currentPage = 2
                            }
                        }) {
                            Text("Skip")
                                .font(.body)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                    Spacer()
                }
            }
        }
    }
}

struct OnboardingContainerView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingContainerView()
            .environmentObject(WordleDataModel())
    }
}
