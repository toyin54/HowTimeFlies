# How Time Flies

A personalized Valentine's Day iOS app built with SwiftUI. This app is an interactive romantic gift that takes your special someone through a Valentine's weekend experience — complete with a proposal screen, weekend itinerary, love reasons, and secret letters. All wrapped in beautiful animations, floating hearts, and confetti.

---

## What the App Does

The app has **4 screens** that flow into each other:

1. **Photo Carousel** — Shuffles through personal couple photos every time you open the app
2. **Valentine Proposal** — A romantic message with a typewriter effect. The "Yes" button accepts, and the "No" button playfully dodges away
3. **Weekend Itinerary** — A timeline of Valentine's weekend plans (dinner, movies, walks, etc.) with locations you can tap to open in Apple Maps
4. **Love Reasons & Secret Letters** — Flip-card animations showing reasons you love your partner. Long-press a card to reveal a secret love letter

---

## What You Need Before Starting

- **A Mac computer** (Xcode only runs on Mac)
- **Xcode** installed from the Mac App Store (free) — search "Xcode" in the App Store and install it
- **An iPhone** running **iOS 18.5 or newer**
- **A USB cable** (Lightning or USB-C) to connect your iPhone to your Mac
- **A free Apple ID** (you probably already have one if you use an iPhone)

> **Note:** You do NOT need a paid Apple Developer account ($99/year). A free Apple ID works — but the app will expire after 7 days and you'll need to reinstall it.

---

## Step-by-Step Instructions

### Step 1: Download the Project

1. Go to this GitHub repository page
2. Click the green **"Code"** button
3. Click **"Download ZIP"**
4. Find the downloaded ZIP file (usually in your **Downloads** folder) and double-click it to unzip
5. You should now have a folder called `HowTimeFlies` (or similar)

**Alternatively**, if you have Git installed, open **Terminal** and run:

```
git clone https://github.com/YOUR_USERNAME/HowTimeFlies.git
```

---

### Step 2: Open the Project in Xcode

1. Open the unzipped folder
2. Double-click the file called **`HowTimeFlies.xcodeproj`** — it has a blue icon that looks like a blueprint
3. Xcode will open. **Wait** for it to finish loading (you'll see activity in the top center bar). This may take a minute the first time

> If Xcode asks you to "Trust" the project or download additional components, click **Yes/Trust/Install**.

---

### Step 3: Set Up Your Apple ID in Xcode

This step lets Xcode sign the app so your iPhone will accept it.

1. In Xcode, go to the menu bar and click **Xcode > Settings** (or press `Cmd + ,`)
2. Click the **"Accounts"** tab at the top
3. Click the **"+"** button in the bottom-left corner
4. Select **"Apple ID"** and click **Continue**
5. Sign in with your Apple ID and password
6. Close the Settings window

---

### Step 4: Configure the Project to Use Your Apple ID

1. In the left sidebar of Xcode, click on the **blue project icon** at the very top (it says "HowTimeFlies")
2. In the middle panel, make sure the **"HowTimeFlies"** target is selected under **TARGETS**
3. Click the **"Signing & Capabilities"** tab
4. Check the box that says **"Automatically manage signing"**
5. Under **"Team"**, click the dropdown and select **your Apple ID** (it will show your name)
6. **Important:** You need to change the **Bundle Identifier** to something unique. Change `toyin.HowTimeFlies` to something like `yourname.HowTimeFlies` (replace `yourname` with your actual name, no spaces)

> If you see a red error about provisioning, the Bundle Identifier is probably not unique. Try a different name.

---

### Step 5: Connect Your iPhone

1. Plug your iPhone into your Mac with a USB cable
2. **On your iPhone**, you may see a popup that says **"Trust This Computer?"** — tap **Trust** and enter your passcode
3. In Xcode, look at the **top center** of the window. You'll see a bar that says something like `HowTimeFlies > iPhone 16 Pro`. Click on it
4. A dropdown will appear. Under **"iOS Devices"**, you should see your iPhone listed by name. **Select your iPhone**

> If your iPhone doesn't show up, try unplugging and replugging the cable, or restart Xcode.

---

### Step 6: Run the App on Your iPhone

1. Click the **Play button** (the triangle icon) in the top-left corner of Xcode, or press `Cmd + R`
2. Xcode will build the app. This takes 1-2 minutes the first time
3. **If this is your first time**, you'll likely see an error that says the app can't be launched because the developer is not trusted. This is normal! Follow the next step

---

### Step 7: Trust the Developer on Your iPhone

Since you're using a free Apple ID (not a paid developer account), your iPhone needs to trust your profile:

1. On your iPhone, go to **Settings > General > VPN & Device Management**
2. Under **"Developer App"**, you'll see your Apple ID email. Tap on it
3. Tap **"Trust"** and confirm
4. Go back to Xcode and click the **Play button** again

The app should now launch on your iPhone!

---

### Step 8: Personalize the App (Optional)

If you want to swap in your own photos and text:

- **Photos:** Replace the images in the `Assets.xcassets` folder inside Xcode. Click on an image set (like `us1`), then drag and drop your own photo onto the image slot
- **Love Reasons:** Edit the file `LoveReason.swift` to change the text of each reason
- **Secret Letters:** Edit the file `SecretLetter.swift` to write your own letters
- **Itinerary:** Edit the file `ValentineModels.swift` to change the weekend plans, locations, and descriptions

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| **"Untrusted Developer"** error on iPhone | Go to iPhone **Settings > General > VPN & Device Management** and trust your Apple ID |
| **iPhone not showing up** in Xcode | Unplug and replug the cable. Make sure you tapped "Trust This Computer" on your phone |
| **Red error about signing/provisioning** | Make sure you changed the Bundle Identifier to something unique (Step 4) |
| **Build failed with errors** | Make sure you're running the latest version of Xcode and your iPhone is on iOS 18.5+ |
| **App disappeared after 7 days** | With a free Apple ID, apps expire after 7 days. Just plug in your phone and hit Play in Xcode again to reinstall |
| **Xcode says "device not supported"** | Your iPhone's iOS version might be too old. Update your iPhone to iOS 18.5 or later |
| **Package dependency error** | Go to **File > Packages > Resolve Package Versions** in Xcode. This downloads the ConfettiSwiftUI library the app needs |

---

## Tech Details (For the Curious)

- **Language:** Swift 5.0
- **UI Framework:** SwiftUI
- **Minimum iOS Version:** 18.5
- **External Library:** [ConfettiSwiftUI](https://github.com/simibac/ConfettiSwiftUI) (downloaded automatically by Xcode)
- **No internet required:** The app runs completely offline once installed
