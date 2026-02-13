import SwiftUI

enum AppScreen {
    case intro
    case valentineProposal
    case itinerary
    case reasons
}

struct ContentView: View {
    @State private var currentScreen: AppScreen = .intro

    var body: some View {
        ZStack {
            // Midnight Romance background — only shown on dark-themed screens
            if currentScreen == .intro || currentScreen == .reasons {
                ZStack {
                    // Base deep navy gradient
                    LinearGradient(
                        colors: [
                            Color(red: 0.08, green: 0.09, blue: 0.18),  // Deep midnight
                            Color(red: 0.12, green: 0.08, blue: 0.16),  // Dark plum
                            Color(red: 0.22, green: 0.08, blue: 0.14)   // Rich burgundy
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    // Subtle warm glow at the bottom
                    RadialGradient(
                        colors: [
                            Color(red: 0.35, green: 0.12, blue: 0.18).opacity(0.6),
                            Color.clear
                        ],
                        center: .bottomTrailing,
                        startRadius: 20,
                        endRadius: 400
                    )

                    // Soft ambient highlight
                    RadialGradient(
                        colors: [
                            Color(red: 0.25, green: 0.15, blue: 0.25).opacity(0.4),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 50,
                        endRadius: 350
                    )

                    // Floating hearts layer
                    BackgroundHeartsView()
                }
                .ignoresSafeArea()
            }

            switch currentScreen {
            case .intro:
                IntroView(currentScreen: $currentScreen)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            case .valentineProposal:
                ValentineProposalView(currentScreen: $currentScreen)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            case .itinerary:
                ItineraryView(currentScreen: $currentScreen)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            case .reasons:
                ReasonsView(currentScreen: $currentScreen)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: currentScreen)
    }
}

struct IntroView: View {
    @Binding var currentScreen: AppScreen
    @State private var currentIndex: Int = 0
    @State private var images: [String] = ["us1", "us2", "us3","us4"
    ,"us5","us6","us7","us8","us9","us10","us11","us12","us13","us14","img1","babe"] // Make sure these exist in Assets
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 20)

            VStack(spacing: 8) {
                Text("Happy Valentine's Day")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                Text("A Special Weekend Awaits Us")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.85))

                Text("February 19, 2026")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 32)

            // Photo carousel
            if !images.isEmpty {
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        ZStack {
                            if let uiImage = UIImage(named: images[index]) {
                                if images[index] == "babe" {
                                    GeometryReader { geo in
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
                                            .clipped()
                                    }
                                } else {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                }
                            } else {
                                // Fallback if image name is wrong/missing
                                Color.white.opacity(0.2)
                                    .overlay(
                                        Text("Add image '\(images[index])' to Assets")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding()
                                    )
                            }
                        }
                        .tag(index)
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .shadow(radius: 12)
                        .padding(.horizontal, 32)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 280)
            }

            // Little caption under photos
            Text("Walk With Me.....")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 4)

            Spacer()

            Button {
                currentScreen = .valentineProposal
            } label: {
                Text("Open Your Valentine 💌")
                    .font(.headline)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(Color.white.opacity(0.95))
                    .foregroundColor(.black)
                    .cornerRadius(32)
                    .shadow(radius: 8)
            }
            .padding(.bottom, 40)
        }
        .padding(.top, 16)
        .onAppear {
            images.shuffle()
            currentIndex = 0
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                images.shuffle()
                currentIndex = 0
            }
        }
    }
}

struct ReasonsView: View {
    @Binding var currentScreen: AppScreen
    
