import SwiftUI

/// A view that shows a detailed breakdown of a single completed session.
struct SessionDetailView: View {
    // Input for the view
    let session: CompletedSession
    
    // For the dismiss button
    @Environment(\.dismiss) private var dismiss
    
    // A computed property that calculates statistics once
    private var stats: [StatDetail] {
        calculateStatDetails()
    }
    
    // Formatter for the main title
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Formatter for durations
    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Header
            HStack {
                Text("Session Summary")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button("Done") {
                    dismiss()
                }
            }
            .padding(.bottom, 10)
            
            // MARK: - Main Info
            VStack(alignment: .leading, spacing: 12) {
                Text(Self.dateFormatter.string(from: session.startTime))
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    Text("Total Duration:")
                        .foregroundColor(.secondary)
                    Text(Self.durationFormatter.string(from: session.duration) ?? "N/A")
                        .fontWeight(.medium)
                    Spacer()
                }
            }
            
            Divider()
            
            // MARK: - Timeline Bar
            VStack(alignment: .leading, spacing: 8) {
                Text("Timeline")
                    .font(.headline)
                
                // The single bar composed of event segments
                HStack(spacing: 0) {
                    if session.duration > 0 {
                        ForEach(session.events) { event in
                            // Width is proportional to the event's duration
                            let widthPercentage = event.duration / session.duration
                            
                            // Get the color from the state
                            event.state.color
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                                .frame(width: .infinity * widthPercentage)
                                .help("\(event.state.description): \(Self.durationFormatter.string(from: event.duration) ?? "")") // Tooltip
                        }
                    } else {
                        // Fallback for zero duration sessions
                        Color.gray
                           .frame(height: 20)
                    }
                }
                .clipShape(Capsule()) // Use Capsule for rounded ends
            }
            
            // MARK: - Statistics Breakdown
            VStack(alignment: .leading, spacing: 8) {
                Text("Statistics")
                    .font(.headline)
                
                // List of stats with percentages
                ForEach(stats) { stat in
                    HStack {
                        // Color indicator
                        Circle()
                            .fill(stat.category.color)
                            .frame(width: 10, height: 10)
                        
                        Text(stat.category.rawValue)
                        
                        Spacer()
                        
                        Text(String(format: "%.1f%%", stat.percentage * 100))
                            .fontWeight(.semibold)
                            .frame(width: 60, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Spacer()
        }
        .padding(30)
        .frame(minWidth: 450, idealWidth: 500, minHeight: 400, idealHeight: 480)
    }
    
    /// Helper struct to hold calculated stats for the list.
    struct StatDetail: Identifiable {
        let id = UUID()
        let category: StatCategory
        let percentage: Double
    }
    
    /// Processes the session's events to calculate the total duration and percentage for each category.
    private func calculateStatDetails() -> [StatDetail] {
        var categoryTotals: [StatCategory: TimeInterval] = [:]

        // Sum the duration for each category
        for event in session.events {
            let category = mapStateToCategory(event.state)
            categoryTotals[category, default: 0] += event.duration
        }

        // Calculate total duration, ensuring it's not zero to avoid division errors
        let totalDuration = session.duration
        guard totalDuration > 0 else { return [] }

        // Convert the totals into StatDetail models with percentages
        return categoryTotals
            .map { category, duration in
                StatDetail(category: category, percentage: duration / totalDuration)
            }
            .filter { $0.percentage > 0.001 } // Filter out negligible stats
            .sorted { $0.percentage > $1.percentage } // Sort from highest to lowest
    }
    
    /// Maps a detailed DrowsinessState to a broader StatCategory.
    private func mapStateToCategory(_ state: DrowsinessState) -> StatCategory {
        switch state {
        case .awake:
            return .focus
        case .eyesClosed, .yawning, .headDown:
            return .drowsy
        case .distracted(let type):
            return type == .phoneDetected ? .phoneDistracted : .distracted
        case .noFaceDetected, .error:
            return .noFace
        case .onBreak:
            return .onBreak
        }
    }
}

#Preview {
    // Create some dummy data for the preview
    let dummySession = CompletedSession(
        id: UUID(),
        startTime: Date().addingTimeInterval(-3600), // 1 hour ago
        endTime: Date(),
        events: [
            StateEvent(id: UUID(), state: .awake, startTime: Date().addingTimeInterval(-3600), endTime: Date().addingTimeInterval(-1800)), // 30 min focus
            StateEvent(id: UUID(), state: .yawning, startTime: Date().addingTimeInterval(-1800), endTime: Date().addingTimeInterval(-900)), // 15 min drowsy
            StateEvent(id: UUID(), state: .distracted(.faceTurned), startTime: Date().addingTimeInterval(-900), endTime: Date().addingTimeInterval(-600)), // 5 min distracted
            StateEvent(id: UUID(), state: .awake, startTime: Date().addingTimeInterval(-600), endTime: Date()) // 10 min focus
        ]
    )
    
    return SessionDetailView(session: dummySession)
}
