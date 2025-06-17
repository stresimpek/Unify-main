import SwiftUI

struct FocusLostButtons: View {
    var onBreakTapped: () -> Void
    var onFocusTapped: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            Button(action: onBreakTapped) {
                Text("break")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                    .background(Color("brownButtonB"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: onFocusTapped) {
                Text("Kembali fokus")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 30)
                    .background(Color("brownButtonA"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

