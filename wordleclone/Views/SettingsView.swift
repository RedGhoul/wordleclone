//
//  SettingsView.swift
//  wordleclone
//
//  Created by Shameem Reza on 1/3/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var csManager: ColorSchemeManager
    @EnvironmentObject var dm: WordleDataModel
    @Environment(\.dismiss) var dismiss
    @State private var showDifficultyPicker = false

    var body: some View {
        NavigationView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Difficulty Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Difficulty")
                                .font(.headline)
                            Button(action: {
                                showDifficultyPicker = true
                            }) {
                                HStack {
                                    Text(dm.difficulty.rawValue)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                            Text(dm.difficulty.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        // Hard Mode Toggle
                        Toggle("Hard Mode", isOn: $dm.hardMode)
                            .disabled(dm.difficulty.requiresHardMode)
                        if dm.difficulty.requiresHardMode {
                            Text("Hard mode is required for this difficulty")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Divider()

                        // Theme Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Change Theme")
                                .font(.headline)
                            Picker("Display Mode", selection: $csManager.colorScheme) {
                                Text("Dark").tag(ColorScheme.dark)
                                Text("Light").tag(ColorScheme.light)
                                Text("System").tag(ColorScheme.unspecified)
                            }
                            .pickerStyle(.segmented)
                        }

                        Spacer()
                    }.padding()
                    .navigationTitle("Options")
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
                    .sheet(isPresented: $showDifficultyPicker) {
                        DifficultyPickerView()
                            .environmentObject(dm)
                    }
                }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ColorSchemeManager())
            .environmentObject(WordleDataModel())
    }
}
