import SwiftUI

struct WorkoutLogsView: View {
    @State private var selectedDate = Date()
    @State private var workoutLogs: [Date: String] = [:]
    @State private var workoutDescription: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Workout Logs")
                .font(.largeTitle)
                .padding(.top, 20)
            
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            
            TextField("Workout Description", text: $workoutDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if !workoutDescription.isEmpty {
                    workoutLogs[selectedDate] = workoutDescription
                    workoutDescription = ""
                }
            }) {
                Text("Save Workout")
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 20)
            
            List {
                ForEach(workoutLogs.keys.sorted(), id: \.self) { date in
                    VStack(alignment: .leading) {
                        Text(date, style: .date)
                            .font(.headline)
                        Text(workoutLogs[date] ?? "")
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Workout Logs")
    }
}

#Preview {
    WorkoutLogsView()
}