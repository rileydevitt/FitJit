import Foundation

class PresetManager: ObservableObject {
    @Published var presets: [Preset] = []
    private let saveKey = "SavedPresets"
    
    init() {
        loadPresets()
    }
    
    func savePreset(_ preset: Preset) {
        presets.append(preset)
        savePresets()
    }
    
    func deletePreset(at offsets: IndexSet) {
        presets.remove(atOffsets: offsets)
        savePresets()
    }
    
    func deletePreset(at index: Int) {
        presets.remove(at: index)
        savePresets()
    }
    
    private func savePresets() {
        if let encoded = try? JSONEncoder().encode(presets) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadPresets() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Preset].self, from: data) {
            presets = decoded
        }
    }
    
    func saveCircuitAsPreset(
        name: String,
        circuitAmount: Int,
        circuitRest: Int,
        exercisesTime: Int,
        color: Int = Int.random(in: 0...1)
    ) {
        let presetExercise = PresetExercise(
            name: "Circuit",
            duration: exercisesTime,
            sets: circuitAmount,
            rest: circuitRest
        )
        
        let newPreset = Preset(
            name: name,
            exercises: [presetExercise],
            color: color
        )
        
        presets.append(newPreset)
        savePresets()
    }
}