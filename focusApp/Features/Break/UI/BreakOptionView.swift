import SwiftUI

struct BreakOptionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var statsManager: StatsManager // <<< Add this
    @State private var navigateToBreakCountdown = false
    @State private var selectedBreakDuration: TimeInterval = 0

    var body: some View {
        NavigationStack {
            ZStack {
                Color("yellow-break")
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    Text("💤 Mau break berapa lama?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)

                    Text("Kamu bisa pilih break 5, 10, atau 15 menit. Ambil waktu yang pas biar bisa balik kerja dengan lebih segar.")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    HStack(spacing: 20) {
                        ForEach([0.5, 10, 15], id: \.self) { minute in
                            Button(action: {
                                print("\(minute) Menit Break dipilih")
                                selectedBreakDuration = TimeInterval(minute * 60)
                                
                                // <<< CALL START BREAK HERE, when a duration is chosen and the timer is about to begin
                                statsManager.startBreak()

                                navigateToBreakCountdown = true
                            }) {
                                Text("\(minute) Menit")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 20)
                                    .background(Color("brownButtonA"))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.bottom, 20)

                    Button(action: {
                        print("Tombol Cancel diklik di BreakOptionView")
                        dismiss()
                        // If cancelling here means returning to a non-break state immediately
                        // and not starting a break, no statsManager.endBreak() is needed.
                        // However, if a break was *already started* (e.g., if this view is presented mid-break),
                        // you might need to handle that. Based on your flow, the break starts *after* selection.
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color("brownButtonC"))
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                }
                .padding(30)
            }
            .navigationDestination(isPresented: $navigateToBreakCountdown) {
                BreakCountdownView(duration: selectedBreakDuration)
                    .environmentObject(coordinator)
                    .environmentObject(statsManager) // <<< Ensure statsManager is passed here
                    .onDisappear {
                        navigateToBreakCountdown = false
                    }
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigation) { EmptyView() }
                ToolbarItem(placement: .principal) { EmptyView() }
            }
        }
    }
}
