import SwiftUI

// MARK: - Graph Paper Background (static pattern, no per-frame redraws)

struct GraphPaperBackground: View {
    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = 24
            let lineColor = Color(red: 0.90, green: 0.85, blue: 0.82)
            Path { path in
                // Vertical lines
                var x: CGFloat = 0
                while x <= geo.size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                    x += spacing
                }
                // Horizontal lines
                var y: CGFloat = 0
                while y <= geo.size.height {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    y += spacing
                }
            }
            .stroke(lineColor, lineWidth: 0.5)
        }
    }
}

// MARK: - Animated Floating Sticker Emojis

struct FloatingStickersView: View {
    let stickers = ["🧸", "🌷", "💌", "🍫", "🥂", "💋", "🎀", "💝", "🌹", "💕"]

    struct StickerItem: Identifiable {
        let id: Int
        let emoji: String
        var x: CGFloat
        var startY: CGFloat
        let size: CGFloat
        let rotation: Double
        let speed: Double
    }

    @State private var items: [StickerItem] = []
    @State private var animating = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(items) { item in
                    Text(item.emoji)
                        .font(.system(size: item.size))
                        .rotationEffect(.degrees(item.rotation))
                        .position(
                            x: item.x,
                            y: animating ? -item.size : item.startY
                        )
                        .animation(
                            .linear(duration: item.speed)
                                .repeatForever(autoreverses: false),
                            value: animating
                        )
                        .opacity(0.45)
                }
            }
            .onAppear {
                let w = geo.size.width
                let h = geo.size.height
                items = (0..<10).map { i in
                    StickerItem(
                        id: i,
                        emoji: stickers[i % stickers.count],
                        x: CGFloat.random(in: 20...(w - 20)),
                        startY: CGFloat.random(in: 0...h) + h * 0.3,
                        size: CGFloat.random(in: 20...34),
                        rotation: Double.random(in: -20...20),
                        speed: Double.random(in: 14...26)
                    )
                }
                // Kick off float-up after layout
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animating = true
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Sticker Card Style

struct StickerCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 2, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color(red: 0.92, green: 0.88, blue: 0.85), lineWidth: 2)
                    )
            )
    }
}

// MARK: - Valentine Proposal View

struct ValentineProposalView: View {
    @Binding var currentScreen: AppScreen

    @State private var displayedText = ""
    @State private var roseScale: CGFloat = 0.0
    @State private var yesPressed = false
    @State private var showConfetti = false
    @State private var showNextButton = false
    @State private var noButtonOffset: CGSize = .zero
    @State private var noAttempts = 0
    @State private var typewriterTaskID = UUID()
    @State private var stickerBounce = false

    // Sticker theme colors
    private let bgCream = Color(red: 0.98, green: 0.96, blue: 0.93)
    private let boldPink = Color(red: 0.95, green: 0.30, blue: 0.45)
    private let softPink = Color(red: 0.98, green: 0.70, blue: 0.75)
    private let hotCoral = Color(red: 0.96, green: 0.40, blue: 0.50)
    private let warmRed = Color(red: 0.88, green: 0.22, blue: 0.35)
    private let darkText = Color(red: 0.25, green: 0.20, blue: 0.20)
    private let mutedText = Color(red: 0.50, green: 0.42, blue: 0.42)

    private let kindWords = "Every moment with you feels like a gift. Your smile lights up my world, your laugh is my favorite sound, and your love makes everything better. I fall for you more every single day."
    private let typewriterSpeed = 0.025

