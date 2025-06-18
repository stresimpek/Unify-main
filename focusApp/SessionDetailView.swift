import SwiftUI

/// A view that shows a detailed breakdown of a single completed session.
struct SessionDetailView: View {
    // Input for the view
    let session: CompletedSession

    // For the dismiss button
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coordinator: AppCoordinator // Add coordinator for navigation

    @State private var categoryDurations: [StatCategory: TimeInterval] = [:]
    @State private var totalConsideredDuration: TimeInterval = 0
    @State private var focusPercentage: Int = 0 // New state for focus percentage

    // Formatter for the main title (still useful for the start time)
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()

    // Formatter for durations, now consistent with SummaryView
    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        // Allow hours, minutes, and seconds
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        // Drop all zero components by default, but this needs careful handling for seconds
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }()

    // Formatter for percentages (re-added as it's useful for cards)
    private static let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // MARK: - Properties
    // Use the same display categories as SummaryView for consistency
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
            // Background gradient (from SummaryView)
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#FAF4FD"), Color(hex: "#F1E5FF")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // MARK: - Header (similar to SummaryView's back button, but using dismiss)
                HStack {
                    Button(action: {
                        dismiss() // Dismiss the sheet/modal
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

                Spacer() // Pushes content towards the center/bottom

                // MARK: - Title and Subtitle (from SummaryView)
                VStack(spacing: 8) {
                    Text("\(greatWorkMessage.text) \(greatWorkMessage.emoji)")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)

                    Text("Kamu telah bekerja selama **\(Self.durationFormatter.string(from: session.duration) ?? "N/A")**.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                // MARK: - Summary Cards (from SummaryView)
                HStack(spacing: 20) {
                    ForEach(displayCategories, id: \.self) { category in
                        let duration = categoryDurations[category] ?? 0
                        let percentage = totalConsideredDuration > 0 ? (duration / totalConsideredDuration) : 0

                        if duration > 0 || category == .focus {
                            SummaryCard(
                                percentage: Int(percentage * 100),
                                color: category.color,
                                title: category.rawValue,
                                duration: Self.durationFormatter.string(from: duration) ?? "0 menit"
                            )
                        }
                    }
                }
                .padding(.top)

                Spacer() // Pushes content towards the center/top

                // MARK: - Timeline Bar (from TimelineBarView)
                TimelineBarView(session: session)
                    .frame(height: 170) // Use the full height of TimelineBarView
            }
            .padding(30)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) { EmptyView() }
        }
        .onAppear {
            // Calculate durations and focus percentage when the view appears (from SummaryView)
            categoryDurations = session.calculateCategoryDurations()
            
            var calculatedTotalConsideredDuration: TimeInterval = 0
            for category in displayCategories {
                calculatedTotalConsideredDuration += categoryDurations[category] ?? 0
            }
            self.totalConsideredDuration = calculatedTotalConsideredDuration

            let focusDuration = categoryDurations[.focus] ?? 0
            if totalConsideredDuration > 0 {
                self.focusPercentage = Int((focusDuration / totalConsideredDuration) * 100)
            } else {
                self.focusPercentage = 0
            }
        }
    }
}
