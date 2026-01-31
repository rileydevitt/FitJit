# FitJit – Personal Workout Tracker

**FitJit** is a native iOS fitness tracking application built in **Swift** using **Xcode**, designed to explore modern Apple frameworks, application architecture, and robust state management.  
The app allows users to securely log workouts, create customizable training circuits, and track detailed workout metrics — all while keeping data **fully local and offline-first** for privacy.

---

## Features

- **Secure User Authentication**
  - No cloud dependency — all data stored on-device

- **Workout Tracking**
  - Structured workout logging
  - Timers, stopwatches, and circuits
  - Detailed metric tracking per session

- **Customizable Workouts**
  - Preconfigured workout presets
  - User-defined circuits and routines
  - Flexible interval and repetition controls

- **Offline & Privacy-Focused**
  - 100% on-device data persistence
  - No external servers or analytics
  - Reliable offline usage

- **Thorough Testing**
  - Unit tests for core business logic
  - UI tests for navigation and user flows
  - Validation of state transitions and edge cases

---

## Tech Stack

- **Language:** Swift  
- **Platform:** iOS  
- **IDE:** Xcode  
- **Architecture:** Native Apple frameworks  
- **Storage:** Local on-device persistence  
- **Testing:** Unit & UI tests

---

## App Architecture

FitJit is structured to promote **maintainability, testability, and scalability**, with a strong separation between:

- UI presentation
- Application state and logic
- Persistence and data models

State transitions (e.g., workout start/stop, timers, logging) are carefully validated through automated tests to ensure correctness as features evolve.

---