    var body: some View {
        ZStack {
            // Cream background with graph paper
            bgCream.ignoresSafeArea()
            GraphPaperBackground()
                .ignoresSafeArea()
                .opacity(0.6)

            // Floating sticker emojis (animated, drifting upward like the original hearts)
            FloatingStickersView()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Back button
                    HStack {
                        Button {
                            withAnimation(.spring()) {
                                currentScreen = .intro
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .bold))
                                Text("Back")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(boldPink)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 1, y: 2)
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(boldPink.opacity(0.3), lineWidth: 2)
                                    )
                            )
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    // Big sticker cluster
                    ZStack {
                        Circle()
                            .fill(softPink.opacity(0.3))
                            .frame(width: 160, height: 160)
                            .blur(radius: 20)

                        Text("💕")
                            .font(.system(size: 32))
                            .offset(x: -55, y: -40)
                            .rotationEffect(.degrees(-15))

                        Text("💌")
                            .font(.system(size: 28))
                            .offset(x: 55, y: -35)
                            .rotationEffect(.degrees(12))

                        Text("🌷")
                            .font(.system(size: 30))
                            .offset(x: -50, y: 35)
                            .rotationEffect(.degrees(-8))

                        Text("🍫")
                            .font(.system(size: 26))
                            .offset(x: 52, y: 38)
                            .rotationEffect(.degrees(10))

                        // Central rose
                        Text("🌹")
                            .font(.system(size: 80))
                            .scaleEffect(roseScale)
                            .scaleEffect(stickerBounce ? 1.05 : 1.0)
                    }
                    .onAppear {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.5)) {
                            roseScale = 1.0
                        }
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            stickerBounce = true
                        }
                    }

                    // Decorative divider
                    HStack(spacing: 8) {
                        dottedLine
                        Text("❤️")
                            .font(.system(size: 14))
                        dottedLine
                    }
                    .padding(.horizontal, 60)

                    // Kind words card
                    StickerCard {
                        VStack(spacing: 10) {
                            Text("\u{201C}")
                                .font(.system(size: 36, weight: .heavy, design: .serif))
                                .foregroundColor(hotCoral.opacity(0.5))
                                .offset(y: 6)

                            Text(displayedText)
                                .font(.system(size: 16, weight: .medium, design: .serif))
                                .foregroundColor(darkText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 8)
                                .frame(minHeight: 100)

                            Text("\u{201D}")
                                .font(.system(size: 36, weight: .heavy, design: .serif))
                                .foregroundColor(hotCoral.opacity(0.5))
                                .offset(y: -6)
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 24)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            startTypewriter()
                        }
                    }

                    // The question
                    VStack(spacing: 6) {
                        Text("VALENTINE'S")
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundColor(hotCoral)

                        Text("Will You Be Mine?")
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundColor(boldPink)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)

                    // Yes / No buttons
                    if !yesPressed {
                        VStack(spacing: 16) {
                            Button {
                                // Cancel the typewriter and show full text immediately
                                typewriterTaskID = UUID()
                                displayedText = kindWords

                                withAnimation(.spring()) {
                                    yesPressed = true
                                    showConfetti = true
                                }
                                // Show the next button after a brief moment
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    withAnimation(.spring()) {
                                        showNextButton = true
                                    }
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Text("❤️")
                                        .font(.system(size: 18))
                                    Text("Yes!")
                                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 48)
                                .padding(.vertical, 16)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [hotCoral, warmRed],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                                .shadow(color: warmRed.opacity(0.4), radius: 10, y: 5)
                            }

                            GeometryReader { geo in
                                Button {
                                    dodgeNoButton(in: geo.size)
                                } label: {
                                    Text(noButtonText)
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(mutedText)
                                        .padding(.horizontal, 28)
                                        .padding(.vertical, 12)
                                        .background(
                                            Capsule()
                                                .fill(Color.white)
                                                .overlay(
                                                    Capsule()
                                                        .strokeBorder(Color(red: 0.85, green: 0.80, blue: 0.78), lineWidth: 2)
                                                )
                                                .shadow(color: Color.black.opacity(0.05), radius: 3, y: 2)
                                        )
                                }
                                .offset(noButtonOffset)
                                .frame(maxWidth: .infinity)
                            }
                            .frame(height: 50)
                        }
                        .padding(.horizontal, 40)
                    } else {
                        VStack(spacing: 20) {
                            Text("I knew you would! 🥰")
                                .font(.system(size: 22, weight: .heavy, design: .rounded))
                                .foregroundColor(hotCoral)

                            if showNextButton {
                                Button {
                                    withAnimation(.spring()) {
                                        currentScreen = .itinerary
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Text("Here's What Comes Next")
                                            .font(.system(size: 17, weight: .bold, design: .rounded))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [hotCoral, warmRed],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                    )
                                    .shadow(color: warmRed.opacity(0.4), radius: 10, y: 5)
                                }
                                .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }

                    Spacer().frame(height: 40)
                }
                .padding(.top, 16)
            }
            .scrollIndicators(.hidden)

            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .ignoresSafeArea()
                    .onAppear {
                        // Dismiss confetti after animation completes
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                            showConfetti = false
                        }
                    }
            }
        }
    }

    // MARK: - Subviews

    private var dottedLine: some View {
        HStack(spacing: 4) {
            ForEach(0..<6, id: \.self) { _ in
                Circle()
                    .fill(softPink)
                    .frame(width: 4, height: 4)
            }
        }
    }

    // MARK: - Computed Properties

    private var noButtonText: String {
        switch noAttempts {
        case 0: return "No"
        case 1: return "Are you sure?"
        case 2: return "Nice try!"
        default: return "You have to say Yes!"
        }
    }

    // MARK: - Helpers

    private func startTypewriter() {
        let currentTaskID = typewriterTaskID
        displayedText = ""
        for (index, character) in kindWords.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * typewriterSpeed) {
                guard currentTaskID == typewriterTaskID else { return }
                displayedText += String(character)
            }
        }
    }

    private func dodgeNoButton(in size: CGSize) {
        noAttempts += 1
        let maxX = min(size.width / 2 - 40, 120.0)
        let maxY: CGFloat = 80
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            noButtonOffset = CGSize(
                width: CGFloat.random(in: -maxX...maxX),
                height: CGFloat.random(in: -maxY...maxY)
            )
        }
    }
}

#Preview {
    ValentineProposalView(currentScreen: .constant(.valentineProposal))
}
