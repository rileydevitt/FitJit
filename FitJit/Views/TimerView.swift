//
//  TimerView.swift
//  FitJit
//
//  Created by Riley Devitt on 2025-03-12.
//
import SwiftUI
import AVFoundation

struct TimerView: View {
    @State private var timeRemaining = 30  // Default 30 seconds per session
    @State private var isRunning = false
    @State private var timer: Timer?
    @State private var progress: CGFloat = 1.0
    
    var totalTime: Int = 30  // Set total workout time per session
    var soundPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Workout Timer")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1.0), value: progress)
                
                Text("\(timeRemaining)s")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(width: 200, height: 200)
            
            HStack(spacing: 30) {
                Button(action: startTimer) {
                    Text(isRunning ? "Pause" : "Start")
                        .font(.title)
                        .padding()
                        .frame(width: 120)
                        .background(isRunning ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                
                Button(action: resetTimer) {
                    Text("Reset")
                        .font(.title)
                        .padding()
                        .frame(width: 120)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
    }
    
    func startTimer() {
        if isRunning {
            isRunning = false
            timer?.invalidate()
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                    progress = CGFloat(timeRemaining) / CGFloat(totalTime)
                } else {
                    timer?.invalidate()
                    isRunning = false
                }
            }
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        isRunning = false
        timeRemaining = totalTime
        progress = 1.0
    }
    
    
}
