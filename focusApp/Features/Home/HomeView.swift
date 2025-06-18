import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    print("Bantuan diklik")
                }) {
                    Image(systemName: "questionmark.circle")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)

            Spacer()

            HStack(spacing: 20) {
                Button {
                    coordinator.currentView = .alertMode
                } label: {
                    VStack {
                        Image(systemName: "photo.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        Text("Alert Mode")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .buttonStyle(PlainButtonStyle())

                Button {
                    coordinator.currentView = .quietMode
                } label: {
                    VStack {
                        Image(systemName: "photo.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        Text("Quiet Mode")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.6), Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 40)

            Button {
                coordinator.currentView = .history
            } label: {
                Text("History")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 60)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(15)
                    .shadow(radius: 5)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                EmptyView()
            }
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
    }
}


//import SwiftUI
//
//struct HomeView: View {
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        print("Bantuan diklik")
//                    }) {
//                        Image(systemName: "questionmark.circle")
//                            .font(.title2)
//                            .foregroundColor(.gray)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//                .padding(.horizontal)
//
//                Spacer()
//
//                HStack(spacing: 20) {
//                    NavigationLink(destination: AlertModeView()) {
//                        VStack {
//                            Image(systemName: "photo.fill")
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .padding(.bottom, 5)
//                            Text("Alert Mode")
//                                .font(.title2)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
//                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                        .cornerRadius(15)
//                        .shadow(radius: 5)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//
//                    NavigationLink(destination: QuietModeView()) {
//                        VStack {
//                            Image(systemName: "photo.fill")
//                                .font(.largeTitle)
//                                .foregroundColor(.white)
//                                .padding(.bottom, 5)
//                            Text("Quiet Mode")
//                                .font(.title2)
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
//                        .background(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.6), Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                        .cornerRadius(15)
//                        .shadow(radius: 5)
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//                .padding(.horizontal, 40)
//
//                // 🔁 Ganti Button menjadi NavigationLink untuk History
//                NavigationLink(destination: HistoryView()) {
//                    Text("History")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .frame(minWidth: 0, maxWidth: .infinity)
//                        .frame(height: 60)
//                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.purple]), startPoint: .leading, endPoint: .trailing))
//                        .cornerRadius(15)
//                        .shadow(radius: 5)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .padding(.horizontal, 40)
//
//                Spacer()
//            }
//            .padding(30)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.white)
//            .toolbar {
//                ToolbarItem(placement: .navigation) {
//                    EmptyView()
//                }
//                ToolbarItem(placement: .principal) {
//                    EmptyView()
//                }
//            }
//        }
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .frame(width: 800, height: 600)
//    }
//}
