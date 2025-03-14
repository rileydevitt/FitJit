import Foundation

struct PresetExercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var duration: Int
    var sets: Int
    var rest: Int
    
    init(id: UUID = UUID(), name: String, duration: Int, sets: Int, rest: Int) {
        self.id = id
        self.name = name
        self.duration = duration
        self.sets = sets
        self.rest = rest
    }
}

struct Preset: Identifiable, Codable {
    let id: UUID
    var name: String
    var exercises: [PresetExercise]
    var color: Int
    
    init(id: UUID = UUID(), name: String, exercises: [PresetExercise], color: Int) {
        self.id = id
        self.name = name
        self.exercises = exercises
        self.color = color
    }
}