import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#FAF4FD"), Color(hex: "#F1E5FF")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Tombol Back seperti di QuietModeView
                HStack {
                    Button(action: {
                        coordinator.currentView = .home
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()

                // Title dan subtitle
                VStack(spacing: 8) {
                    Text("Great Work 👏")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.black)

                    Text("Kamu telah bekerja selama **3 jam 30 menit**.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                // Summary cards
                HStack(spacing: 20) {
                    SummaryCard(percentage: 15, color: .orange, title: "Drowsy", duration: "20 menit")
                    SummaryCard(percentage: 75, color: .blue, title: "Fokus", duration: "150 menit")
                    SummaryCard(percentage: 10, color: .red, title: "Distraksi", duration: "10 menit")
                }
                .padding(.top)

                Spacer()

                // Timeline bar
                TimelineBarView()
                    .frame(height: 120)
            }
            .padding(30)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                EmptyView()
            }
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
            .environmentObject(AppCoordinator())
            .frame(width: 850, height: 600)
    }
}


//import SwiftUI
//
//struct SummaryView: View {
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            // Background gradient
//            LinearGradient(
//                gradient: Gradient(colors: [Color(hex: "#FAF4FD"), Color(hex: "#F1E5FF")]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .ignoresSafeArea()
//
//            VStack(spacing: 20) {
//                // Back button
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "chevron.left")
//                        .font(.title2)
//                        .padding(10)
//                        .background(Color.white)
//                        .clipShape(Circle())
//                        .shadow(radius: 2)
//                }
//                .padding(.top, 20)
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//                Spacer()
//
//                // Title and subtitle
//                VStack(spacing: 8) {
//                    Text("Great Work 👏")
//                        .font(.system(size: 34, weight: .bold))
//                        .foregroundColor(.black)
//
//                    Text("Kamu telah bekerja selama **3 jam 30 menit**.")
//                        .font(.title3)
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                }
//
//                // Summary cards
//                HStack(spacing: 20) {
//                    SummaryCard(percentage: 15, color: .orange, title: "Drowsy", duration: "20 menit")
//                    SummaryCard(percentage: 75, color: .blue, title: "Fokus", duration: "150 menit")
//                    SummaryCard(percentage: 10, color: .red, title: "Distraksi", duration: "10 menit")
//                }
//                .padding(.top)
//
//                Spacer()
//
//                // Timeline
//                TimelineBarView()
//                    .frame(height: 120)
//                    .padding(.bottom, 0)
//            }
//            .padding()
//        }
//        .navigationTitle("")
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//struct SummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        SummaryView()
//            .frame(width: 850, height: 600)
//    }
//}


