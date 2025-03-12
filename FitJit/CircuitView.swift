import SwiftUI

struct CircuitView: View {
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
            VStack(spacing: 20) {
                // Top third: Circuits
                VStack {
                    Text("Circuits")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("Amount")
                        Slider(value: $circuitAmount, in: 0...10, step: 1)
                        Text("\(Int(circuitAmount))")
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Rest")
                        Slider(value: $circuitRest, in: 0...60, step: 15)
                        Text("\(Int(circuitRest))s")
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
                
                Divider()
                
                // Middle third: Rounds
                VStack {
                    Text("Rounds")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("Amount")
                        Slider(value: $roundsAmount, in: 0...10, step: 1)
                        Text("\(Int(roundsAmount))")
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Rest")
                        Slider(value: $roundsRest, in: 0...60, step: 15)
                        Text("\(Int(roundsRest))s")
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
                
                Divider()
                
                // Bottom third: Exercises
                VStack {
                    Text("Exercises")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("Amount")
                        Slider(value: $exercisesAmount, in: 0...10, step: 1)
                        Text("\(Int(exercisesAmount))")
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Time")
                        Slider(value: $exercisesTime, in: 0...180, step: 15)
                        Text("\(Int(exercisesTime))s")
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Rest")
                        Slider(value: $exercisesRest, in: 0...60, step: 15)
                        Text("\(Int(exercisesRest))s")
                            .frame(width: 50, alignment: .leading)
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: .infinity)
                
                Divider()
                
                // Buffer Toggle
                Toggle("Add 3-second buffer between exercises", isOn: $addBuffer)
                    .padding(.horizontal)
                
                Divider()
                
                // Start Button
                NavigationLink(destination: RunCircuitView(
                    circuitAmount: Int(circuitAmount),
                    circuitRest: Int(circuitRest),
                    roundsAmount: Int(roundsAmount),
                    roundsRest: Int(roundsRest),
                    exercisesAmount: Int(exercisesAmount),
                    exercisesTime: Int(exercisesTime),
                    exercisesRest: Int(exercisesRest),
                    addBuffer: addBuffer
                )) {
                    Text("Start")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.bottom, 20)
            }
            .padding()
            .navigationTitle("Circuit")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Handle back action
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    CircuitView()
}