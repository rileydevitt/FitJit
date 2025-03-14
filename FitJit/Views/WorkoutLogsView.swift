import SwiftUI

struct WorkoutLogsView: View {
    @ObservedObject var logManager: WorkoutLogManager
    @State private var selectedDate = Date()
    @State private var exerciseName = ""
    @State private var sets = ""
    @State private var reps = ""
    @State private var weight = ""
    @State private var notes = ""
    @State private var showError = false
    @State private var isAddingExercise = false  // New state variable
    @State private var expandedDate: Date?  // Add this line
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    // Comment out the overlay
                    // .overlay(
                    //     CalendarDotOverlay(workoutLogs: logManager.workoutLogs)
                    // )
                
                // Expandable Add Exercise Section
                VStack {
                    Button(action: { withAnimation { isAddingExercise.toggle() }}) {
                        HStack {
                            Text(isAddingExercise ? "Hide Add Exercise" : "Add Exercise")
                                .foregroundColor(Theme.buttonText)
                            Image(systemName: isAddingExercise ? "chevron.up" : "chevron.down")
                                .foregroundColor(Theme.buttonText)
                        }
                        .frame(width: 200, height: 50)
                        .background(Theme.secondary)
                        .clipShape(Capsule())
                    }
                    
                    if isAddingExercise {
                        VStack(spacing: 15) {
                            TextField("Exercise Name", text: $exerciseName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                            HStack {
                                TextField("Sets", text: $sets)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                TextField("Reps", text: $reps)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                TextField("Weight (lbs)", text: $weight)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                if let setsInt = Int(sets),
                                   let repsInt = Int(reps),
                                   let weightInt = Int(weight),
                                   !exerciseName.isEmpty {
                                    addExercise(name: exerciseName, sets: setsInt, reps: repsInt, weight: weightInt)
                                    isAddingExercise = false  // Hide the section after adding
                                } else {
                                    showError = true
                                }
                            }) {
                                Text("Save Exercise")
                                    .frame(width: 200, height: 50)
                                    .background(!exerciseName.isEmpty ? Theme.secondary : Theme.secondary.opacity(0.3))
                                    .foregroundColor(Theme.buttonText)
                                    .clipShape(Capsule())
                            }
                            .disabled(exerciseName.isEmpty)
                        }
                        .padding()
                        .background(Theme.secondary.opacity(0.05))
                        .cornerRadius(10)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                // Display exercises for selected date
                let startOfDay = Calendar.current.startOfDay(for: selectedDate)
                if let log = logManager.workoutLogs[startOfDay] {
                    ForEach(log.exercises) { exercise in
                        ExerciseRow(exercise: exercise)
                    }
                } else {
                    Text("No exercises logged for this date")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .navigationTitle("Workout Logs")
        .navigationBarBackButtonHidden(false)  // Change this to false
        .background(Theme.background)
        .alert("Invalid Input", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please fill in all fields with valid numbers.")
        }
    }
    
    private func addExercise(name: String, sets: Int, reps: Int, weight: Int) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        
        let exercise = LoggedExercise(
            id: UUID(),
            name: name,
            sets: sets,
            reps: reps,
            weight: weight
        )
        
        var currentLog = logManager.workoutLogs[startOfDay] ?? WorkoutLog(
            exercises: [],
            notes: notes,
            duration: 0,
            date: startOfDay
        )
        
        currentLog.exercises.append(exercise)
        logManager.addLog(currentLog, for: startOfDay)
        
        // Reset input fields
        self.exerciseName = ""
        self.sets = ""
        self.reps = ""
        self.weight = ""
        
        // Automatically show the exercises after adding
        withAnimation {
            isAddingExercise = false
            expandedDate = startOfDay
        }
    }
}

/*
struct CalendarDotOverlay: View {
    let workoutLogs: [Date: WorkoutLog]
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(workoutLogs.keys), id: \.self) { date in
                Circle()
                    .fill(Color.blue)
                    .frame(width: 6, height: 6)
                    .position(
                        calculatePosition(
                            for: date,
                            in: geometry.size
                        )
                    )
            }
        }
    }
    
    private func calculatePosition(for date: Date, in size: CGSize) -> CGPoint {
        let calendar = Calendar.current
        
        // Calendar view starts on Sunday (0) and has 7 columns
        let weekday = calendar.component(.weekday, from: date) - 1
        let week = calendar.component(.weekOfMonth, from: date) - 1
        
        // Calculate x position (weekday) and y position (week)
        let cellWidth = size.width / 7
        let cellHeight = size.height / 6
        
        let x = cellWidth * CGFloat(weekday) + cellWidth / 2
        // Adjust y position to be below the number
        let y = cellHeight * CGFloat(week) + (cellHeight * 0.75) // Position dot at 75% of cell height
        
        return CGPoint(x: x, y: y)
    }
}
*/

struct ExerciseRow: View {
    let exercise: LoggedExercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                Text("\(exercise.sets) sets × \(exercise.reps) reps at \(exercise.weight)lbs")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Theme.secondary.opacity(0.05))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct DayLogView: View {
    let date: Date
    let log: WorkoutLog
    let isExpanded: Bool
    let onTap: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onTap) {
                HStack {
                    Text(dateFormatter.string(from: date))
                        .font(.headline)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding()
                .background(Theme.secondary.opacity(0.1))
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(log.exercises) { exercise in
                        HStack {
                            Text(exercise.name)
                                .font(.subheadline)
                            Spacer()
                            Text("\(exercise.sets)×\(exercise.reps) | \(exercise.weight)lbs")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                    }
                    
                    if !log.notes.isEmpty {
                        Text("Notes: \(log.notes)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Theme.secondary.opacity(0.05))
                .cornerRadius(10)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WorkoutLogsView(logManager: WorkoutLogManager())
}
