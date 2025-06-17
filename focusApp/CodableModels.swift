import Foundation
import SwiftUI

// MARK: - State Event Model
/// Defines a single period of a detected state. Moved here to be with other models.
struct StateEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let state: DrowsinessState
    var startTime: Date
    var endTime: Date?

    var duration: TimeInterval {
        (endTime ?? Date()).timeIntervalSince(startTime)
    }
    
    // Add Equatable conformance for easier comparisons/testing
    static func == (lhs: StateEvent, rhs: StateEvent) -> Bool {
        lhs.id == rhs.id
    }
}


// MARK: - Completed Session Model
/// A codable struct to represent a finished session that can be saved to disk.
struct CompletedSession: Codable, Identifiable, Hashable {
    let id: UUID
    var startTime: Date
    var endTime: Date
    var events: [StateEvent]

    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }

    // Conformance to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Conformance to Equatable (required for Hashable)
    static func == (lhs: CompletedSession, rhs: CompletedSession) -> Bool {
        lhs.id == rhs.id
    }
}
