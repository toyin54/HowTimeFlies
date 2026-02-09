import SwiftUI

struct ItineraryView: View {
    @Binding var currentScreen: AppScreen

    @State private var visibleItems: Set<String> = []
    @State private var selectedItem: ItineraryItem? = nil

    // Sticker theme colors
    private let bgCream = Color(red: 0.98, green: 0.96, blue: 0.93)
    private let boldPink = Color(red: 0.95, green: 0.30, blue: 0.45)
    private let softPink = Color(red: 0.98, green: 0.70, blue: 0.75)
    private let hotCoral = Color(red: 0.96, green: 0.40, blue: 0.50)
    private let warmRed = Color(red: 0.88, green: 0.22, blue: 0.35)
    private let darkText = Color(red: 0.25, green: 0.20, blue: 0.20)
    private let mutedText = Color(red: 0.50, green: 0.42, blue: 0.42)

    var body: some View {
        ZStack {
            // Cream background with graph paper
            bgCream.ignoresSafeArea()
            GraphPaperBackground()
                .ignoresSafeArea()
                .opacity(0.6)

            // Floating sticker emojis (animated, drifting upward)
            FloatingStickersView()

            VStack(spacing: 0) {
                // Back button row
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            currentScreen = .valentineProposal
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
                .padding(.top, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            // Dotted divider
                            HStack(spacing: 4) {
                                ForEach(0..<6, id: \.self) { _ in
                                    Circle()
                                        .fill(softPink)
                                        .frame(width: 4, height: 4)
                                }
                                Text("❤️")
                                    .font(.system(size: 12))
                                ForEach(0..<6, id: \.self) { _ in
                                    Circle()
                                        .fill(softPink)
                                        .frame(width: 4, height: 4)
                                }
                            }

                            Text("OUR VALENTINE'S")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .foregroundColor(hotCoral)

                            Text("Weekend")
                                .font(.system(size: 26, weight: .bold, design: .serif))
                                .foregroundColor(boldPink)

                            Text("FEBRUARY 14 – 15, 2026")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(mutedText)
                                .tracking(2)
                        }
                        .padding(.top, 12)

                        // Day sections
                        ForEach(valentineItinerary) { day in
                            daySectionView(day: day)
                        }

                        // Continue button
                        Button {
                            withAnimation(.spring()) {
                                currentScreen = .reasons
                            }
                        } label: {
                            HStack(spacing: 10) {
                                Text("See Why I Love You")
                                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                                Text("❤️")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 36)
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
                            .shadow(color: warmRed.opacity(0.35), radius: 10, y: 5)
                        }
                        .padding(.top, 8)

                        Spacer().frame(height: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .overlay(
            Group {
                if let item = selectedItem {
                    ItineraryDetailView(item: item, isVisible: $selectedItem)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        )
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: selectedItem)
        .onAppear {
            revealItemsSequentially()
        }
    }

    // MARK: - Day Section

    private func daySectionView(day: ItineraryDay) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Day badge
            HStack(spacing: 10) {
                HStack(spacing: 6) {
                    Text(day.dayName == "Friday" ? "💘" : "🌙")
                        .font(.system(size: 14))
                    Text(day.dayName)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [hotCoral, warmRed],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: warmRed.opacity(0.3), radius: 4, y: 2)
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(day.date)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(darkText)
                    Text(day.tagline)
                        .font(.system(size: 11, weight: .medium, design: .serif))
                        .foregroundColor(hotCoral)
                }
            }

            // Timeline items
            VStack(spacing: 0) {
                ForEach(Array(day.items.enumerated()), id: \.element.id) { index, item in
                    let itemKey = "\(day.dayName)-\(index)"
                    let isVisible = visibleItems.contains(itemKey)

                    VStack(spacing: 0) {
                        Button {
                            withAnimation(.spring()) {
                                selectedItem = item
                            }
                        } label: {
                            StickerItineraryCard(
                                icon: item.icon,
                                title: item.title,
                                subtitle: item.subtitle,
                                description: item.description
                            )
                        }
                        .buttonStyle(.plain)
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible ? 0 : 20)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)

                        if index < day.items.count - 1 {
                            stickerTimelineConnector
                                .opacity(isVisible ? 1 : 0)
                                .animation(.easeIn(duration: 0.3).delay(0.2), value: isVisible)
                        }
                    }
                }
            }
            .padding(.leading, 8)
        }
    }

    // MARK: - Timeline Connector

    private var stickerTimelineConnector: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { _ in
                Circle()
                    .fill(softPink)
                    .frame(width: 5, height: 5)
                    .padding(.vertical, 2)
            }
            Text("💕")
                .font(.system(size: 10))
            ForEach(0..<3, id: \.self) { _ in
                Circle()
                    .fill(softPink)
                    .frame(width: 5, height: 5)
                    .padding(.vertical, 2)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Staggered Reveal

    private func revealItemsSequentially() {
        var delay = 0.3
        for day in valentineItinerary {
            for index in day.items.indices {
                let key = "\(day.dayName)-\(index)"
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation {
                        _ = visibleItems.insert(key)
                    }
                }
                delay += 0.25
            }
            delay += 0.15
        }
    }
}

// MARK: - Sticker Itinerary Item Card

struct StickerItineraryCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String

    private let hotCoral = Color(red: 0.96, green: 0.40, blue: 0.50)
    private let darkText = Color(red: 0.25, green: 0.20, blue: 0.20)
    private let mutedText = Color(red: 0.50, green: 0.42, blue: 0.42)

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.98, green: 0.92, blue: 0.93))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Circle()
                            .strokeBorder(hotCoral.opacity(0.3), lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 3, y: 2)

                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(hotCoral)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundColor(darkText)

                Text(subtitle)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(hotCoral)

                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .serif))
                    .foregroundColor(mutedText)
                    .lineSpacing(4)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 2, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color(red: 0.92, green: 0.88, blue: 0.85), lineWidth: 1.5)
                )
        )
    }
}

#Preview {
    ItineraryView(currentScreen: .constant(.itinerary))
}
