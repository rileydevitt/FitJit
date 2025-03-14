import SwiftUI

struct AddPresetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var presetManager: PresetManager
    @State private var presetName = ""
    @State private var exercises: [PresetExercise] = []
    @State private var showingExerciseSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preset Name")) {
                    TextField("Name", text: $presetName)
                }
                
                Section(header: Text("Exercises")) {
                    ForEach(exercises.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(exercises[index].name)
                            Text("\(exercises[index].duration)s, \(exercises[index].sets) sets, \(exercises[index].rest)s rest")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteExercise)
                    
                    Button("Add Exercise") {
                        showingExerciseSheet = true
                    }
                }
            }
            .navigationTitle("New Preset")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePreset()
                    }
                    .disabled(presetName.isEmpty || exercises.isEmpty)
                }
            }
            .sheet(isPresented: $showingExerciseSheet) {
                AddExerciseView(exercises: $exercises)
            }
        }
    }
    
    private func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
    
    private func savePreset() {
        let preset = Preset(
            name: presetName,
            exercises: exercises,
            color: Int.random(in: 0...1) // Randomly assign primary or secondary color
        )
        presetManager.savePreset(preset)
        dismiss()
    }
}

struct AddExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var exercises: [PresetExercise]
    @State private var exerciseName = ""
    @State private var duration = 30
    @State private var sets = 1
    @State private var rest = 15
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Exercise Name", text: $exerciseName)
                
                Stepper("Duration: \(duration)s", value: $duration, in: 5...300, step: 5)
                Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                Stepper("Rest: \(rest)s", value: $rest, in: 0...120, step: 5)
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let exercise = PresetExercise(
                            name: exerciseName,
                            duration: duration,
                            sets: sets,
                            rest: rest
                        )
                        exercises.append(exercise)
                        dismiss()
                    }
                    .disabled(exerciseName.isEmpty)
                }
            }
        }
    }
}