import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    let session: CompletedSession

    @State private var categoryDurations: [StatCategory: TimeInterval] = [:]
    @State private var totalConsideredDuration: TimeInterval = 0
    @State private var focusPercentage: Int = 0 // New state to store calculated focus percentage

    // Formatter for durations
    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }()
    
    // Formatter for percentages
    private static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // MARK: - Properties
    private let displayCategories: [StatCategory] = [.focus, .drowsy, .distracted, .onBreak]

    // Computed property to determine the appropriate "Great Work" message
    private var greatWorkMessage: (text: String, emoji: String) {
        if focusPercentage >= 75 {
            return ("You Nailed It", "🤩")
        } else if focusPercentage >= 50 {
            return ("Pretty Good", "😆")
        } else if focusPercentage >= 25 {
            return ("You Can Do Better", "😉")
        } else {
            return ("Focus is Off", "😵") // Default for lower focus or if no focus recorded
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#FAF4FD"), Color(hex: "#F1E5FF")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Back Button
                HStack {
                    Button(action: {
                        coordinator.currentView = .home
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()

                // Title and subtitle
                VStack(spacing: 8) {
                    Text("\(greatWorkMessage.text) \(greatWorkMessage.emoji)") // Dynamic message here
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)

                    Text("Kamu telah bekerja selama **\(SummaryView.durationFormatter.string(from: session.duration) ?? "N/A")**.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                // Summary cards - Dynamically generated
                HStack(spacing: 20) {
                    ForEach(displayCategories, id: \.self) { category in
                        let duration = categoryDurations[category] ?? 0
                        let percentage = totalConsideredDuration > 0 ? (duration / totalConsideredDuration) : 0

                        // Display card if duration > 0 OR if the category is .focus (even if its duration is 0, to always show focus)
                        if duration > 0 || category == .focus {
                            SummaryCard(
                                percentage: Int(percentage * 100),
                                color: category.color,
                                title: category.rawValue,
                                duration: SummaryView.durationFormatter.string(from: duration) ?? "0 menit"
                            )
                        }
                    }
                }
                .padding(.top)

                Spacer()

                // Timeline bar
                TimelineBarView(session: session)
                    .frame(height: 120)
            }
            .padding(30)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) { EmptyView() }
        }
        .onAppear {
            // Calculate durations when the view appears
            categoryDurations = session.calculateCategoryDurations()
            
            // Calculate total duration of relevant categories for percentage calculation
            var calculatedTotalConsideredDuration: TimeInterval = 0
            for category in displayCategories {
                calculatedTotalConsideredDuration += categoryDurations[category] ?? 0
            }
            self.totalConsideredDuration = calculatedTotalConsideredDuration

            // Calculate and set focus percentage
            let focusDuration = categoryDurations[.focus] ?? 0
            if totalConsideredDuration > 0 {
                self.focusPercentage = Int((focusDuration / totalConsideredDuration) * 100)
            } else {
                self.focusPercentage = 0
            }
        }
    }
}
