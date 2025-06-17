import SwiftUI

struct FocusDistractedView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    var dismissAction: () -> Void        // Untuk tombol "Kembali fokus"
    var stopModeAction: () -> Void       // Untuk tombol "Stop Mode"

    var body: some View {
        ZStack {
            Color("red-distract").ignoresSafeArea()

            VStack(spacing: 20) {
                topBar
                Spacer()
                messageText
                Spacer()
                FocusDistractedButton(title: "Kembali fokus", colorName: "redButtonA", action: dismissAction)
                Spacer()
            }
            .padding()
        }
        .onAppear {
            SoundPlayer.shared.playSystemSound(named: "Glass")
        }
    }

    // Tombol "Stop Mode"
    private var topBar: some View {
        HStack {
            Spacer()
            Button(action: stopModeAction) {
                Text("Stop Mode")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 35)
                    .background(Color("redButtonB").opacity(0.8))
                    .cornerRadius(15)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .padding(.top, 20)
    }

    private var messageText: some View {
        VStack(spacing: 25) {
            Text("👋 Psst... layarnya di sini loh!")
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Coba balik lihat layar lagi, yuk—kerjaan kamu masih nungguin buat diselesain biar ga ketunda terlalu lama.")
                .font(.system(size: 21, weight: .regular))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

struct FocusDistractedView_Previews: PreviewProvider {
    static var previews: some View {
        FocusDistractedView(dismissAction: {}, stopModeAction: {})
            .environmentObject(AppCoordinator())
            .frame(width: 1000, height: 700)
    }
}

