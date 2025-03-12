//
//  Item.swift
//  FitJit
//
//  Created by Riley Devitt on 2025-03-12.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
