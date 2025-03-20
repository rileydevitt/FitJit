import SwiftUI

struct PresetListView: View {
    @ObservedObject var presetManager: PresetManager
    @Environment(\.dismiss) var dismiss
    @State private var showAddPreset = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(presetManager.presets) { preset in
                    NavigationLink(destination: RunCircuitView(
                        circuitAmount: preset.exercises[0].sets,
                        circuitRest: preset.exercises[0].rest,
                        roundsAmount: 1,
                        roundsRest: 30,
                        exercisesAmount: 1,
                        exercisesTime: preset.exercises[0].duration,
                        exercisesRest: 15,
                        addBuffer: true
                    )) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(preset.name)
                                    .font(.headline)
                                Text("\(preset.exercises[0].duration)s • \(preset.exercises[0].sets) circuits")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .onDelete(perform: deletePresets)
            }
            .navigationTitle("Presets")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.accent)
                    }
                }
            }
            .background(Theme.background)
        }
    }
    
    private func deletePresets(at offsets: IndexSet) {
        offsets.forEach { index in
            presetManager.deletePreset(at: index)
        }
    }
}

#Preview {
    PresetListView(presetManager: PresetManager())
}