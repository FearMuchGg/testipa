// DDoSLiveActivityWidget.swift
import WidgetKit
import SwiftUI
import ActivityKit

@main
struct DDoSLiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        DDoSLiveActivityWidget()
    }
}

struct DDoSLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DDoSAttributes.self) { context in
            VStack {
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.red)
                    Text("⚡ Атака")
                        .font(.headline)
                    Spacer()
                    Text("\(context.state.totalTime)s")
                        .font(.headline.monospacedDigit())
                    if context.state.isPaused {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.horizontal)

                HStack {
                    Text("Цель: \(context.state.targetIP)")
                    Spacer()
                    Text("RPS: \(context.state.rps)")
                        .font(.caption)
                }
                .padding(.horizontal)
                .font(.caption)

                if #available(iOS 17.0, *) {
                    HStack {
                        Button(intent: TogglePauseIntent()) {
                            Label(context.state.isPaused ? "Возобновить" : "Пауза",
                                  systemImage: context.state.isPaused ? "play.fill" : "pause.fill")
                        }
                        .buttonStyle(.bordered)
                        .tint(.yellow)

                        Button(intent: StopAttackIntent()) {
                            Label("Стоп", systemImage: "stop.fill")
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                    .padding(.bottom, 4)
                }
            }
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.red)
                        Text("\(context.state.rps)")
                            .font(.title2.bold())
                        Text("RPS")
                            .font(.caption)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("\(context.state.totalTime)s")
                            .font(.title2.monospacedDigit())
                        Text("осталось")
                            .font(.caption2)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text("Цель: \(context.state.targetIP)")
                        Spacer()
                        Text("Боты: \(context.state.activeBots)/\(context.attributes.botCount)")
                    }
                    .font(.caption)

                    if #available(iOS 17.0, *) {
                        HStack(spacing: 12) {
                            Button(intent: TogglePauseIntent()) {
                                Image(systemName: context.state.isPaused ? "play.circle.fill" : "pause.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.yellow)
                            }
                            .buttonStyle(.plain)

                            Button(intent: StopAttackIntent()) {
                                Image(systemName: "stop.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            } compactLeading: {
                Image(systemName: "bolt.fill")
                    .foregroundColor(.red)
            } compactTrailing: {
                Text("\(context.state.totalTime)s")
                    .font(.caption.monospacedDigit())
            } minimal: {
                Image(systemName: context.state.isPaused ? "pause.fill" : "bolt.fill")
                    .foregroundColor(context.state.isPaused ? .yellow : .red)
            }
        }
    }
}
