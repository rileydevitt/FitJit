import Foundation

class WorkoutLogManager: ObservableObject {
    @Published var workoutLogs: [Date: WorkoutLog] = [:]
    private let logsKey = "savedWorkoutLogs"
    
    init() {
        loadLogs()
    }
    
    func addLog(_ log: WorkoutLog, for date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        workoutLogs[startOfDay] = log
        saveLogs()
        objectWillChange.send()
    }
    
    func deleteLog(for date: Date) {
        workoutLogs.removeValue(forKey: date)
        saveLogs()
    }
    
    private func saveLogs() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(workoutLogs)
            UserDefaults.standard.set(data, forKey: logsKey)
        } catch {
            print("Error saving logs: \(error)")
        }
    }
    
    private func loadLogs() {
        guard let data = UserDefaults.standard.data(forKey: logsKey) else { return }
        do {
            let decoder = JSONDecoder()
            workoutLogs = try decoder.decode([Date: WorkoutLog].self, from: data)
        } catch {
            print("Error loading logs: \(error)")
        }
    }
}