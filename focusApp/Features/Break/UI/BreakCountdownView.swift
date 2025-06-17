import SwiftUI

struct BreakCountdownView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var coordinator: AppCoordinator // ⬅️ Tambah ini
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
                        dismiss()
                        coordinator.currentView = .home
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
            SoundPlayer.shared.playSystemSound(named: "Pop") // 🔊 Suara saat mulai
            countdownTimer.onFinish = {
                SoundPlayer.shared.playSystemSound(named: "Submarine") // 🔔 Suara saat selesai
                print("Break selesai!")
                returnToMainState()
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
        coordinator.currentView = .home // ⬅️ Ganti tampilan via state
    }
}

struct BreakCountdownView_Previews: PreviewProvider {
    static var previews: some View {
        BreakCountdownView(duration: 5 * 60)
            .frame(width: 1000, height: 700)
            .environmentObject(AppCoordinator()) // ⬅️ Inject preview juga
    }
}
