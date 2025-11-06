# Modification Guide - Wordle Clone

Step-by-step guides for customizing and extending the Wordle Clone.

---

## Table of Contents

1. [Changing the Word Length](#1-changing-the-word-length)
2. [Modifying the Number of Attempts](#2-modifying-the-number-of-attempts)
3. [Customizing Colors](#3-customizing-colors)
4. [Changing the Word List](#4-changing-the-word-list)
5. [Adding New Game Modes](#5-adding-new-game-modes)
6. [Customizing Animations](#6-customizing-animations)
7. [Modifying the Keyboard Layout](#7-modifying-the-keyboard-layout)
8. [Adding Sound Effects](#8-adding-sound-effects)
9. [Implementing a Daily Challenge Mode](#9-implementing-a-daily-challenge-mode)
10. [Adding Hints Feature](#10-adding-hints-feature)

---

## 1. Changing the Word Length

**Goal:** Change from 5-letter words to 6-letter words (or any length)

**Difficulty:** ⭐⭐⭐ (Moderate - requires multiple file changes)

### Step 1: Update Global Constants

**File:** `wordleclone/Models/Global.swift`

```swift
// Find this line:
static let commonWords = ["AAHED", "AALII", ...] // 5-letter words

// Replace with 6-letter word list:
static let commonWords = [
    "AALIIS", "ABACAS", "ABACUS", "ABAKAS", "ABAMPS",
    "ABANDS", "ABASED", "ABASER", "ABASES", "ABATED",
    // ... add more 6-letter words
]
```

**Where to find 6-letter word lists:**
- [English word lists on GitHub](https://github.com/dwyl/english-words)
- [SCOWL word lists](http://wordlist.aspell.net/)

---

### Step 2: Update Guess Model

**File:** `wordleclone/Models/Guess.swift`

```swift
// Change all array sizes from 5 to 6:

// OLD:
var bgColors = [Color](repeating: .wrong, count: 5)
var cardFlipped = [Bool](repeating: false, count: 5)

// NEW:
var bgColors = [Color](repeating: .wrong, count: 6)
var cardFlipped = [Bool](repeating: false, count: 6)
```

---

### Step 3: Update WordleDataModel

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

Find all instances of `0...4` and replace with `0...5`:

```swift
// In setCurrentGuessColors():
// OLD:
for index in 0...4 {
    // ...
}

// NEW:
for index in 0...5 {
    // ...
}

// Also update flipCards(for row: Int):
// OLD:
for index in 0...4 {
    // ...
}

// NEW:
for index in 0...5 {
    // ...
}
```

Update word length validation in `enterWord()`:

```swift
// OLD:
if currentWord.count != 5 {
    toastText = "Not enough letters"
    return
}

// NEW:
if currentWord.count != 6 {
    toastText = "Not enough letters"
    return
}
```

---

### Step 4: Update GuessView

**File:** `wordleclone/Views/GuessView.swift`

```swift
// Find:
HStack(spacing: 3) {
    ForEach(0...4, id: \.self) { index in
        // ...
    }
}

// Replace with:
HStack(spacing: 3) {
    ForEach(0...5, id: \.self) { index in
        // ...
    }
}
```

**Optional:** Adjust tile size for better fit:

```swift
// In the tile styling:
.frame(
    minWidth: 0,
    maxWidth: .infinity,
    minHeight: 0,
    maxHeight: .infinity,
    alignment: .center
)
.aspectRatio(1, contentMode: .fit) // Keep square tiles
```

---

### Step 5: Test

1. **Build and run** (`Cmd + R`)
2. **Verify:**
   - 6 tiles per row ✅
   - Can type 6 letters ✅
   - Enter requires exactly 6 letters ✅
   - Colors evaluate correctly ✅

---

## 2. Modifying the Number of Attempts

**Goal:** Change from 6 attempts to 8 attempts (or any number)

**Difficulty:** ⭐⭐ (Easy)

### Step 1: Update Guess Array Size

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

```swift
// In newGame() method:
// OLD:
func newGame() {
    guesses = []
    for index in 0...5 {
        guesses.append(Guess(index: index))
    }
    // ...
}

// NEW:
func newGame() {
    guesses = []
    for index in 0...7 { // 8 attempts (0-7)
        guesses.append(Guess(index: index))
    }
    // ...
}
```

Update max row check in `enterWord()`:

```swift
// OLD:
if currentRow == 5 {
    // Game over
}

// NEW:
if currentRow == 7 { // Last attempt (0-indexed)
    // Game over
}
```

---

### Step 2: Update Statistics Model

**File:** `wordleclone/Models/Statistic.swift`

```swift
// OLD:
@UbiquitousStore("winDistribution") var frequencies = [0,0,0,0,0,0]

// NEW:
@UbiquitousStore("winDistribution") var frequencies = [0,0,0,0,0,0,0,0]
```

---

### Step 3: Update GameView

**File:** `wordleclone/Views/GameView.swift`

```swift
// OLD:
VStack(spacing: 3) {
    ForEach(0...5, id: \.self) { index in
        GuessView(guess: $dm.guesses[index])
            .modifier(Shake(animatableData: ...))
    }
}

// NEW:
VStack(spacing: 3) {
    ForEach(0...7, id: \.self) { index in
        GuessView(guess: $dm.guesses[index])
            .modifier(Shake(animatableData: ...))
    }
}
```

---

### Step 4: Update Share Result

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

```swift
// In shareResult() method:
var result = "Wordle \(currentStat.games) \(inPlay ? "?" : "\(currentRow + 1)/8")\n\n"
//                                                                           ^-- Update max attempts
```

---

### Step 5: Test

1. **Clean build** (`Cmd + Shift + K`)
2. **Build and run** (`Cmd + R`)
3. **Verify:**
   - 8 rows visible ✅
   - Can make 8 guesses ✅
   - Statistics track correctly ✅
   - Share result shows "X/8" ✅

---

## 3. Customizing Colors

**Goal:** Change tile colors (e.g., blue instead of green for correct)

**Difficulty:** ⭐ (Very Easy)

### Step 1: Update Color Assets

**File:** `wordleclone/Assets.xcassets/Colors/correct.colorset/Contents.json`

1. **In Xcode:**
   - Navigate to `Assets.xcassets` → `Colors` → `correct`
   - Click the color swatch
   - Choose a new color in the color picker (e.g., blue: `#0096FF`)

2. **Or edit JSON directly:**

```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "1.000",  // Changed
          "green" : "0.588", // Changed
          "red" : "0.000"    // Changed (RGB for blue)
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

---

### Step 2: Update Other Colors

Repeat for:
- `misplaced.colorset` (yellow) → Try orange (`#FF8C00`)
- `wrong.colorset` (gray) → Try dark blue (`#1E3A8A`)
- `unused.colorset` (light gray) → Try light blue (`#BFDBFE`)

---

### Step 3: Optional - Add Color Variants for Dark Mode

**In each colorset JSON:**

```json
{
  "colors" : [
    {
      "color" : { ... },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.800",
          "green" : "0.400",
          "red" : "0.000"
        }
      },
      "idiom" : "universal"
    }
  ]
}
```

---

### Step 4: Test

1. **Build and run**
2. **Play a game** → Verify new colors appear on tiles and keyboard
3. **Toggle dark mode** → Verify dark mode variants work

---

## 4. Changing the Word List

**Goal:** Use a custom word list or filter existing words

**Difficulty:** ⭐ (Very Easy)

### Option A: Replace the Entire Word List

**File:** `wordleclone/Models/Global.swift`

```swift
static let commonWords = [
    "APPLE",
    "GRAPE",
    "LEMON",
    "PEACH",
    "BERRY",
    // ... your custom words
]
```

---

### Option B: Load from External File

**Step 1:** Add a text file to the project

1. In Xcode: **File → Add Files to "wordleclone"**
2. Create/add `words.txt` with one word per line:
   ```
   APPLE
   GRAPE
   LEMON
   ```

**Step 2:** Load the file in `Global.swift`

```swift
static let commonWords: [String] = {
    guard let url = Bundle.main.url(forResource: "words", withExtension: "txt"),
          let contents = try? String(contentsOf: url) else {
        return ["WORLD", "SWIFT"] // Fallback
    }
    return contents.components(separatedBy: .newlines)
        .map { $0.uppercased().trimmingCharacters(in: .whitespaces) }
        .filter { $0.count == 5 } // Only 5-letter words
}()
```

---

### Option C: Filter by Theme

**Example:** Only food-related words

```swift
static let commonWords = [
    "APPLE", "BACON", "BREAD", "CANDY", "CHEESE",
    "DONUT", "FRIES", "GRAPE", "HONEY", "JELLY",
    "LEMON", "MANGO", "OLIVE", "PEACH", "PIZZA",
    // ... more food words
]
```

---

### Option D: Fetch from API (Advanced)

**Step 1:** Create a word service

```swift
// Create new file: Services/WordService.swift
import Foundation

class WordService {
    static func fetchWords(completion: @escaping ([String]) -> Void) {
        let url = URL(string: "https://api.example.com/words")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let words = try? JSONDecoder().decode([String].self, from: data)
            else {
                completion(Global.commonWords) // Fallback
                return
            }
            completion(words)
        }.resume()
    }
}
```

**Step 2:** Update `WordleDataModel.newGame()`

```swift
func newGame() {
    WordService.fetchWords { words in
        DispatchQueue.main.async {
            self.selectedWord = words.randomElement() ?? "WORLD"
            // ... rest of newGame logic
        }
    }
}
```

---

## 5. Adding New Game Modes

**Goal:** Add a "Timed Mode" where users have 60 seconds per guess

**Difficulty:** ⭐⭐⭐⭐ (Challenging)

### Step 1: Add Timer State to WordleDataModel

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

```swift
import Combine

class WordleDataModel: ObservableObject {
    // ... existing properties

    @Published var timedMode = false
    @Published var remainingTime: Int = 60 // seconds
    @Published var timerActive = false

    private var timerCancellable: AnyCancellable?

    // ... existing methods
}
```

---

### Step 2: Add Timer Logic

**Add to WordleDataModel:**

```swift
func startTimer() {
    guard timedMode else { return }

    timerActive = true
    remainingTime = 60

    timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
        .sink { [weak self] _ in
            guard let self = self else { return }

            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.timeExpired()
            }
        }
}

func stopTimer() {
    timerActive = false
    timerCancellable?.cancel()
}

func timeExpired() {
    stopTimer()
    toastText = "Time's up! Moving to next row"

    // Auto-submit or skip row
    if !currentWord.isEmpty {
        enterWord()
    }
}
```

---

### Step 3: Integrate Timer into Game Flow

**Update `newGame()`:**

```swift
func newGame() {
    // ... existing code

    if timedMode {
        startTimer()
    }
}
```

**Update `enterWord()`:**

```swift
func enterWord() {
    // ... existing validation code

    stopTimer() // Stop current timer

    // ... evaluate guess

    if !gameOver && timedMode {
        startTimer() // Start timer for next guess
    }
}
```

---

### Step 4: Add UI for Timed Mode

**File:** `wordleclone/Views/SettingsView.swift`

```swift
// Add toggle in settings:
Toggle("Timed Mode (60s per guess)", isOn: $dm.timedMode)
```

**File:** `wordleclone/Views/GameView.swift`

```swift
// Add timer display at top:
VStack {
    HStack {
        Text("WORDLE")
        Spacer()

        if dm.timedMode && dm.timerActive {
            Text("\(dm.remainingTime)s")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(dm.remainingTime < 10 ? .red : .primary)
        }

        // ... existing buttons
    }

    // ... rest of view
}
```

---

### Step 5: Test

1. **Enable Timed Mode** in settings
2. **Start new game** → Timer starts at 60s
3. **Type letters slowly** → Watch countdown
4. **Wait for timeout** → Auto-submit or skip row
5. **Enter a word** → Timer resets for next guess

---

## 6. Customizing Animations

**Goal:** Change flip animation speed or style

**Difficulty:** ⭐⭐ (Easy)

### Adjust Flip Duration

**File:** `wordleclone/Animations/FlipView.swift`

```swift
// OLD:
.animation(.easeInOut(duration: 0.6), value: isFlipped)

// NEW - Faster:
.animation(.easeInOut(duration: 0.3), value: isFlipped)

// NEW - Slower:
.animation(.easeInOut(duration: 1.0), value: isFlipped)

// NEW - Bouncy:
.animation(.spring(response: 0.6, dampingFraction: 0.6), value: isFlipped)
```

---

### Adjust Sequential Delay

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

```swift
// In flipCards(for row: Int):
DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
    //                                                           ^-- Change delay
    self.guesses[row].cardFlipped[index].toggle()
}

// Faster (0.1s):
DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {

// Slower (0.5s):
DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {

// All at once (0s):
DispatchQueue.main.asyncAfter(deadline: .now()) {
```

---

### Change Shake Animation

**File:** `wordleclone/Animations/Shake.swift`

```swift
// OLD:
.offset(x: sin(animatableData * .pi * 2) * 10)
//                                          ^-- Shake distance

// NEW - More intense:
.offset(x: sin(animatableData * .pi * 4) * 20)

// NEW - Subtle:
.offset(x: sin(animatableData * .pi * 2) * 5)
```

---

### Add Pop-In Animation for Letters

**File:** `wordleclone/Views/GuessView.swift`

```swift
// Add scale effect:
Text(letter)
    // ... existing modifiers
    .scaleEffect(letter.isEmpty ? 0.8 : 1.0)
    .animation(.spring(response: 0.3), value: letter)
```

---

## 7. Modifying the Keyboard Layout

**Goal:** Change from QWERTY to ABCDEF layout

**Difficulty:** ⭐⭐ (Easy)

### Update Keyboard Rows

**File:** `wordleclone/Views/Keyboard.swift`

```swift
// OLD:
let topRow = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
let secondRow = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
let thirdRow = ["Z", "X", "C", "V", "B", "N", "M"]

// NEW - Alphabetical:
let topRow = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
let secondRow = ["J", "K", "L", "M", "N", "O", "P", "Q", "R"]
let thirdRow = ["S", "T", "U", "V", "W", "X", "Y", "Z"]
```

---

### Add Extra Keys (e.g., Accent Letters)

```swift
// For French Wordle:
let topRow = ["A", "Z", "E", "R", "T", "Y", "U", "I", "O", "P"]
let secondRow = ["Q", "S", "D", "F", "G", "H", "J", "K", "L", "M"]
let thirdRow = ["W", "X", "C", "V", "B", "N", "É", "È", "À"]
```

---

### Adjust Keyboard Size

**File:** `wordleclone/Models/Global.swift`

```swift
// Change keyboard scale:
static var keyboardScale: CGFloat {
    // ... existing logic

    // Make keyboard larger:
    return scale * 1.2 // 20% larger

    // Make keyboard smaller:
    return scale * 0.8 // 20% smaller
}
```

---

## 8. Adding Sound Effects

**Goal:** Play sounds for key presses, correct/wrong guesses

**Difficulty:** ⭐⭐⭐ (Moderate)

### Step 1: Add Sound Files

1. **Download free sounds** from [freesound.org](https://freesound.org/)
   - `key_press.wav` - Key tap sound
   - `correct.wav` - Correct guess
   - `wrong.wav` - Wrong guess

2. **Add to Xcode:**
   - Drag files into `wordleclone/` folder
   - Check "Copy items if needed"
   - Add to target: `wordleclone`

---

### Step 2: Create Sound Manager

**Create new file:** `wordleclone/Utilities/SoundManager.swift`

```swift
import AVFoundation

class SoundManager {
    static let shared = SoundManager()

    private var audioPlayers: [String: AVAudioPlayer] = [:]

    func loadSound(_ name: String, type: String = "wav") {
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else {
            print("Sound file \(name).\(type) not found")
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayers[name] = player
        } catch {
            print("Error loading sound: \(error)")
        }
    }

    func playSound(_ name: String) {
        audioPlayers[name]?.play()
    }
}
```

---

### Step 3: Load Sounds on App Start

**File:** `wordleclone/wordlecloneApp.swift`

```swift
@main
struct wordlecloneApp: App {
    init() {
        // Load sounds
        SoundManager.shared.loadSound("key_press")
        SoundManager.shared.loadSound("correct")
        SoundManager.shared.loadSound("wrong")
    }

    // ... rest of app
}
```

---

### Step 4: Play Sounds

**In `WordleDataModel.swift`:**

```swift
func addToCurrentWord(_ letter: String) {
    // ... existing code
    SoundManager.shared.playSound("key_press")
}

func enterWord() {
    // ... existing validation

    // After evaluating guess:
    if currentWord == selectedWord {
        SoundManager.shared.playSound("correct")
    } else {
        SoundManager.shared.playSound("wrong")
    }

    // ... rest of code
}
```

---

### Step 5: Add Settings Toggle

**File:** `wordleclone/Views/SettingsView.swift`

```swift
@AppStorage("soundEnabled") var soundEnabled = true

// In view:
Toggle("Sound Effects", isOn: $soundEnabled)
```

**Update `SoundManager`:**

```swift
func playSound(_ name: String) {
    guard UserDefaults.standard.bool(forKey: "soundEnabled") else { return }
    audioPlayers[name]?.play()
}
```

---

## 9. Implementing a Daily Challenge Mode

**Goal:** Same word for all users each day (like real Wordle)

**Difficulty:** ⭐⭐⭐⭐ (Challenging)

### Step 1: Create Deterministic Word Selection

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

```swift
func dailyChallengeWord() -> String {
    // Use date as seed for consistent daily word
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())

    // Days since epoch (Jan 1, 1970)
    let daysSinceEpoch = Int(today.timeIntervalSince1970 / 86400)

    // Offset by game start date (e.g., Jan 1, 2022)
    let gameStartDate = calendar.date(from: DateComponents(year: 2022, month: 1, day: 1))!
    let daysSinceStart = calendar.dateComponents([.day], from: gameStartDate, to: today).day!

    // Select word based on day index
    let wordIndex = daysSinceStart % Global.commonWords.count
    return Global.commonWords[wordIndex]
}
```

---

### Step 2: Update newGame() for Daily Mode

```swift
@AppStorage("dailyChallengeMode") var dailyChallengeMode = false

func newGame() {
    // ... existing code

    if dailyChallengeMode {
        selectedWord = dailyChallengeWord()

        // Check if already played today
        if currentStat.lastGame == todayString() {
            toastText = "Come back tomorrow for a new challenge!"
            gameOver = true
            return
        }
    } else {
        selectedWord = Global.commonWords.randomElement()!
    }

    // ... rest of code
}

private func todayString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: Date())
}
```

---

### Step 3: Add UI Toggle

**File:** `wordleclone/Views/SettingsView.swift`

```swift
Toggle("Daily Challenge Mode", isOn: $dm.dailyChallengeMode)
    .onChange(of: dm.dailyChallengeMode) { _ in
        dm.newGame()
    }
```

---

### Step 4: Display Challenge Number

**File:** `wordleclone/Views/GameView.swift`

```swift
Text("WORDLE \(challengeNumber())")
    .font(.largeTitle)

func challengeNumber() -> Int {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    let gameStartDate = calendar.date(from: DateComponents(year: 2022, month: 1, day: 1))!
    return calendar.dateComponents([.day], from: gameStartDate, to: today).day! + 1
}
```

---

### Step 5: Test

1. **Enable Daily Challenge Mode**
2. **Play game** → Word is same for everyone today
3. **Complete game** → Can't play again until tomorrow
4. **Change device date** → New word appears

---

## 10. Adding Hints Feature

**Goal:** Show a hint (one correct letter) after 3 failed attempts

**Difficulty:** ⭐⭐⭐ (Moderate)

### Step 1: Add Hint State

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

```swift
@Published var hintUsed = false
@Published var hintLetter: String?
@Published var hintIndex: Int?
```

---

### Step 2: Create Hint Logic

```swift
func showHint() {
    guard !hintUsed else { return }
    guard currentRow >= 3 else {
        toastText = "Hints available after 3 attempts"
        return
    }

    // Find a letter not yet guessed correctly
    let selectedLetters = selectedWord.map { String($0) }

    for (index, letter) in selectedLetters.enumerated() {
        // Check if this position hasn't been guessed correctly
        let alreadyGuessed = guesses[0..<currentRow].contains { guess in
            guess.guessLetters.indices.contains(index) &&
            guess.guessLetters[index] == letter &&
            guess.bgColors[index] == .correct
        }

        if !alreadyGuessed {
            hintLetter = letter
            hintIndex = index
            hintUsed = true
            toastText = "Hint: '\(letter)' is at position \(index + 1)"
            return
        }
    }

    toastText = "No hints available"
}
```

---

### Step 3: Add Hint Button to UI

**File:** `wordleclone/Views/GameView.swift`

```swift
HStack {
    Text("WORDLE")

    Spacer()

    // Add hint button
    Button(action: { dm.showHint() }) {
        Image(systemName: "lightbulb.fill")
            .foregroundColor(dm.hintUsed ? .gray : .yellow)
    }
    .disabled(dm.hintUsed || dm.currentRow < 3)

    // ... existing buttons
}
```

---

### Step 4: Visual Indicator for Hint

**File:** `wordleclone/Views/GuessView.swift`

```swift
// Add border to hint tile:
RoundedRectangle(cornerRadius: 5)
    .stroke(
        dm.hintIndex == index && !dm.hintUsed ? Color.yellow : Color.clear,
        lineWidth: 3
    )
```

---

### Step 5: Reset Hint on New Game

**File:** `wordleclone/ViewModels/WordleDataModel.swift`

```swift
func newGame() {
    // ... existing code

    hintUsed = false
    hintLetter = nil
    hintIndex = nil
}
```

---

### Step 6: Test

1. **Start a game**
2. **Make 2 wrong guesses** → Hint button disabled
3. **Make 3rd wrong guess** → Hint button enabled (yellow)
4. **Tap hint** → Toast shows correct letter and position
5. **Hint button grays out** → Can't use again

---

## Advanced Modifications

### Adding Multi-Language Support

**Goal:** Support words in different languages

**Steps:**
1. Create separate word lists per language in `Global.swift`
2. Add language selector in Settings
3. Load appropriate word list based on selection
4. Update keyboard layout for language-specific characters

---

### Adding Colorblind Mode

**Goal:** Use shapes instead of just colors

**Steps:**
1. Update `Guess` model to include shape types (circle, square, triangle)
2. In `GuessView`, overlay shapes on tiles based on correctness
3. Add colorblind mode toggle in Settings

---

### Adding Achievements/Badges

**Goal:** Award badges for milestones (e.g., "10 wins", "5-game streak")

**Steps:**
1. Create `Achievement` model with id, title, description, unlocked status
2. Check achievements after each game in `WordleDataModel`
3. Display achievements in a new modal (similar to StatsView)
4. Sync achievements via `@UbiquitousStore`

---

## Need Help?

If you get stuck:

1. **Check syntax errors:** Xcode will highlight them in red
2. **Build the project:** `Cmd + B` to see all errors
3. **Test incrementally:** Make one change at a time and test
4. **Revert changes:** Use Git to revert if things break (`git checkout -- <file>`)
5. **Consult the [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** for architecture details

---

## Contributing Your Modifications

If you create a cool modification:

1. **Create a new branch:** `git checkout -b feature/my-cool-feature`
2. **Commit your changes:** `git commit -m "Add cool feature"`
3. **Push to GitHub:** `git push origin feature/my-cool-feature`
4. **Create a Pull Request** on GitHub

---

Happy modding! 🚀✨
