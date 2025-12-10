//
//  SecretLetterView.swift
//  HowTimeFlies
//
//  Created by Ayyub Jose on 12/2/25.
//

import SwiftUI

struct SecretLetterView: View {
    @Binding var isVisible: Bool
    
    @State private var currentLetter: SecretLetter = secretLetters.randomElement()
        ?? SecretLetter(text: "You are deeply loved.")
    @State private var letterScale: CGFloat = 0.3
    @State private var letterOpacity: Double = 0
    @State private var sealBroken = false
    @State private var showContent = false
    @State private var displayedText = ""
    @State private var heartPulse = false
    @State private var showConfetti = false
    @State private var shuffleRotation: Double = 0
    @State private var cardFlip: Double = 0
    @State private var isShuffling = false
    @State private var typewriterTaskID = UUID()
    
    private let typewriterSpeed = 0.02
    
    var body: some View {
        ZStack {
            // Darker, romantic backdrop
            Color.black.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture {
                    if sealBroken {
                        // Don't close on tap when letter is open, only close button works
                    } else {
                        closeWithAnimation()
                    }
                }
            
            // Floating hearts in background
            FloatingHeartsView()
                .opacity(showContent ? 0.6 : 0)
            
            // Main letter card
            VStack(spacing: 0) {
                if !sealBroken {
                    sealedEnvelopeView
                } else {
                    openedLetterView
                }
            }
            .frame(maxWidth: 340)
            .background(
                ZStack {
                    // Paper texture background
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.98, blue: 0.94),
                                    Color(red: 0.98, green: 0.95, blue: 0.88)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Subtle paper grain
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.brown.opacity(0.03))
                    
                    // Elegant border
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.72, green: 0.53, blue: 0.40),
                                    Color(red: 0.85, green: 0.70, blue: 0.55)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                }
            )
            .shadow(color: Color.black.opacity(0.3), radius: 25, x: 0, y: 15)
            .scaleEffect(letterScale)
            .opacity(letterOpacity)
            .rotation3DEffect(.degrees(cardFlip), axis: (x: 0, y: 1, z: 0))
            .padding(.horizontal, 20)
            
            // Custom confetti overlay
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            entranceAnimation()
        }
    }
    
    // MARK: - Sealed Envelope View
    private var sealedEnvelopeView: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 40)
            
            // Wax seal
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.75, green: 0.15, blue: 0.20),
                                Color(red: 0.55, green: 0.08, blue: 0.12)
                            ],
                            center: .center,
                            startRadius: 5,
                            endRadius: 45
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.black.opacity(0.4), radius: 8, x: 2, y: 4)
                
                Text("💌")
                    .font(.system(size: 36))
                    .scaleEffect(heartPulse ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: heartPulse)
            }
            .onAppear { heartPulse = true }
            
            Text("A Secret Letter")
                .font(.custom("Snell Roundhand", size: 28))
                .foregroundColor(Color(red: 0.35, green: 0.25, blue: 0.20))
            
            Text("For My Love")
                .font(.custom("Snell Roundhand", size: 22))
                .foregroundColor(Color(red: 0.50, green: 0.40, blue: 0.35))
            
            // Letter count badge
            Text("\(secretLetters.count) letters inside")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Color(red: 0.65, green: 0.50, blue: 0.45))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color(red: 0.85, green: 0.75, blue: 0.70).opacity(0.5))
                )
            
            Spacer().frame(height: 12)
            
            Button {
                breakSeal()
            } label: {
                Text("Break the Seal")
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundColor(Color(red: 0.95, green: 0.92, blue: 0.88))
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.65, green: 0.15, blue: 0.22),
                                        Color(red: 0.45, green: 0.08, blue: 0.14)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .shadow(color: Color(red: 0.45, green: 0.08, blue: 0.14).opacity(0.5), radius: 8, y: 4)
            }
            
            Spacer().frame(height: 40)
        }
        .padding(24)
    }
    
    // MARK: - Opened Letter View
    private var openedLetterView: some View {
        VStack(spacing: 14) {
            // Decorative header with letter number
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(red: 0.75, green: 0.25, blue: 0.35))
                Rectangle()
                    .fill(Color(red: 0.75, green: 0.25, blue: 0.35).opacity(0.3))
                    .frame(height: 1)
                Text("Letter \(indexOf(letter: currentLetter)) of \(secretLetters.count)")
                    .font(.system(size: 11, weight: .medium, design: .serif))
                    .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.40))
                Rectangle()
                    .fill(Color(red: 0.75, green: 0.25, blue: 0.35).opacity(0.3))
                    .frame(height: 1)
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(red: 0.75, green: 0.25, blue: 0.35))
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Text("My Dearest")
                .font(.custom("Snell Roundhand", size: 26))
                .foregroundColor(Color(red: 0.35, green: 0.25, blue: 0.20))
            
            // Letter content with typewriter effect
            ScrollView(showsIndicators: false) {
                Text(displayedText)
                    .font(.system(size: 15, weight: .regular, design: .serif))
                    .foregroundColor(Color(red: 0.25, green: 0.20, blue: 0.18))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                    .padding(.horizontal, 8)
            }
            .frame(maxHeight: 220)
            .padding(.horizontal, 16)
            
            // Signature (shows when typing is complete)
            if displayedText.count >= currentLetter.text.count {
                VStack(spacing: 4) {
                    Text("Forever yours,")
                        .font(.custom("Snell Roundhand", size: 18))
                        .foregroundColor(Color(red: 0.45, green: 0.35, blue: 0.30))
                    Text("💙")
                        .font(.title2)
                }
                .transition(.opacity.combined(with: .scale))
            }
            
            // Buttons row
            HStack(spacing: 16) {
                // Shuffle button
                Button {
                    shuffleLetter()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "shuffle")
                            .font(.system(size: 12, weight: .bold))
                            .rotationEffect(.degrees(shuffleRotation))
                        Text("Next Letter")
                            .font(.system(size: 13, weight: .semibold, design: .serif))
                    }
                    .foregroundColor(Color(red: 0.95, green: 0.92, blue: 0.88))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.65, green: 0.15, blue: 0.22),
                                        Color(red: 0.45, green: 0.08, blue: 0.14)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                }
                
                // Close button
                Button {
                    closeWithAnimation()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .bold))
                        Text("Close")
                            .font(.system(size: 13, weight: .semibold, design: .serif))
                    }
                    .foregroundColor(Color(red: 0.55, green: 0.45, blue: 0.40))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .strokeBorder(Color(red: 0.75, green: 0.65, blue: 0.55), lineWidth: 1.5)
                    )
                }
            }
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - Animations
    private func entranceAnimation() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            letterScale = 1.0
            letterOpacity = 1.0
        }
    }
    
    private func breakSeal() {
        showConfetti = true
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            sealBroken = true
            showContent = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            typewriterEffect()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            showConfetti = false
        }
    }
    
    private func shuffleLetter() {
        // Prevent multiple rapid shuffles
        guard !isShuffling else { return }
        isShuffling = true
        
        // Cancel any ongoing typewriter
        typewriterTaskID = UUID()
        displayedText = ""
        
        // Animate shuffle icon
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            shuffleRotation += 360
        }
        
        // Pick a new random letter immediately
        if let newLetter = secretLetters.filter({ $0.id != currentLetter.id }).randomElement() ?? secretLetters.randomElement() {
            currentLetter = newLetter
        }
        
        // Start typewriter for new letter
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            typewriterEffect()
            isShuffling = false
        }
    }
    
    private func typewriterEffect() {
        let currentTaskID = typewriterTaskID
        displayedText = ""
        let text = currentLetter.text
        
        for (index, character) in text.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * typewriterSpeed) {
                // Only update if this is still the current task
                guard currentTaskID == typewriterTaskID else { return }
                displayedText += String(character)
            }
        }
    }
    
    private func closeWithAnimation() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            letterScale = 0.3
            letterOpacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isVisible = false
        }
    }
    
    private func indexOf(letter: SecretLetter) -> Int {
        secretLetters.firstIndex(of: letter).map { $0 + 1 } ?? 1
    }
}

