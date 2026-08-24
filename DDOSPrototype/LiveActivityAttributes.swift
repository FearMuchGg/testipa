// LiveActivityAttributes.swift
import ActivityKit
import Foundation

struct DDoSAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var targetIP: String
        var totalTime: Int
        var rps: Int
        var activeBots: Int
        var isPaused: Bool
        var isStopped: Bool
    }

    var initialTime: Int
    var botCount: Int
}
