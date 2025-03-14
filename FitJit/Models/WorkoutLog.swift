import Foundation

struct WorkoutLog: Codable {
    var exercises: [LoggedExercise]
    var notes: String
    var duration: TimeInterval
    var date: Date
}

struct LoggedExercise: Codable, Identifiable {
    let id: UUID
    var name: String
    var sets: Int
    var reps: Int
    var weight: Int
    
    init(id: UUID = UUID(), name: String, sets: Int, reps: Int, weight: Int) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
}