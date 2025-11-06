# Developer Guide - Wordle Clone

## Table of Contents
- [Introduction](#introduction)
- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Code Flow](#code-flow)
- [Key Components](#key-components)
- [Data Models](#data-models)
- [Game Logic](#game-logic)
- [UI Components](#ui-components)
- [State Management](#state-management)
- [Persistence & iCloud Sync](#persistence--icloud-sync)

---

## Introduction

Welcome to the Wordle Clone developer guide! This document will help you understand the codebase architecture, code flow, and how all components work together. By the end of this guide, you'll be able to navigate the codebase confidently and understand how to make modifications.

### What is this project?

A fully-featured iOS Wordle clone built with **Swift** and **SwiftUI**, featuring:
- ✅ 6 attempts to guess a 5-letter word
- ✅ Hard Mode with enforced rules
- ✅ Statistics tracking with iCloud sync
- ✅ Dark/Light mode support
- ✅ Smooth animations (flip cards, shake effects)
- ✅ Share results functionality

### Tech Stack
- **Language:** Swift 5
- **Framework:** SwiftUI
- **Platform:** iOS (iPhone & iPad)
- **Persistence:** UserDefaults + iCloud Key-Value Store
- **Architecture:** MVVM (Model-View-ViewModel)

---

## Architecture Overview

The project follows a clean **MVVM architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────┐
│                    APP ENTRY POINT                      │
│              wordlecloneApp.swift                       │
│    Initializes DataModel & ColorSchemeManager           │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                     VIEW LAYER                          │
│   GameView, GuessView, Keyboard, StatsView, etc.       │
│   (Pure UI - displays data, captures user input)       │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                   VIEW MODEL LAYER                      │
│   WordleDataModel.swift - Game logic & state           │
│   ColorSchemeManager.swift - Theme management          │
│   (ObservableObject - publishes state changes)         │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                     MODEL LAYER                         │
│   Guess.swift - Individual guess data                  │
│   Statistic.swift - Stats data & persistence           │
│   Global.swift - Constants & word list                 │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│                   PERSISTENCE LAYER                     │
│   @AppStorage - Local preferences                      │
│   NSUbiquitousKeyValueStore - iCloud sync              │
└─────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
wordleclone/
├── wordlecloneApp.swift              # 🚀 App entry point
│
├── Models/                           # 📦 Data models
│   ├── Global.swift                  # Constants, screen dimensions, word list
│   ├── Guess.swift                   # Single guess data structure
│   ├── Statistic.swift               # Statistics data & iCloud sync
│   └── UbiquitousStore.swift         # iCloud property wrapper
│
├── ViewModels/                       # 🧠 Business logic
│   ├── WordleDataModel.swift        # Main game state & logic
│   └── ColorSchemeManager.swift     # Theme management
│
├── Views/                            # 🎨 UI components
│   ├── GameView.swift                # Main game screen
│   ├── GuessView.swift               # Single row of tiles
│   ├── Keyboard.swift                # On-screen keyboard
│   ├── LetterButtonView.swift        # Individual key button
│   ├── StatsView.swift               # Statistics modal
│   ├── SettingsView.swift            # Settings modal
│   ├── HelpView.swift                # Help/instructions modal
│   └── ToastView.swift               # Toast notifications
│
├── Animations/                       # ✨ Custom animations
│   ├── FlipView.swift                # 3D card flip animation
│   └── Shake.swift                   # Shake animation for errors
│
├── Extensions/                       # 🛠️ Swift extensions
│   ├── Color+Extensions.swift        # Custom color definitions
│   └── UIWindow+Extension.swift      # UI utility extensions
│
├── Assets.xcassets/                  # 🖼️ Images, colors, icons
├── Launch Screen.storyboard          # Launch screen
└── wordleclone.entitlements          # App capabilities (iCloud)
```

---

## Code Flow

### 1. App Launch Sequence

```swift
// wordlecloneApp.swift
@main
struct wordlecloneApp: App {
    @StateObject var dm = WordleDataModel()           // Initialize game logic
    @StateObject var csManager = ColorSchemeManager() // Initialize theme manager

    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(dm)                // Inject dependencies
                .environmentObject(csManager)
                .onAppear {
                    csManager.applyColorScheme()      // Apply saved theme
                }
        }
    }
}
```

**What happens:**
1. App creates `WordleDataModel` instance → loads statistics, creates new game
2. App creates `ColorSchemeManager` → loads saved theme preference
3. `GameView` renders with both injected as environment objects
4. Theme is applied on first appearance

---

### 2. Game Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│ 1. GAME INITIALIZATION                                      │
│    WordleDataModel.newGame()                                │
│    - Pick random word from 1000+ word list                  │
│    - Reset guesses array (6 empty Guess objects)            │
│    - Load previous statistics from iCloud                   │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. USER INPUT (Keyboard Tap)                                │
│    addToCurrentWord(letter: String)                         │
│    - Append letter to current guess (max 5 letters)         │
│    - Update UI immediately via @Published properties        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. SUBMISSION (Enter Key)                                   │
│    enterWord()                                              │
│    ├─ Check word length (must be 5)                         │
│    ├─ Verify word in dictionary (verifyWord)                │
│    │   └─ Invalid? → Shake animation + toast               │
│    ├─ Hard mode checks (if enabled)                         │
│    │   ├─ hardCorrectCheck() - correct letters in place?   │
│    │   └─ hardMisplacedCheck() - misplaced letters used?   │
│    ├─ Calculate colors (setCurrentGuessColors)              │
│    │   └─ For each letter: CORRECT/MISPLACED/WRONG         │
│    ├─ Trigger flip animation (flipCards)                    │
│    ├─ Update keyboard colors (keyColors)                    │
│    └─ Check win/loss condition                             │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. GAME END                                                 │
│    - Win: Show toast → delay 2s → show stats modal         │
│    - Loss: Show correct word → delay 2s → show stats       │
│    - Update statistics (Statistic.update)                   │
│    - Sync to iCloud automatically                           │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. NEW GAME                                                 │
│    newGame() - User taps "Play Again" or app reopens       │
└─────────────────────────────────────────────────────────────┘
```

---

### 3. Letter Evaluation Logic

The core algorithm for determining tile colors (CORRECT/MISPLACED/WRONG):

```swift
// WordleDataModel.swift - setCurrentGuessColors()

// STEP 1: Count letter frequencies in the selected word
var counts: [String : Int] = [:]
for letter in selectedWord { counts[letter, default: 0] += 1 }

// STEP 2: First pass - mark CORRECT letters (green)
for index in 0...4 {
    let guessLetter = guesses[currentRow].guessLetters[index]
    if guessLetter == selectedWord[index] {
        guesses[currentRow].bgColors[index] = .correct
        counts[guessLetter]! -= 1  // Consume one instance
    }
}

// STEP 3: Second pass - mark MISPLACED letters (yellow)
for index in 0...4 {
    let guessLetter = guesses[currentRow].guessLetters[index]

    if guesses[currentRow].bgColors[index] != .correct {  // Skip already correct
        if selectedWord.contains(guessLetter) && counts[guessLetter]! > 0 {
            guesses[currentRow].bgColors[index] = .misplaced
            counts[guessLetter]! -= 1  // Consume one instance
        } else {
            guesses[currentRow].bgColors[index] = .wrong
        }
    }
}

// STEP 4: Update keyboard colors
updateKeyColors()
```

**Why two passes?**
Prevents incorrect duplicate letter coloring. Example:
- Selected word: **SPEED**
- Guess: **ERASE**
- First pass marks E at index 4 as CORRECT (green)
- Second pass marks E at index 0 as MISPLACED (yellow) - only one E remains
- Result: 🟨❌❌❌🟩

---

## Key Components

### WordleDataModel (ViewModels/WordleDataModel.swift)

**Purpose:** Central brain of the game - manages all game state and logic.

**Key Properties:**
```swift
@Published var guesses: [Guess] = []        // 6 rows of guesses
@Published var incorrectAttempts: [Int] = []// Tracks shake animations
@Published var toastText: String?           // Toast message content
@Published var showStats = false            // Stats modal visibility
@AppStorage("hardMode") var hardMode = false// Hard mode toggle

var currentRow = 0                          // Current attempt (0-5)
var selectedWord = ""                       // Target word to guess
var keyColors: [String : Color] = [:]       // Keyboard color mapping
var currentStat: Statistic                  // Statistics object
```

**Key Methods:**
- `newGame()` - Initialize new game with random word
- `addToCurrentWord(_ letter: String)` - Add letter to current guess
- `removeLetterFromCurrentWord()` - Delete last letter
- `enterWord()` - Validate and submit guess
- `setCurrentGuessColors()` - Calculate tile colors
- `flipCards(for row: Int)` - Animate card flip
- `updateKeyColors()` - Update keyboard colors
- `hardCorrectCheck()` - Enforce hard mode correct letter rules
- `hardMisplacedCheck()` - Enforce hard mode misplaced letter rules
- `shareResult()` - Generate emoji grid for sharing

---

### Guess (Models/Guess.swift)

**Purpose:** Represents a single guess (one row of 5 tiles).

```swift
struct Guess {
    let index: Int                          // Row number (0-5)
    var word = ""                           // User's typed word
    var bgColors = [Color](repeating: .wrong, count: 5)  // Tile colors
    var cardFlipped = [Bool](repeating: false, count: 5) // Flip state

    var guessLetters: [String] {            // Individual letters as array
        word.map { String($0).uppercased() }
    }

    var results: String {                   // Emoji representation
        // Returns "🟩🟨⬛⬛⬛" for sharing
    }
}
```

---

### Statistic (Models/Statistic.swift)

**Purpose:** Tracks game statistics with iCloud sync.

```swift
class Statistic: ObservableObject, Codable {
    @UbiquitousStore("currentStreak") var currentStreak = 0
    @UbiquitousStore("maxStreak") var maxStreak = 0
    @UbiquitousStore("winDistribution") var frequencies = [0,0,0,0,0,0]
    @UbiquitousStore("lastGame") var lastGame = ""

    var games: Int { frequencies.reduce(0, +) }
    var wins: Int { frequencies.reduce(0, +) }
    var winPercent: Int { games == 0 ? 0 : wins * 100 / games }

    func update(index: Int, word: String) {
        // Update frequencies, streaks
        // Sync to iCloud automatically via @UbiquitousStore
    }
}
```

---

### Global (Models/Global.swift)

**Purpose:** Global constants and configuration.

```swift
struct Global {
    static var screenWidth: CGFloat { UIScreen.main.bounds.width }
    static var boardWidth: CGFloat {
        // Adaptive width: 320-500px based on screen size
    }
    static var keyboardScale: CGFloat {
        // Scale factor: 0.74x - 1.6x
    }
    static let commonWords = ["AAHED", "AALII", ...] // 1000+ words
    static let commonWordsAdded = true
}
```

---

## UI Components

### GameView (Views/GameView.swift)

Main screen layout:

```
┌──────────────────────────────────┐
│  WORDLE    [?] [⚙️]  [📊]        │  ← Title + buttons
├──────────────────────────────────┤
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐      │
│  │ W│ │ O│ │ R│ │ L│ │ D│      │  ← Row 1 (GuessView)
│  └──┘ └──┘ └──┘ └──┘ └──┘      │
│  ┌──┐ ┌──┐ ┌──┐ ┌──┐ ┌──┐      │
│  │  │ │  │ │  │ │  │ │  │      │  ← Row 2-6
│  └──┘ └──┘ └──┘ └──┘ └──┘      │
│          ...                     │
├──────────────────────────────────┤
│  Q W E R T Y U I O P            │  ← Keyboard
│   A S D F G H J K L             │
│  ENTER Z X C V B N M ⌫           │
└──────────────────────────────────┘
```

---

### GuessView (Views/GuessView.swift)

Renders a single row with flip animation:

```swift
HStack(spacing: 3) {
    ForEach(0...4, id: \.self) { index in
        FlipView(isFlipped: $dm.guesses[index].cardFlipped[i]) {
            // Front: White tile with letter
            Text(letter).frontCardView()
        } back: {
            // Back: Colored tile
            Text(letter).backCardView(bgColor)
        }
    }
}
.modifier(Shake(animatableData: attempts))  // Shake on error
```

---

### Keyboard (Views/Keyboard.swift)

Three-row QWERTY layout with dynamic coloring:

```swift
VStack {
    // Row 1: Q W E R T Y U I O P
    HStack { ... }

    // Row 2: A S D F G H J K L
    HStack { ... }

    // Row 3: ENTER Z X C V B N M DELETE
    HStack {
        Button("ENTER") { dm.enterWord() }
        ForEach(letters) { letter in
            LetterButtonView(letter: letter)
                .foregroundColor(dm.keyColors[letter] ?? .unused)
        }
        Button("DELETE") { dm.removeLetterFromCurrentWord() }
    }
}
```

**Keyboard Color Logic:**
- **Unused** (light gray) - Not yet guessed
- **Wrong** (dark gray) - Letter not in word
- **Misplaced** (yellow) - Letter in word, wrong position
- **Correct** (green) - Letter in correct position

---

## State Management

### SwiftUI Property Wrappers Used

| Wrapper | Purpose | Example |
|---------|---------|---------|
| `@State` | View-local state | Button press states, modal visibility |
| `@Published` | ViewModel state that triggers UI updates | `guesses`, `toastText`, `showStats` |
| `@ObservedObject` | Subscribe to external object changes | (not used directly) |
| `@StateObject` | Create and own observable object | `@StateObject var dm = WordleDataModel()` |
| `@EnvironmentObject` | Share objects across view hierarchy | `.environmentObject(dm)` |
| `@AppStorage` | UserDefaults persistence | `@AppStorage("hardMode") var hardMode` |
| `@UbiquitousStore` | iCloud Key-Value Store (custom wrapper) | `@UbiquitousStore("currentStreak") var currentStreak` |

---

### Data Flow Example

```
User taps "E" on keyboard
        ↓
LetterButtonView calls dm.addToCurrentWord("E")
        ↓
WordleDataModel updates @Published var guesses
        ↓
SwiftUI detects change → re-renders GameView
        ↓
GuessView displays new letter in current row
```

---

## Persistence & iCloud Sync

### UbiquitousStore Property Wrapper

Custom wrapper for seamless iCloud sync:

```swift
@propertyWrapper
struct UbiquitousStore<T: Codable> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get {
            guard let data = NSUbiquitousKeyValueStore.default.data(forKey: key),
                  let value = try? JSONDecoder().decode(T.self, from: data)
            else { return defaultValue }
            return value
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                NSUbiquitousKeyValueStore.default.set(data, forKey: key)
                NSUbiquitousKeyValueStore.default.synchronize()
            }
        }
    }
}
```

**How it works:**
1. Statistics are stored in `NSUbiquitousKeyValueStore`
2. Apple syncs data across user's devices automatically
3. No manual sync code needed - write to property, it syncs!

**What gets synced:**
- Current streak
- Max streak
- Win distribution (1-6 attempts)
- Last game date

---

## Animations

### Flip Animation (Animations/FlipView.swift)

3D card flip revealing tile color:

```swift
FlipView(isFlipped: $flipped) {
    // Front side
} back: {
    // Back side (colored)
}
.rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (1, 0, 0))
.animation(.easeInOut(duration: 0.6), value: isFlipped)
```

**Timing:** Sequential flip with 0.2s delay per tile (left to right)

### Shake Animation (Animations/Shake.swift)

Error feedback when word is invalid:

```swift
.modifier(Shake(animatableData: CGFloat(attempts)))

// Shake effect
.offset(x: sin(animatableData * .pi * 2) * 10)
```

**Triggers:**
- Word not in dictionary
- Not enough letters
- Hard mode rule violations

---

## Next Steps

Now that you understand the architecture and code flow, check out:

1. **[QUICK_START.md](QUICK_START.md)** - Set up your development environment
2. **[MODIFICATION_GUIDE.md](MODIFICATION_GUIDE.md)** - Step-by-step guides for common modifications

---

## Questions?

If you encounter issues or have questions:
1. Check the inline code comments
2. Review the SwiftUI documentation for specific components
3. Experiment with small changes to understand behavior

Happy coding! 🚀
