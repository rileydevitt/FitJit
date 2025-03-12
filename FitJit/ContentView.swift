//
//  ContentView.swift
//  FitJit
//
//  Created by Riley Devitt on 2025-03-12.
//
import SwiftUI

struct ContentView: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isRunning = false
    @State private var showingActionSheet = false
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Stopwatch Display
                Text(stopwatchDisplay())
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                
                HStack(spacing: 20) {
                    Button(action: startStopwatch) {
                        Text(isRunning ? "Pause" : "Start")
                            .frame(width: 120, height: 50)
                            .background(isRunning ? Color.orange : Color.green)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: resetStopwatch) {
                        Text("Reset")
                            .frame(width: 120, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                
                Divider()
                
                // Custom Workout Button
                Button(action: {
                    showingActionSheet = true
                }) {
                    Text("Custom Workout")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Choose Workout Type"), buttons: [
                        .default(Text("Circuit")) {
                            // Navigate to CircuitView
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: CircuitView())
                                window.makeKeyAndVisible()
                            }
                        },
                        .default(Text("HIIT")) {
                            // Handle HIIT selection
                        },
                        .cancel()
                    ])
                }
                
                Divider()
                
                // Preset Workouts Grid (2x2)
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    NavigationLink(destination: PresetTimersView(workoutName: "Sweaty Shredder")) {
                        WorkoutSquare(title: "Preset 1", color: .blue)
                    }
                    NavigationLink(destination: PresetTimersView(workoutName: "Toning Power")) {
                        WorkoutSquare(title: "Preset 2", color: .purple)
                    }
                    NavigationLink(destination: PresetTimersView(workoutName: "HIIT Blast")) {
                        WorkoutSquare(title: "Preset 3", color: .orange)
                    }
                    NavigationLink(destination: PresetTimersView(workoutName: "Strength Builder")) {
                        WorkoutSquare(title: "Preset 4", color: .green)
                    }
                }
                .padding()
            }
            .navigationTitle("FitJit")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: WorkoutLogsView()) {
                        Text("Workout Logs")
                    }
                }
            }
            //.padding()
        }
    }
    
    func stopwatchDisplay() -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    func startStopwatch() {
        if isRunning {
            isRunning = false
            timer?.invalidate()
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                elapsedTime += 0.01
            }
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    func resetStopwatch() {
        timer?.invalidate()
        elapsedTime = 0
        isRunning = false
    }
}

// Workout Preset Square Component
struct WorkoutSquare: View {
    var title: String
    var color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(color)
                .frame(height: 120)
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}

// Preset Timer View Placeholder
struct PresetTimersView: View {
    var workoutName: String
    
    var body: some View {
        Text("Workout: \(workoutName)")
            .font(.title)
            .padding()
    }
}

// Custom Workout View Placeholder
struct CustomWorkoutView: View {
    var body: some View {
        Text("Custom Workout")
            .font(.title)
            .padding()
    }
}

// Workout Logs View Placeholder
struct WorkoutLogsView: View {
    var body: some View {
        Text("Workout Logs")
            .font(.title)
            .padding()
    }
}

#Preview {
    ContentView()
}