    @State private var currentReason: LoveReason = loveReasons.randomElement()
        ?? LoveReason(text: "You are loved.", isSecret: false)
    @State private var showSecret: Bool = false
    @State private var showSecretLetter: Bool = false
    @State private var cardScale: CGFloat = 1.0
    @State private var cardRotation: Double = 0
    @State private var glowPulse: Bool = false
    @State private var shuffleRotation: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with elegant back button
            HStack {
                Button {
                    withAnimation(.spring()) {
                        currentScreen = .itinerary
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .bold))
                        Text("Back")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(Color(red: 0.95, green: 0.85, blue: 0.88))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                
                Spacer()
                
                // Love counter badge
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                    Text("\(loveReasons.count) reasons")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                }
                .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.75))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color(red: 0.85, green: 0.30, blue: 0.40).opacity(0.2))
                )
            }
            .padding(.horizontal, 20)
            
            // Title section with decorative elements
            VStack(spacing: 8) {
                // Decorative top element
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.clear, Color(red: 0.85, green: 0.55, blue: 0.60)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 40, height: 1)
                    
                    Text("✦")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.80))
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.85, green: 0.55, blue: 0.60), Color.clear],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 40, height: 1)
                }
                
                Text("Two Years of Us")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                
                Text("December 10, 2023")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.90, green: 0.75, blue: 0.80))
                    .tracking(2)
            }
            .padding(.top, 8)
            
            Spacer(minLength: 12)
            
            // Main Reason Card - Completely redesigned
            ZStack {
                // Outer glow effect
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(red: 0.85, green: 0.35, blue: 0.45).opacity(0.3))
                    .blur(radius: glowPulse ? 25 : 20)
                    .scaleEffect(glowPulse ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowPulse)
                
                // Card background layers
                RoundedRectangle(cornerRadius: 28)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.18, green: 0.12, blue: 0.20),
                                Color(red: 0.12, green: 0.08, blue: 0.14)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.6),
                                        Color(red: 0.65, green: 0.35, blue: 0.45).opacity(0.3),
                                        Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                
                // Card content
                VStack(spacing: 10) {
                    // Reason number with decorative badge
                    
                    // Decorative divider
//                    HStack(spacing: 2) {
//                        ForEach(0..<3, id: \.self) { _ in
//                            Circle()
//                                .fill(Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.5))
//                                .frame(width: 4, height: 4)
//                        }
//                    }
                    
                    // Reason text with elegant quotes
                    VStack(spacing: 10) {
                        Text("\u{201C}")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.6))
                            .offset(y: 10)
                        
                        Text(currentReason.text)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.center)
                            .lineSpacing(6)
                            .padding(.horizontal, 8)
                        
                        Text("\u{201D}")
                            .font(.system(size: 40, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.85, green: 0.55, blue: 0.65).opacity(0.6))
                            .offset(y: -10)
                    }
                    
                    // Secret indicator
                    if currentReason.isSecret {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 12))
                            Text("Secret Reason")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                            Image(systemName: "sparkles")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.55))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(red: 0.95, green: 0.75, blue: 0.55).opacity(0.15))
                        )
                    }
                }
                .padding(.vertical, 28)
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .scaleEffect(cardScale)
            .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
            .onLongPressGesture {
                withAnimation(.spring()) {
                    showSecretLetter = true
                }
            }
            .onAppear { glowPulse = true }
            
            Spacer(minLength: 12)
            
            // Shuffle Button - Redesigned
            Button(action: shuffleReason) {
                HStack(spacing: 10) {
                    Image(systemName: "shuffle")
                        .font(.system(size: 16, weight: .bold))
                        .rotationEffect(.degrees(shuffleRotation))
                    Text("Shuffle")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(Color(red: 0.15, green: 0.10, blue: 0.12))
                .padding(.horizontal, 36)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.95, green: 0.80, blue: 0.85),
                                    Color(red: 0.90, green: 0.65, blue: 0.70)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(color: Color(red: 0.85, green: 0.55, blue: 0.60).opacity(0.4), radius: 15, y: 8)
            }
            
            // Hint text with icon
            HStack(spacing: 6) {
                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 11))
                Text("Hold card for a secret letter")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .foregroundColor(Color.white.opacity(0.5))
            .padding(.bottom, 8)
        }
        .padding(.vertical, 16)
        .overlay(
            Group {
                if showSecretLetter {
                    SecretLetterView(isVisible: $showSecretLetter)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        )
    }
    
    // MARK: - Helpers
    private func shuffleReason() {
        // Animate shuffle icon
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            shuffleRotation += 360
            cardScale = 0.95
        }
        
        // Card flip animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7).delay(0.1)) {
            cardRotation = 90
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            if let next = loveReasons.randomElement() {
                currentReason = next
                showSecret = next.isSecret
            }
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                cardRotation = 0
                cardScale = 1.0
            }
        }
    }
    
    private func indexOf(reason: LoveReason) -> Int {
        loveReasons.firstIndex(of: reason).map { $0 + 1 } ?? 1
    }
}

// MARK: - Floating Hearts Background for Main App
struct BackgroundHeartsView: View {
    @State private var hearts: [BackgroundHeart] = []
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(hearts) { heart in
                    Text(heart.symbol)
                        .font(.system(size: heart.size))
                        .foregroundColor(heart.color.opacity(heart.opacity))
                        .position(heart.position)
                        .blur(radius: heart.blur)
                }
            }
            .onAppear {
                createHearts(in: geo.size)
                startContinuousAnimation(in: geo.size)
            }
        }
    }
    
    private func createHearts(in size: CGSize) {
        let symbols = ["♥", "♡", "❤", "💕", "✨", "·"]
        let colors: [Color] = [
            Color(red: 0.85, green: 0.30, blue: 0.40),  // Rose
            Color(red: 0.75, green: 0.45, blue: 0.55),  // Dusty pink
            Color(red: 0.95, green: 0.70, blue: 0.75),  // Blush
            Color(red: 0.65, green: 0.35, blue: 0.45),  // Mauve
            Color(red: 0.90, green: 0.55, blue: 0.60)   // Coral
        ]
        
        hearts = (0..<25).map { _ in
            BackgroundHeart(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                size: CGFloat.random(in: 8...24),
                opacity: Double.random(in: 0.15...0.4),
                color: colors.randomElement()!,
                symbol: symbols.randomElement()!,
                blur: CGFloat.random(in: 0...2),
                speed: Double.random(in: 15...30)
            )
        }
    }
    
    private func startContinuousAnimation(in size: CGSize) {
        // Animate hearts floating upward continuously
        for i in hearts.indices {
            animateHeart(index: i, in: size)
        }
    }
    
    private func animateHeart(index: Int, in size: CGSize) {
        guard index < hearts.count else { return }
        
        let duration = hearts[index].speed
        
        // Move heart upward
        withAnimation(.linear(duration: duration)) {
            hearts[index].position.y = -50
            hearts[index].position.x += CGFloat.random(in: -30...30)
        }
        
        // Reset and repeat
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            // Reset position at bottom
            hearts[index].position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: size.height + 50
            )
            // Continue animation
            animateHeart(index: index, in: size)
        }
    }
}

struct BackgroundHeart: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let color: Color
    let symbol: String
    let blur: CGFloat
    let speed: Double
}

#Preview {
    ContentView()
}

