import Foundation

struct ItineraryItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    let location: String
    let time: String
    let funFacts: [String]
    let imageName: String?
    let latitude: Double?
    let longitude: Double?
}

struct ItineraryDay: Identifiable, Hashable {
    let id = UUID()
    let dayName: String
    let date: String
    let tagline: String
    let items: [ItineraryItem]
}

let images = ["sushu3", "wuther", "pizza","us4","us2"] // Make sure these exist in Assets

let valentineItinerary: [ItineraryDay] = [
    ItineraryDay(
        dayName: "Friday",
        date: "February 20",
        tagline: "The Week After Valentine's Day",
        items: [
            ItineraryItem(
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
                imageName: images[0],
                latitude: 41.8875396,
                longitude: -87.6518407
            ),
            ItineraryItem(
                icon: "figure.walk",
                title: "Evening Stroll",
                subtitle: "Walk Around the Park",
                description: "A romantic walk together under the night sky. The city lights, the quiet paths, and just the two of us.",
                location: "Down The Block",
                time: "9:30 PM",
                funFacts: [
                    "Central Park has over 9,000 benches — we should find our favorite.",
                    "The park is actually bigger than the country of Monaco.",
                    "Over 230 species of birds have been spotted in the park."
                ],
                imageName: images[3],
                latitude: 41.8875396,
                longitude: -87.6518407
            ),
            ItineraryItem(
                icon: "film",
                title: "Wuthering Heights",
                subtitle: "A Timeless Love Story",
                description: "Ending the night with a classic romance on the big screen. A story about a love so powerful it transcends everything.",
                location: "Rosevelt Collection",
                time: "9:30 PM",
                funFacts: [
                    "Wuthering Heights has been adapted into over 20 films and TV shows.",
                    "Emily Brontë wrote the novel under the pen name Ellis Bell.",
                    "The word 'wuthering' means stormy and windy in Yorkshire dialect."
                ],
                imageName: images[1],
                latitude: 41.8679,
                longitude: -87.6326
            )
        ]
    ),
    ItineraryDay(
        dayName: "Saturday",
        date: "February 21",
        tagline: "Our Chill Day",
        items: [
            ItineraryItem(
                icon: "camera.macro",
                title: "Bouquet Building",
                subtitle: "Flowers , Flowers , Flowers",
                description: "Who doesnt love flowers, So lets make our own bouquet",
                location: "Home Sweet Home",
                time: "All Day",
                funFacts: [
                    "As a gift and solemn decoration, bouquets began to be used only at the end of the 19th century.",
                    "The world’s smallest flower is the watermeal, which measures just 0.1mm across.",
                    "In ancient Greece and Rome, the bride and fiancé wore a necklace of flowers around their necks, symbolizing new life, luck, and fecundity.",
                    "Flower symbolism dates back to ancient times. For example, in ancient Greece, roses were associated with Aphrodite, the goddess of love."
                ],
                imageName: images[4],
                latitude: nil,
                longitude: nil
                
                
            ),
            ItineraryItem(
                icon: "tv",
                title: "Movie Marathon or can make a movie 😉",
                subtitle: "Pajamas All Day",
                description: "A cozy day in, just us and our favorite films. Blankets, snacks, and zero plans to leave the couch.",
                location: "Home Sweet Home",
                time: "All Day",
                funFacts: [
                    "The average person watches about 80,000 hours of TV in their lifetime.",
                    "Watching movies together actually strengthens relationships , it's science.",
                    "Pajama days are scientifically proven to reduce stress (okay, maybe not, but it feels true)."
                ],
                imageName: images[4],
                latitude: nil,
                longitude: nil
            ),
            ItineraryItem(
                icon: "takeoutbag.and.cup.and.straw",
                title: "Nella's Pizza",
                subtitle: "Your Favorite",
                description: "Because no weekend is complete without Nella's. The pizza that never misses.",
                location: "Nella's Pizza",
                time: "LunchTime",
                funFacts: [
                    "The perfect pizza dough needs at least 24 hours to rise properly.",
                    "Americans eat approximately 3 billion pizzas every year.",
                    "Our go-to order is already memorized — that's true love."
                ],
                imageName: images[2],
                latitude: 40.7128,
                longitude: -74.0060
            )
        ]
    )
]
