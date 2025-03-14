import SwiftUI

struct WorkoutTypeSelectionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Workout Type")
                .font(.largeTitle)
                .padding(.top, 20)
            
            NavigationLink(destination: CircuitView()) {
                Text("Circuit")
                    .frame(width: 200, height: 50)
                    .background(Theme.secondary)
                    .foregroundColor(Theme.buttonText)
                    .clipShape(Capsule())
            }
            
            NavigationLink(destination: HIITView()) {
                Text("HIIT")
                    .frame(width: 200, height: 50)
                    .background(Theme.primary)
                    .foregroundColor(Theme.buttonText)
                    .clipShape(Capsule())
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Workout Type")
        .background(Theme.background)
    }
}

#Preview {
    WorkoutTypeSelectionView()
}