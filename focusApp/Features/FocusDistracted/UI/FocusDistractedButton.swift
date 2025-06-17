import SwiftUI

struct FocusDistractedButton: View {
    var title: String
    var colorName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .padding(.horizontal, 30)
                .background(Color(colorName))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
