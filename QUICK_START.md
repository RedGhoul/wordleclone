# Quick Start Guide - Wordle Clone

Get up and running with the Wordle Clone project in minutes!

---

## Prerequisites

Before you begin, make sure you have:

### Required
- ✅ **macOS** (Big Sur 11.0 or later recommended)
- ✅ **Xcode 13.0+** ([Download from Mac App Store](https://apps.apple.com/us/app/xcode/id497799835))
- ✅ **iOS 15.0+ SDK** (included with Xcode)

### Recommended
- 📱 **Physical iOS device** (iPhone or iPad) for testing
- 🌐 **Apple Developer Account** (free or paid) for device testing
- ☁️ **iCloud account** for testing sync features

---

## Installation

### Step 1: Clone the Repository

```bash
# Clone the repo
git clone https://github.com/RedGhoul/wordleclone.git

# Navigate to the project directory
cd wordleclone
```

### Step 2: Open in Xcode

```bash
# Open the project file
open wordleclone.xcodeproj
```

**Or manually:**
1. Launch Xcode
2. Click **File → Open**
3. Navigate to `wordleclone.xcodeproj`
4. Click **Open**

### Step 3: Verify Project Settings

Once the project opens:

1. **Select a target device:**
   - Click the device selector in the toolbar (top-left)
   - Choose an iOS simulator (e.g., "iPhone 14 Pro")
   - Or select your physical device if connected

2. **Check signing settings:**
   - Select the **wordleclone** project in the navigator
   - Click the **wordleclone** target
   - Go to **Signing & Capabilities** tab
   - Under **Team**, select your Apple Developer account
   - Xcode will automatically manage signing

   ![Signing Example](https://developer.apple.com/documentation/xcode/adding-capabilities-to-your-app)

---

## Running the App

### Option 1: iOS Simulator (Fastest)

1. **Select a simulator:**
   - iPhone 14 Pro, iPhone SE, or iPad Pro

2. **Click the Run button (▶️)** or press `Cmd + R`

3. **Wait for build:**
   - First build may take 30-60 seconds
   - Subsequent builds are faster

4. **App launches automatically** in the simulator

**Note:** iCloud sync will NOT work in the simulator. Use a physical device to test this feature.

---

### Option 2: Physical Device (Recommended)

1. **Connect your iPhone/iPad** via USB cable

2. **Unlock your device** and trust the computer if prompted

3. **Select your device** in the device selector

4. **Click Run (▶️)** or press `Cmd + R`

5. **First time only:**
   - Go to **Settings → General → VPN & Device Management**
   - Trust your developer certificate
   - Return to the app and launch

6. **App installs and runs** on your device

---

## Verify Installation

Once the app launches, you should see:

✅ **Main game screen** with:
- Title "WORDLE" at the top
- 6 rows of empty tiles (5 tiles per row)
- On-screen QWERTY keyboard at the bottom
- Help (?), Settings (⚙️), and Stats (📊) buttons

✅ **Test basic functionality:**
1. Tap letters on the keyboard → Letters appear in the first row
2. Tap Enter with less than 5 letters → Shake animation + toast message
3. Type "WORLD" and press Enter → Cards flip and show colors
4. Tap Stats button → Statistics modal appears

---

## Project Structure Overview

After opening, here's what you'll see in Xcode:

```
wordleclone/
├── 📱 wordlecloneApp.swift      # App entry point - START HERE
├── 📦 Models/                   # Data structures
│   ├── Global.swift             # Constants & word list
│   ├── Guess.swift              # Guess data model
│   ├── Statistic.swift          # Stats with iCloud sync
│   └── UbiquitousStore.swift    # iCloud wrapper
├── 🧠 ViewModels/               # Business logic
│   ├── WordleDataModel.swift   # Main game logic
│   └── ColorSchemeManager.swift# Theme manager
├── 🎨 Views/                    # UI components
│   ├── GameView.swift           # Main screen
│   ├── GuessView.swift          # Single row
│   ├── Keyboard.swift           # Keyboard UI
│   └── [Other views...]
├── ✨ Animations/               # Custom animations
└── 🛠️ Extensions/               # Swift extensions
```

**Pro Tip:** Use `Cmd + Shift + O` to quickly open any file by name!

---

## Development Workflow

### Making Changes

1. **Edit code** in Xcode editor
2. **Save** (`Cmd + S`)
3. **Build & Run** (`Cmd + R`)
4. **Test** in simulator or device

### Hot Reload (SwiftUI Previews)

For faster iteration without full app restart:

1. **Open a SwiftUI view** (e.g., `GameView.swift`)
2. **Click "Canvas" button** in the top-right (or `Cmd + Option + Enter`)
3. **Click "Resume" button** in the canvas
4. **See live preview** of your UI

```swift
// Add at the bottom of any SwiftUI view file
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(WordleDataModel())
            .environmentObject(ColorSchemeManager())
    }
}
```

### Debugging

**Console Output:**
- Run app in Xcode
- Open **Debug Area** (`Cmd + Shift + Y`)
- Add print statements: `print("Current row: \(currentRow)")`

**Breakpoints:**
1. Click the line number gutter to add a red breakpoint
2. Run app → execution pauses at breakpoint
3. Inspect variables in the Debug Area
4. Use step-over (`F6`), step-into (`F7`), continue (`Cmd + Ctrl + Y`)

---

## Common Setup Issues

### Issue 1: "Signing for wordleclone requires a development team"

**Solution:**
1. Select the **wordleclone** target
2. Go to **Signing & Capabilities**
3. Check **"Automatically manage signing"**
4. Select your **Team** from the dropdown

If you don't have a team:
- Create a free Apple ID at [appleid.apple.com](https://appleid.apple.com/)
- Add it in Xcode: **Xcode → Preferences → Accounts → + → Apple ID**

---

### Issue 2: "Could not launch wordleclone"

**Solution (Simulator):**
- Quit and restart the simulator
- Clean build folder: `Cmd + Shift + K`
- Rebuild: `Cmd + B`

**Solution (Physical Device):**
- Unlock your device
- Trust the developer certificate (Settings → General → VPN & Device Management)
- Disconnect and reconnect the device

---

### Issue 3: Build errors about missing files

**Solution:**
```bash
# Reset Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData

# In Xcode:
# Product → Clean Build Folder (Cmd + Shift + K)
# Product → Build (Cmd + B)
```

---

### Issue 4: iCloud sync not working

**Solution:**
- iCloud only works on **physical devices**, not simulators
- Ensure you're signed into iCloud on your device (Settings → [Your Name] → iCloud)
- Check that **iCloud Drive** is enabled
- The app needs the **iCloud capability** enabled (already configured in `.entitlements`)

---

## Testing Features

### Test the Core Game

1. **Play a game:**
   - Type a 5-letter word (e.g., "CRANE")
   - Press Enter
   - Observe tile colors: 🟩 (correct), 🟨 (misplaced), ⬛ (wrong)

2. **Win a game:**
   - (Cheat: Check `WordleDataModel.swift`, add `print(selectedWord)` in `newGame()`)
   - Guess the correct word
   - See win toast → Statistics modal

3. **Test invalid inputs:**
   - Type 4 letters → Press Enter → Shake animation
   - Type "ZZZQQ" → Press Enter → "Not in word list" toast

### Test Hard Mode

1. Tap **Settings (⚙️)** → Toggle **Hard Mode**
2. Start a new game
3. Guess a word with a correct letter (e.g., "CRANE" has correct "R")
4. Next guess must include "R" in the correct position
5. Try guessing without "R" → See error toast

### Test Dark Mode

1. Tap **Settings (⚙️)** → Select **Dark** or **Light**
2. Theme changes immediately
3. Close app and reopen → Theme persists

### Test Statistics

1. Play multiple games (win/lose)
2. Tap **Stats (📊)**
3. Verify:
   - Games played count
   - Win percentage
   - Current/max streak
   - Guess distribution bar chart

### Test Share Feature

1. Win a game
2. In the stats modal, tap **Share**
3. Share sheet appears with emoji grid:
   ```
   Wordle 1 4/6
   ⬛🟨⬛⬛⬛
   ⬛🟨🟨⬛⬛
   🟩⬛⬛🟩🟩
   🟩🟩🟩🟩🟩
   ```

---

## Next Steps

Now that you're set up, explore the codebase:

1. **📖 Read the [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)**
   - Understand the architecture
   - Learn the code flow
   - Explore key components

2. **🔧 Try the [MODIFICATION_GUIDE.md](MODIFICATION_GUIDE.md)**
   - Change the word length
   - Modify colors
   - Add new features

3. **🎮 Experiment!**
   - Change the word list in `Global.swift`
   - Adjust animation speeds in `FlipView.swift`
   - Customize colors in `Assets.xcassets/`

---

## Useful Xcode Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd + R` | Build and run |
| `Cmd + .` | Stop running app |
| `Cmd + B` | Build only |
| `Cmd + Shift + K` | Clean build folder |
| `Cmd + Shift + O` | Open file by name |
| `Cmd + Shift + J` | Reveal file in navigator |
| `Cmd + /` | Toggle comment |
| `Cmd + [` / `]` | Indent/outdent |
| `Cmd + Option + Enter` | Show SwiftUI preview |
| `Cmd + Shift + Y` | Toggle debug area |

---

## Resources

- **Apple Developer Docs:** [developer.apple.com/documentation](https://developer.apple.com/documentation/)
- **SwiftUI Tutorials:** [developer.apple.com/tutorials/swiftui](https://developer.apple.com/tutorials/swiftui)
- **Swift Language Guide:** [docs.swift.org](https://docs.swift.org/)
- **Hacking with Swift:** [hackingwithswift.com](https://www.hackingwithswift.com/)

---

## Need Help?

- Review the **[DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** for architecture details
- Check the **[MODIFICATION_GUIDE.md](MODIFICATION_GUIDE.md)** for how-to guides
- Search Xcode errors in [Stack Overflow](https://stackoverflow.com/questions/tagged/swift)

Happy coding! 🚀
