import SwiftUI

struct CircuitView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var circuitAmount: Double = 0
    @State private var circuitRest: Double = 0
    @State private var roundsAmount: Double = 0
    @State private var roundsRest: Double = 0
    @State private var exercisesAmount: Double = 0
    @State private var exercisesTime: Double = 0
    @State private var exercisesRest: Double = 0
    @State private var addBuffer: Bool = false
    
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
                    
                    StartButton(
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
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Circuit")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Theme.accent)
                    }
                }
            }
        }
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
    let circuitAmount: Int
    let circuitRest: Int
    let roundsAmount: Int
    let roundsRest: Int
    let exercisesAmount: Int
    let exercisesTime: Int
    let exercisesRest: Int
    let addBuffer: Bool
    
    var body: some View {
        NavigationLink(destination: RunCircuitView(
            circuitAmount: circuitAmount,
            circuitRest: circuitRest,
            roundsAmount: roundsAmount,
            roundsRest: roundsRest,
            exercisesAmount: exercisesAmount,
            exercisesTime: exercisesTime,
            exercisesRest: exercisesRest,
            addBuffer: addBuffer
        )) {
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
    CircuitView()
}