// MARK: - Custom Confetti View
struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    let colors: [Color] = [
        Color(red: 0.85, green: 0.20, blue: 0.35),
        Color(red: 0.95, green: 0.55, blue: 0.65),
        Color(red: 1.0, green: 0.85, blue: 0.70),
        Color(red: 0.90, green: 0.75, blue: 0.60),
        Color(red: 0.98, green: 0.40, blue: 0.50),
        Color(red: 0.85, green: 0.65, blue: 0.75)
    ]
    
    let shapes: [String] = ["heart.fill", "star.fill", "circle.fill", "sparkle"]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(particles) { particle in
                    Image(systemName: particle.shape)
                        .font(.system(size: particle.size))
                        .foregroundColor(particle.color)
                        .rotationEffect(.degrees(particle.rotation))
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                createParticles(in: geo.size)
                animateParticles(in: geo.size)
            }
        }
        .ignoresSafeArea()
    }
    
    private func createParticles(in size: CGSize) {
        particles = (0..<60).map { _ in
            ConfettiParticle(
                position: CGPoint(
                    x: size.width / 2 + CGFloat.random(in: -50...50),
                    y: size.height / 2
                ),
                color: colors.randomElement()!,
                size: CGFloat.random(in: 8...20),
                rotation: Double.random(in: 0...360),
                opacity: 1.0,
                shape: shapes.randomElement()!,
                velocityX: CGFloat.random(in: -8...8),
                velocityY: CGFloat.random(in: -15...(-5)),
                rotationSpeed: Double.random(in: -10...10)
            )
        }
    }
    
    private func animateParticles(in size: CGSize) {
        for i in particles.indices {
            let particle = particles[i]
            let duration = Double.random(in: 2.5...4.0)
            let endX = particle.position.x + particle.velocityX * 60
            let endY = size.height + 100
            
            withAnimation(.easeOut(duration: duration)) {
                particles[i].position = CGPoint(x: endX, y: endY)
                particles[i].rotation += particle.rotationSpeed * 30
                particles[i].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let color: Color
    let size: CGFloat
    var rotation: Double
    var opacity: Double
    let shape: String
    let velocityX: CGFloat
    let velocityY: CGFloat
    let rotationSpeed: Double
}

// MARK: - Floating Hearts Background
struct FloatingHeartsView: View {
    @State private var hearts: [FloatingHeart] = []
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(hearts) { heart in
                    Text("♥")
                        .font(.system(size: heart.size))
                        .foregroundColor(Color(red: 0.85, green: 0.30, blue: 0.40).opacity(heart.opacity))
                        .position(heart.position)
                        .animation(
                            Animation.linear(duration: heart.duration)
                                .repeatForever(autoreverses: false),
                            value: heart.position
                        )
                }
            }
            .onAppear {
                createHearts(in: geo.size)
            }
        }
    }
    
    private func createHearts(in size: CGSize) {
        hearts = (0..<15).map { _ in
            FloatingHeart(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: size.height...(size.height + 100))
                ),
                size: CGFloat.random(in: 12...28),
                opacity: Double.random(in: 0.2...0.5),
                duration: Double.random(in: 8...15)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in hearts.indices {
                hearts[i].position.y = -50
            }
        }
    }
}

struct FloatingHeart: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let duration: Double
}

#Preview {
    SecretLetterView(isVisible: .constant(true))
}
