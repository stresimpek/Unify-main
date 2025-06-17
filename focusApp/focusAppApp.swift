import SwiftUI

@main
struct focusAppApp: App {
    // Create the coordinator
    @StateObject private var coordinator = AppCoordinator()
    
    // MARK: - FIX 1: Create the StatsManager here
    // This single instance will be shared across your entire app.
    @StateObject private var statsManager = StatsManager()

    var body: some Scene {
        WindowGroup {
            // The switch statement controls which view is visible
            switch coordinator.currentView {
            case .home:
                HomeView()
                    .environmentObject(coordinator)
                    // Note: HomeView probably doesn't need stats, but it's harmless to add.

            case .alertMode:
                AlertModeView()
                    .environmentObject(coordinator)
                    // MARK: - FIX 2: Inject StatsManager into AlertModeView
                    .environmentObject(statsManager)

            case .quietMode:
                QuietModeView()
                    .environmentObject(coordinator)
                    // MARK: - FIX 3: Inject StatsManager into QuietModeView
                    .environmentObject(statsManager)

            case .summary:
                SummaryView()
                    .environmentObject(coordinator)
                    // MARK: - FIX 4: Inject StatsManager into SummaryView
                    // The summary view will definitely need this to display the data.
                    .environmentObject(statsManager)

            case .history:
                HistoryView()
                    .environmentObject(coordinator)
                    // MARK: - FIX 5: Inject StatsManager into HistoryView
                    // The history view will also need this.
                    .environmentObject(statsManager)
            
            
            }
        }
    }
}
