import SwiftUI

struct FocusLostView: View {
    var dismissAction: () -> Void
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showBreakOptionView = false

    var body: some View {
        ZStack {
            if showBreakOptionView {
                BreakOptionView()
                    .environmentObject(coordinator)
            } else {
                Color("yellow-lost").ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    Text("😴 Lagi ngantuk ya?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text("Kamu bisa ambil break sebentar biar lebih fresh, atau kalau sudah siap, yuk coba balik fokus pelan-pelan.")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    FocusLostButtons(
                        onBreakTapped: {
                            print("Tombol Break diklik")
                            showBreakOptionView = true
                        },
                        onFocusTapped: {
                            print("Tombol Kembali fokus diklik")
                            dismissAction()
                        }
                    )

                    Spacer()
                }
                .padding(30)
            }
        }
        .onAppear {
            SoundPlayer.shared.playSystemSound(named: "Funk")
        }
    }
}

struct FocusLostView_Previews: PreviewProvider {
    static var previews: some View {
        FocusLostView(dismissAction: {})
            .frame(width: 1000, height: 700)
            .environmentObject(AppCoordinator())
    }
}


