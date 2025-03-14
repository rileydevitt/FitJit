import SwiftUI

struct RunCircuitView: View {
    let circuitAmount: Int
    let circuitRest: Int
    let roundsAmount: Int
    let roundsRest: Int
    let exercisesAmount: Int
    let exercisesTime: Int
    let exercisesRest: Int
    let addBuffer: Bool
    
    @State private var currentCircuit = 1
    @State private var currentRound = 1
    @State private var currentExercise = 1
    @State private var timeRemaining: Int = 0
    @State private var isResting = false
    @State private var timer: Timer?
    @State private var isRunning = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(timeString(from: timeRemaining))
                .font(.system(size: 72, weight: .bold, design: .monospaced))
                .foregroundColor(Theme.text)
            
            Text(statusText)
                .font(.title2)
                .foregroundColor(Theme.text)
            
            HStack(spacing: 30) {
                Button(action: toggleTimer) {
                    Text(isRunning ? "Pause" : "Start")
                        .frame(width: 120, height: 50)
                        .background(isRunning ? Theme.primary : Theme.secondary)
                        .foregroundColor(Theme.buttonText)
                        .clipShape(Capsule())
                }
                
                Button(action: resetTimer) {
                    Text("Reset")
                        .frame(width: 120, height: 50)
                        .background(Theme.secondary)
                        .foregroundColor(Theme.buttonText)
                        .clipShape(Capsule())
                }
            }
            
            ProgressView(value: Double(currentProgress), total: Double(totalProgress))
                .padding()
        }
        .padding()
        .navigationTitle("Circuit Workout")
        .background(Theme.background)
        .onAppear(perform: setup)
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private var statusText: String {
        if isResting {
            return "Rest"
        } else {
            return "Circuit \(currentCircuit)/\(circuitAmount) • Round \(currentRound)/\(roundsAmount) • Exercise \(currentExercise)/\(exercisesAmount)"
        }
    }
    
    private var currentProgress: Int {
        ((currentCircuit - 1) * roundsAmount * exercisesAmount) +
        ((currentRound - 1) * exercisesAmount) +
        currentExercise
    }
    
    private var totalProgress: Int {
        circuitAmount * roundsAmount * exercisesAmount
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func setup() {
        timeRemaining = exercisesTime
    }
    
    private func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            startTimer()
        } else {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                handleTimerComplete()
            }
        }
    }
    
    private func resetTimer() {
        timer?.invalidate()
        isRunning = false
        currentCircuit = 1
        currentRound = 1
        currentExercise = 1
        isResting = false
        timeRemaining = exercisesTime
    }
    
    private func handleTimerComplete() {
        if isResting {
            isResting = false
            timeRemaining = exercisesTime
            moveToNextExercise()
        } else {
            if addBuffer && currentExercise < exercisesAmount {
                timeRemaining = 3 // Buffer time
            } else {
                isResting = true
                timeRemaining = exercisesRest
            }
        }
    }
    
    private func moveToNextExercise() {
        if currentExercise < exercisesAmount {
            currentExercise += 1
        } else if currentRound < roundsAmount {
            currentExercise = 1
            currentRound += 1
            timeRemaining = roundsRest
        } else if currentCircuit < circuitAmount {
            currentExercise = 1
            currentRound = 1
            currentCircuit += 1
            timeRemaining = circuitRest
        } else {
            timer?.invalidate()
            isRunning = false
        }
    }
}

#Preview {
    RunCircuitView(
        circuitAmount: 3,
        circuitRest: 60,
        roundsAmount: 3,
        roundsRest: 30,
        exercisesAmount: 4,
        exercisesTime: 45,
        exercisesRest: 15,
        addBuffer: true
    )
}