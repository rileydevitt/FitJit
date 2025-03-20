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
    @StateObject private var presetManager = PresetManager()
    @StateObject private var workoutLogManager = WorkoutLogManager()
    @State private var showingAddPreset = false
    @State private var presetToDelete: Preset? = nil  // Changed from PresetWorkout to Presetanged from PresetWorkout to Preset
    @State private var showingDeleteAlert = false
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Stopwatch Display
                Text(stopwatchDisplay())
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .padding(.top, 10)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: startStopwatch) {
                        Text(isRunning ? "Pause" : "Start")
                            .frame(width: 120, height: 50)
                            .background(isRunning ? Theme.primary : Theme.secondary)
                            .foregroundColor(Theme.buttonText)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: resetStopwatch) {
                        Text("Reset")
                            .frame(width: 120, height: 50)
                            .background(Theme.secondary)
                            .foregroundColor(Theme.buttonText)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .background(Theme.divider)
                    .padding(.horizontal)
                
                // Navigation Buttons Side by Side
                HStack(spacing: 20) {
                    NavigationLink(destination: WorkoutTypeSelectionView()) {
                        Text("Custom")
                            .frame(width: 160, height: 50)
                            .background(Theme.secondary)
                            .foregroundColor(Theme.buttonText)
                            .clipShape(Capsule())
                    }
                    
                    NavigationLink(destination: WorkoutLogsView(logManager: workoutLogManager)) {
                        Text("Logs")
                            .frame(width: 160, height: 50)
                            .background(Theme.secondary)
                            .foregroundColor(Theme.buttonText)
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .background(Theme.divider)
                    .padding(.horizontal)
                
                // Preset Workouts Vertical Scroll
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(presetManager.presets) { preset in
                            NavigationLink(destination: PresetTimersView(workoutName: preset.name)) {
                                WorkoutSquare(
                                    title: preset.name,
                                    color: preset.color == 0 ? Theme.primary : Theme.secondary,
                                    isEditing: isEditing,
                                    onDelete: {
                                        presetToDelete = preset
                                        showingDeleteAlert = true
                                    }
                                )
                                .padding(.horizontal, 8)
                            }
                            .disabled(isEditing)
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            withAnimation {
                                isEditing.toggle()
                            }
                        }
                        .alert("Delete Preset?", isPresented: $showingDeleteAlert, presenting: presetToDelete) { preset in
                            Button("Delete", role: .destructive) {
                                if let index = presetManager.presets.firstIndex(where: { $0.id == preset.id }) {
                                    presetManager.presets.remove(at: index)
                                }
                            }
                            Button("Cancel", role: .cancel) { }
                        } message: { preset in
                            Text("Are you sure you want to delete '\(preset.name)'?")
                        }
                        
                        Button(action: { showingAddPreset = true }) {
                            WorkoutSquare(title: "Add Preset", color: Theme.accent, isEditing: false, onDelete: nil)
                                .padding(.horizontal, 8)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("FitJit")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Theme.text)
                        .padding(.vertical, 20)
                        .padding(.top, 40)  // Adjust top padding for Dynamic Island
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 10)  // Reduced top space
            }
            .background(Theme.background)
            .preferredColorScheme(.light)
            .sheet(isPresented: $showingAddPreset) {
                AddPresetView(presetManager: presetManager)
            }
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
    var isEditing: Bool
    var onDelete: (() -> Void)?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(color)
                .frame(height: 120)
            
            // Delete button
            if isEditing {
                Button(action: { onDelete?() }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.white, .red)
                }
                .offset(x: -8, y: -8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .modifier(JiggleModifier(isJiggling: isEditing))
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
        Text("Custom")
            .font(.title)
            .padding()
    }
}

// HIIT View Placeholder
struct HIITView: View {
    var body: some View {
        Text("HIIT Workout")
            .font(.title)
            .padding()
    }
}

#Preview {
    ContentView()
}
