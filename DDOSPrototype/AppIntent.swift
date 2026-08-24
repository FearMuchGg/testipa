// AppIntent.swift
import AppIntents
import ActivityKit

struct TogglePauseIntent: AppIntent {
    static var title: LocalizedStringResource = "Приостановить/Возобновить"

    func perform() async throws -> some IntentResult {
        guard let activity = Activity<DDoSAttributes>.activities.first else {
            return .result()
        }
        let newState = DDoSAttributes.ContentState(
            targetIP: activity.contentState.targetIP,
            totalTime: activity.contentState.totalTime,
            rps: activity.contentState.rps,
            activeBots: activity.contentState.activeBots,
            isPaused: !activity.contentState.isPaused,
            isStopped: activity.contentState.isStopped
        )
        await activity.update(using: newState)
        return .result()
    }
}

struct StopAttackIntent: AppIntent {
    static var title: LocalizedStringResource = "Остановить атаку"

    func perform() async throws -> some IntentResult {
        guard let activity = Activity<DDoSAttributes>.activities.first else {
            return .result()
        }
        let newState = DDoSAttributes.ContentState(
            targetIP: activity.contentState.targetIP,
            totalTime: activity.contentState.totalTime,
            rps: activity.contentState.rps,
            activeBots: activity.contentState.activeBots,
            isPaused: false,
            isStopped: true
        )
        await activity.update(using: newState)
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await activity.end(using: newState, dismissalPolicy: .immediate)
        }
        return .result()
    }
}
