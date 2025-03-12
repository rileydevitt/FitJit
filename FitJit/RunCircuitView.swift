import SwiftUI

struct RunCircuitView: View {
    var circuitAmount: Int
    var circuitRest: Int
    var roundsAmount: Int
    var roundsRest: Int
    var exercisesAmount: Int
    var exercisesTime: Int
    var exercisesRest: Int
    var addBuffer: Bool
    
    @State private var countdown: Int = 10
    @State private var exerciseCountdown: Int = 0
    @State private var currentExercise: Int = 1
    @State private var currentCircuit: Int = 1
    @State private var isRunning: Bool = false
    @State private var isBufferActive: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            if !isRunning {
                Text("Get Ready")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                Text("Starting in \(countdown)")
                    .font(.title)
                    .onAppear {
                        startCountdown()
                    }
            } else {
                Text("Circuit \(currentCircuit) of \(circuitAmount)")
                    .font(.title)
                    .padding(.top, 20)
                
                Text("Exercise \(currentExercise) of \(exercisesAmount)")
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(.blue)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(exerciseCountdown) / CGFloat(isBufferActive ? 3 : exercisesTime))
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: 270))
                        .animation(.linear, value: exerciseCountdown)
                    
                    Text("\(exerciseCountdown)s")
                        .font(.largeTitle)
                        .bold()
                }
                .frame(width: 200, height: 200)
                .padding(.top, 20)
                
                Text("Time Remaining: \(exerciseCountdown)s")
                    .font(.title)
                    .onAppear {
                        startExerciseCountdown()
                    }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Run Circuit")
    }
    
    func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                timer.invalidate()
                isRunning = true
                exerciseCountdown = exercisesTime
            }
        }
    }
    
    func startExerciseCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if exerciseCountdown > 0 {
                exerciseCountdown -= 1
            } else {
                timer.invalidate()
                if isBufferActive {
                    isBufferActive = false
                    exerciseCountdown = exercisesTime
                    startExerciseCountdown()
                } else if currentExercise < exercisesAmount {
                    currentExercise += 1
                    if addBuffer {
                        isBufferActive = true
                        exerciseCountdown = 3
                    } else {
                        exerciseCountdown = exercisesTime
                    }
                    startExerciseCountdown()
                } else if currentCircuit < circuitAmount {
                    currentCircuit += 1
                    currentExercise = 1
                    if addBuffer {
                        isBufferActive = true
                        exerciseCountdown = 3
                    } else {
                        exerciseCountdown = exercisesTime
                    }
                    startExerciseCountdown()
                } else {
                    // Handle end of circuit
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    RunCircuitView(circuitAmount: 1, circuitRest: 15, roundsAmount: 1, roundsRest: 15, exercisesAmount: 1, exercisesTime: 15, exercisesRest: 15, addBuffer: true)
}