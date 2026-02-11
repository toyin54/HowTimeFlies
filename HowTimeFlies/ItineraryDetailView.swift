import SwiftUI

struct ItineraryDetailView: View {
    let item: ItineraryItem
    @Binding var isVisible: ItineraryItem?

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
            // Full background
            bgCream.ignoresSafeArea()
            GraphPaperBackground()
                .ignoresSafeArea()
                .opacity(0.5)

            VStack(spacing: 0) {
                // Top bar with close button
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring()) {
                            isVisible = nil
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(boldPink)
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 4, y: 2)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(boldPink.opacity(0.2), lineWidth: 1.5)
                                    )
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Hero image area
                        heroImageView

                        // Title + subtitle
                        VStack(spacing: 6) {
                            Text(item.title)
                                .font(.system(size: 28, weight: .heavy, design: .rounded))
                                .foregroundColor(hotCoral)

                            Text(item.subtitle)
                                .font(.system(size: 17, weight: .bold, design: .serif))
                                .foregroundColor(boldPink)
                        }
                        .multilineTextAlignment(.center)

                        // Info pills row
                        HStack(spacing: 12) {
                            infoPill(icon: "mappin.circle.fill", text: item.location)
                            infoPill(icon: "clock.fill", text: item.time)
                        }

                        // Apple Maps button
                        if let lat = item.latitude, let lon = item.longitude {
                            Button {
                                openInMaps(latitude: lat, longitude: lon, name: item.title)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Open in Maps")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [hotCoral, warmRed],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                )
                                .shadow(color: warmRed.opacity(0.3), radius: 6, y: 3)
                            }
                        }

                        // Description card
                        StickerCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("About")
                                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                                    .foregroundColor(hotCoral)
                                    .textCase(.uppercase)
                                    .tracking(1.5)

                                Text(item.description)
                                    .font(.system(size: 15, weight: .regular, design: .serif))
                                    .foregroundColor(darkText)
                                    .lineSpacing(5)
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 20)

                        // Fun facts section
                        if !item.funFacts.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack(spacing: 6) {
                                    Text("✨")
                                        .font(.system(size: 14))
                                    Text("Fun Facts")
                                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                                        .foregroundColor(hotCoral)
                                        .textCase(.uppercase)
                                        .tracking(1.5)
                                }
                                .padding(.horizontal, 20)

                                ForEach(Array(item.funFacts.enumerated()), id: \.offset) { index, fact in
                                    funFactCard(number: index + 1, text: fact)
                                }
                            }
                        }

                        Spacer().frame(height: 40)
                    }
                    .padding(.top, 8)
                }
            }
        }
    }

    // MARK: - Hero Image

    private var heroImageView: some View {
        Group {
            if let imageName = item.imageName, let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(Color.white, lineWidth: 3)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
                    .padding(.horizontal, 20)
            } else {
                // SF Symbol fallback
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [softPink, Color(red: 0.98, green: 0.92, blue: 0.93)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 180)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .strokeBorder(Color.white, lineWidth: 3)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 8, y: 4)

                    Image(systemName: item.icon)
                        .font(.system(size: 56, weight: .medium))
                        .foregroundColor(hotCoral)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Info Pill

    private func infoPill(icon: String, text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(hotCoral)

            Text(text)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(darkText)
                .lineLimit(1)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 4, y: 2)
                .overlay(
                    Capsule()
                        .strokeBorder(Color(red: 0.92, green: 0.88, blue: 0.85), lineWidth: 1.5)
                )
        )
    }

    // MARK: - Fun Fact Card

    private func funFactCard(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            // Number badge
            ZStack {
                Circle()
                    .fill(softPink)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .strokeBorder(hotCoral.opacity(0.3), lineWidth: 1.5)
                    )

                Text("\(number)")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(hotCoral)
            }

            Text(text)
                .font(.system(size: 14, weight: .regular, design: .serif))
                .foregroundColor(darkText)
                .lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 1, y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(red: 0.92, green: 0.88, blue: 0.85), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Maps

    private func openInMaps(latitude: Double, longitude: Double, name: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        if let url = URL(string: "maps://?ll=\(latitude),\(longitude)&q=\(encodedName)") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    let sampleItem = ItineraryItem(
        icon: "fork.knife",
        title: "Sushi by Bou",
        subtitle: "12-Course Omakase Experience",
        description: "An intimate culinary journey through the finest sushi, course by course. Each piece is crafted right in front of us by the chef — no menus, just trust and great fish.",
        location: "Sushi by Bou",
        time: "7:00 PM",
        funFacts: [
            "Omakase means 'I'll leave it up to you' the chef picks every course.",
            "Each seating is limited to just 10 guests for a truly intimate experience.",
        ],
        imageName: nil,
        latitude: 41.8875396,
        longitude: -87.6518407
    )
    ItineraryDetailView(item: sampleItem, isVisible: .constant(sampleItem))
}
