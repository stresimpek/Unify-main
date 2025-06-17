import SwiftUI

struct TimelineSegment: Identifiable {
    let id = UUID()
    let type: SegmentType
    let duration: CGFloat // in minutes
}

enum SegmentType {
    case fokus, drowsy, distraksi

    var color: Color {
        switch self {
        case .fokus: return .blue
        case .drowsy: return .orange
        case .distraksi: return .red
        }
    }
}

struct TimelineBarView: View {
    let segments: [TimelineSegment] = [
        .init(type: .fokus, duration: 25),
        .init(type: .distraksi, duration: 5),
        .init(type: .fokus, duration: 15),
        .init(type: .drowsy, duration: 10),
        .init(type: .fokus, duration: 15),
        .init(type: .fokus, duration: 30),
        .init(type: .fokus, duration: 15),
        .init(type: .distraksi, duration: 5),
        .init(type: .fokus, duration: 30),
    ]

    let totalDuration: CGFloat = 210
    let startTime = "13.05"
    let endTime = "16.35"

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background dengan top corner rounded
            RoundedTopCorners(radius: 30)
                .fill(Color.white)
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 12) {
                Text("Timeline")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .padding(.top, 16)

                GeometryReader { geometry in
                    let fullWidth = geometry.size.width - 32 // 16 left + 16 right

                    VStack(spacing: 8) {
                        // TIMELINE BAR
                        HStack(spacing: 0) {
                            ForEach(segments) { segment in
                                let width = fullWidth * (segment.duration / totalDuration)
                                Rectangle()
                                    .fill(segment.type.color)
                                    .frame(width: width, height: 40)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding(.horizontal, 16)

                        // LABEL WAKTU
                        HStack {
                            Text(startTime)
                            Spacer()
                            Text(endTime)
                        }
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                    }
                }
                .frame(height: 70) // cukup untuk bar dan waktu
            }
        }
        .frame(height: 170) // cukup untuk semua konten
    }
}
