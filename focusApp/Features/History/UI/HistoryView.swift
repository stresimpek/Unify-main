import SwiftUI

// The SessionSummary and HistorySection can be removed as we'll use the core models directly.
struct HistorySection: Identifiable {
    let id = UUID()
    let date: String
    let sessions: [CompletedSession] // Changed from SessionSummary to CompletedSession
}


struct HistoryView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var historySections: [HistorySection] = []
    @State private var isLoading = true
    @State private var selectedSession: CompletedSession? // State to trigger the sheet

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header and Back Button
            HStack {
                 Button(action: {
                    coordinator.currentView = .home
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                        Text("Kembali")
                    }
                    .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                
            }
            .overlay(
                // This keeps the title centered
                Text("Session History")
                    .font(.headline)
                    .fontWeight(.semibold)
            )

            // MARK: - Main Content
            if isLoading {
                Spacer()
                ProgressView("Loading History...")
                    .frame(maxWidth: .infinity)
                Spacer()
            } else if historySections.isEmpty {
                // MARK: - Empty State
                Spacer()
                VStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                    Text("No History Found")
                        .font(.headline)
                    Text("Complete a session to see your history here.")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else {
                // MARK: - History List
                ScrollView {
                    ForEach(Array(historySections.enumerated()), id: \.element.id) { index, section in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(section.date)
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.leading, 8)

                            ForEach(section.sessions) { session in
                                // Pass the full session object to the row view
                                HistoryRowView(session: session)
                                    .onTapGesture {
                                        // Set the selected session to show the detail sheet
                                        self.selectedSession = session
                                    }
                            }
                        }
                        .padding(.top, index == 0 ? 0 : 24)
                    }
                }
            }
        }
        .padding(30)
        .background(Color(.windowBackgroundColor))
        .onAppear(perform: loadHistory)
        // MARK: - Sheet Presentation
        // This modifier presents the SessionDetailView when selectedSession is not nil
        .sheet(item: $selectedSession) { session in
            SessionDetailView(session: session)
        }
    }
    
    // ... (formatDuration helper remains the same) ...
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "0s"
    }

    /// Loads and processes session data from storage.
    private func loadHistory() {
        let sessions = HistoryStorage.shared.loadAllSessions()
        self.historySections = groupSessionsByDate(sessions)
        self.isLoading = false
    }

    /// Groups sessions into sections based on their date.
    private func groupSessionsByDate(_ sessions: [CompletedSession]) -> [HistorySection] {
        guard !sessions.isEmpty else { return [] }
        
        let formatter = DateFormatter()
        let calendar = Calendar.current

        let groupedByDateComponent = Dictionary(grouping: sessions) { session in
            calendar.startOfDay(for: session.startTime)
        }

        let sortedDates = groupedByDateComponent.keys.sorted(by: >)

        return sortedDates.map { date in
            let dateString: String
            if calendar.isDateInToday(date) {
                dateString = "Today"
            } else if calendar.isDateInYesterday(date) {
                dateString = "Yesterday"
            } else {
                formatter.dateFormat = "MMMM d, yyyy"
                dateString = formatter.string(from: date)
            }
            
            // The dictionary now contains the full [CompletedSession] array
            let sessionsForDate = groupedByDateComponent[date] ?? []
            
            return HistorySection(date: dateString, sessions: sessionsForDate)
        }
    }
}


// MARK: - History Row Subview (Updated)
struct HistoryRowView: View {
    // Now takes the full session object
    let session: CompletedSession

    // Formatter for the time string
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    // Formatter for the duration string
    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        return formatter
    }()

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Session at \(Self.timeFormatter.string(from: session.startTime))")
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Text(Self.durationFormatter.string(from: session.duration) ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}
