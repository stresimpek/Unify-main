import SwiftUI
import Combine

struct BreakCountdownView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var statsManager: StatsManager // <<< Add this
    @StateObject private var countdownTimer: BreakCountdownTimer

    init(duration: TimeInterval) {
        _countdownTimer = StateObject(wrappedValue: BreakCountdownTimer(duration: duration))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("green-break").ignoresSafeArea()

                VStack(spacing: 25) {
                    Spacer()

                    Text("It's time to break~")
                        .font(.largeTitle).bold()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 15)

                    VStack {
                        Text(timeString(from: countdownTimer.remainingTime))
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .frame(width: 300, height: 150)
                    .background(Color("green-timer"))
                    .cornerRadius(20)
                    .padding(.bottom, 20)

                    Text("Take a moment to rest and recharge before returning to work.")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)

                    Button("Stop break") {
                        countdownTimer.stop()
                        // <<< CALL END BREAK HERE WHEN USER MANUALLY STOPS
                        statsManager.endBreak()
                        returnToMainState() // This function handles dismissal and state change
                    }
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                    .background(Color("stopBreak"))
                    .cornerRadius(10)
                    .shadow(radius: 5)

                    Spacer()
                }
                .padding(30)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigation) { EmptyView() }
                ToolbarItem(placement: .principal) { EmptyView() }
            }
        }
        .onAppear {
            SoundPlayer.shared.playSystemSound(named: "Pop")
            countdownTimer.onFinish = {
                SoundPlayer.shared.playSystemSound(named: "Submarine")
                print("Break selesai!")
                // <<< CALL END BREAK HERE WHEN TIMER FINISHES
                statsManager.endBreak()
                returnToMainState() // This function handles dismissal and state change
            }
            countdownTimer.start()
        }
        .onDisappear {
            countdownTimer.stop()
        }
    }

    func timeString(from totalSeconds: TimeInterval) -> String {
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func returnToMainState() {
        // Ensure this sequence of actions: dismiss the view, then update coordinator state
        dismiss()
        coordinator.currentView = .alertMode // Or whatever the appropriate "focus" state is
        coordinator.closeLostOverlay() // Close the overarching overlay
    }
}

