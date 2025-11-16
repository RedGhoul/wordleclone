//
//  DifficultyPickerView.swift
//  wordleclone
//
//  Created by Claude on 11/16/25.
//

import SwiftUI

struct DifficultyPickerView: View {
    @EnvironmentObject var dm: WordleDataModel
    @Environment(\.dismiss) var dismiss
    @State private var showNewGameAlert = false
    @State private var selectedDifficulty: DifficultyLevel

    init() {
        _selectedDifficulty = State(initialValue: .standard)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(DifficultyLevel.allCases, id: \.self) { level in
                    Button(action: {
                        if dm.gameStarted && level != dm.difficulty {
                            selectedDifficulty = level
                            showNewGameAlert = true
                        } else {
                            dm.difficulty = level
                            if level != dm.difficulty {
                                dm.newGame()
                            }
                        }
                    }) {
                        DifficultyRow(level: level, isSelected: dm.difficulty == level)
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Difficulty")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("**X**")
                    }
                }
            }
            .alert("Start New Game?", isPresented: $showNewGameAlert) {
                Button("Cancel", role: .cancel) { }
                Button("New Game") {
                    dm.difficulty = selectedDifficulty
                    dm.newGame()
                    dismiss()
                }
            } message: {
                Text("Changing difficulty will start a new game. Your current progress will be lost.")
            }
        }
    }
}

struct DifficultyRow: View {
    let level: DifficultyLevel
    let isSelected: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(level.rawValue)
                        .font(.headline)
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                Text(level.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct DifficultyPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyPickerView()
            .environmentObject(WordleDataModel())
    }
}
