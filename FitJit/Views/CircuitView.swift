import SwiftUI

struct CircuitView: View {
    @ObservedObject var presetManager: PresetManager  // Change from @StateObject to @ObservedObject
    @Environment(\.dismiss) var dismiss
    @State private var showingSavePreset = false
    @State private var showingSaveSheet = false
    @State private var showingRunCircuit = false
    @State private var presetName = ""
    
    // State variables for circuit configuration
    @State private var circuitAmount: Double = 1
    @State private var circuitRest: Double = 60
    @State private var roundsAmount: Double = 1
    @State private var roundsRest: Double = 30
    @State private var exercisesAmount: Double = 1
    @State private var exercisesTime: Double = 45
    @State private var exercisesRest: Double = 15
    @State private var addBuffer: Bool = true
    
    // Default initializer
    init(presetManager: PresetManager) {
        self._presetManager = ObservedObject(wrappedValue: presetManager)
    }
    
    // Preset initializer
    init(preset: Preset, presetManager: PresetManager) {
        self._presetManager = ObservedObject(wrappedValue: presetManager)
        _circuitAmount = State(initialValue: Double(preset.exercises[0].sets))
        _circuitRest = State(initialValue: Double(preset.exercises[0].rest))
        _exercisesTime = State(initialValue: Double(preset.exercises[0].duration))
        
        // Set other values to match the preset
        _roundsAmount = State(initialValue: 1)
        _roundsRest = State(initialValue: 30)
        _exercisesAmount = State(initialValue: 1)
        _exercisesRest = State(initialValue: 15)
        _addBuffer = State(initialValue: true)
        
        // Automatically start the circuit when initialized from a preset
        _showingRunCircuit = State(initialValue: true)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    CircuitSection(
                        circuitAmount: $circuitAmount,
                        circuitRest: $circuitRest
                    )
                    
                    RoundsSection(
                        roundsAmount: $roundsAmount,
                        roundsRest: $roundsRest
                    )
                    
                    ExercisesSection(
                        exercisesAmount: $exercisesAmount,
                        exercisesTime: $exercisesTime,
                        exercisesRest: $exercisesRest
                    )
                    
                    BufferToggle(addBuffer: $addBuffer)
                    
                    StartButton(action: {
                        showingRunCircuit = true
                    })
                    
                    Button(action: { showingSavePreset = true }) {
                        Text("Save as Preset")
                            .frame(width: 200, height: 50)
                            .background(Theme.primary)
                            .foregroundColor(Theme.buttonText)
                            .clipShape(Capsule())
                    }
                    .padding(.vertical)
                }
                .padding()
            }
            .background(Theme.background)
            //.navigationTitle("Circuit")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Theme.accent)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSaveSheet = true }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            }
            .alert("Save as Preset", isPresented: $showingSavePreset) {
                TextField("Preset Name", text: $presetName)
                Button("Cancel", role: .cancel) {
                    presetName = ""
                }
                Button("Save") {
                    saveAsPreset()
                }
            } message: {
                Text("Enter a name for this preset")
            }
            .navigationDestination(isPresented: $showingRunCircuit) {
                RunCircuitView(
                    circuitAmount: Int(circuitAmount),
                    circuitRest: Int(circuitRest),
                    roundsAmount: Int(roundsAmount),
                    roundsRest: Int(roundsRest),
                    exercisesAmount: Int(exercisesAmount),
                    exercisesTime: Int(exercisesTime),
                    exercisesRest: Int(exercisesRest),
                    addBuffer: addBuffer
                )
            }
            .sheet(isPresented: $showingSaveSheet) {
                NavigationStack {
                    Form {
                        TextField("Preset Name", text: $presetName)
                    }
                    .navigationTitle("Save Preset")
                    .navigationBarItems(
                        leading: Button("Cancel") { 
                            showingSaveSheet = false 
                        },
                        trailing: Button("Save") {
                            presetManager.saveCircuitAsPreset(
                                name: presetName,
                                circuitAmount: Int(circuitAmount),
                                circuitRest: Int(circuitRest),
                                exercisesTime: Int(exercisesTime)
                            )
                            showingSaveSheet = false
                        }
                        .disabled(presetName.isEmpty)
                    )
                }
                .presentationDetents([.height(150)])
            }
        }
    }
    
    private func saveAsPreset() {
        guard !presetName.isEmpty else { return }
        
        presetManager.saveCircuitAsPreset(
            name: presetName,
            circuitAmount: Int(circuitAmount),
            circuitRest: Int(circuitRest),
            exercisesTime: Int(exercisesTime)
        )
        
        presetName = ""
        showingSaveSheet = false
    }
}

// Helper Views
struct CircuitSection: View {
    @Binding var circuitAmount: Double
    @Binding var circuitRest: Double
    
    var body: some View {
        VStack {
            Text("Circuits")
                .font(.title)
                .foregroundColor(Theme.text)
                .padding(.bottom, 10)
            
            HStack {
                Text("Amount")
                Slider(value: $circuitAmount, in: 0...10, step: 1)
                    .tint(Theme.accent)
                    .background(Theme.sliderTrack.opacity(0.2))
                    .cornerRadius(10)
                Text("\(Int(circuitAmount))")
                    .frame(width: 50, alignment: .leading)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Rest")
                Slider(value: $circuitRest, in: 0...60, step: 15)
                    .tint(Theme.accent)
                    .background(Theme.sliderTrack.opacity(0.2))
                    .cornerRadius(10)
                Text("\(Int(circuitRest))s")
                    .frame(width: 50, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
}

struct RoundsSection: View {
    @Binding var roundsAmount: Double
    @Binding var roundsRest: Double
    
    var body: some View {
        VStack {
            Text("Rounds")
                .font(.title)
                .foregroundColor(Theme.text)
                .padding(.bottom, 10)
            
            HStack {
                Text("Amount")
                Slider(value: $roundsAmount, in: 0...10, step: 1)
                    .tint(Theme.accent)
                    .background(Theme.sliderTrack.opacity(0.2))
                    .cornerRadius(10)
                Text("\(Int(roundsAmount))")
                    .frame(width: 50, alignment: .leading)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Rest")
                Slider(value: $roundsRest, in: 0...60, step: 15)
                    .tint(Theme.accent)
                    .background(Theme.sliderTrack.opacity(0.2))
                    .cornerRadius(10)
                Text("\(Int(roundsRest))s")
                    .frame(width: 50, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
}

struct ExercisesSection: View {
    @Binding var exercisesAmount: Double
    @Binding var exercisesTime: Double
    @Binding var exercisesRest: Double
    
    var body: some View {
        VStack {
            Text("Exercises")
                .font(.title)
                .foregroundColor(Theme.text)
                .padding(.bottom, 10)
            
            HStack {
                Text("Amount")
                Slider(value: $exercisesAmount, in: 0...10, step: 1)
                    .tint(Theme.accent)
                    .background(Theme.sliderTrack.opacity(0.2))
                    .cornerRadius(10)
                Text("\(Int(exercisesAmount))")
                    .frame(width: 50, alignment: .leading)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Time")
                Slider(value: $exercisesTime, in: 0...180, step: 15)
                    .tint(Theme.accent)
                    .background(Theme.sliderTrack.opacity(0.2))
                    .cornerRadius(10)
                Text("\(Int(exercisesTime))s")
                    .frame(width: 50, alignment: .leading)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Rest")
                Slider(value: $exercisesRest, in: 0...60, step: 15)
                    .tint(Theme.accent)
                    .background(Theme.sliderTrack.opacity(0.2))
                    .cornerRadius(10)
                Text("\(Int(exercisesRest))s")
                    .frame(width: 50, alignment: .leading)
            }
            .padding(.horizontal)
        }
    }
}

struct BufferToggle: View {
    @Binding var addBuffer: Bool
    
    var body: some View {
        Toggle("Add 3-second buffer between exercises", isOn: $addBuffer)
            .padding(.horizontal)
            .tint(Theme.accent)
    }
}

struct StartButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Start")
                .frame(width: 200, height: 50)
                .background(Theme.accent)
                .foregroundColor(Theme.buttonText)
                .clipShape(Capsule())
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    CircuitView(presetManager: PresetManager())
}
