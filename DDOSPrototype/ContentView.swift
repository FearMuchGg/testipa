import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var isMenuOpen = false
    @State private var isLiveActivityEnabled = false
    @State private var activity: Activity<DDoSAttributes>? = nil
    @State private var timer: Timer? = nil
    @State private var totalTime = 180
    @State private var rps = 1500
    @State private var activeBots = 30
    @State private var isPaused = false
    @State private var isStopped = false

    var body: some View {
        ZStack(alignment: .leading) {
            DashboardView(isMenuOpen: $isMenuOpen)
                .offset(x: isMenuOpen ? 250 : 0)
                .scaleEffect(isMenuOpen ? 0.9 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isMenuOpen)

            SideMenuView(
                isMenuOpen: $isMenuOpen,
                isLiveActivityEnabled: $isLiveActivityEnabled,
                onToggle: toggleLiveActivity
            )
            .offset(x: isMenuOpen ? 0 : -300)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isMenuOpen)
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 80 { isMenuOpen = true }
                    else if gesture.translation.width < -80 { isMenuOpen = false }
                }
        )
        .onDisappear {
            timer?.invalidate()
            if let activity = activity {
                Task { await activity.end(dismissalPolicy: .immediate) }
            }
        }
    }

    private func toggleLiveActivity() {
        if isLiveActivityEnabled {
            startLiveActivity()
        } else {
            stopLiveActivity()
        }
    }

    private func startLiveActivity() {
        totalTime = 180
        rps = 1500
        activeBots = 30
        isPaused = false
        isStopped = false

        let attributes = DDoSAttributes(initialTime: 180, botCount: 30)
        let state = DDoSAttributes.ContentState(
            targetIP: "192.168.1.100",
            totalTime: totalTime,
            rps: rps,
            activeBots: activeBots,
            isPaused: false,
            isStopped: false
        )

        do {
            activity = try Activity.request(attributes: attributes, content: .init(state: state, staleDate: nil))
            print("✅ Live Activity запущена")
        } catch {
            print("❌ Ошибка запуска: \(error)")
            isLiveActivityEnabled = false
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateActivity()
        }
    }

    private func stopLiveActivity() {
        timer?.invalidate()
        timer = nil
        if let activity = activity {
            Task {
                let finalState = DDoSAttributes.ContentState(
                    targetIP: "192.168.1.100",
                    totalTime: 0,
                    rps: 0,
                    activeBots: 0,
                    isPaused: false,
                    isStopped: true
                )
                await activity.end(using: finalState, dismissalPolicy: .immediate)
                self.activity = nil
            }
        }
        isLiveActivityEnabled = false
    }

    private func updateActivity() {
        guard let activity = activity else { return }
        if !isPaused && !isStopped {
            totalTime -= 1
            if totalTime <= 0 {
                stopLiveActivity()
                return
            }
            rps = Int.random(in: 1200...2000)
            activeBots = Int.random(in: 25...30)
        }
        let newState = DDoSAttributes.ContentState(
            targetIP: "192.168.1.100",
            totalTime: totalTime,
            rps: rps,
            activeBots: activeBots,
            isPaused: isPaused,
            isStopped: isStopped
        )
        Task {
            await activity.update(using: newState)
        }
    }
}

// MARK: - Dashboard
struct DashboardView: View {
    @Binding var isMenuOpen: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        StatCard(title: "Всего ботов", value: "35", icon: "person.3.fill")
                        StatCard(title: "Онлайн", value: "30", icon: "wifi")
                    }
                    ServerStatusCard()
                    AttackButton()
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation { isMenuOpen.toggle() }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .background(
                LinearGradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.1, blue: 0.3)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
            )
        }
    }
}

// MARK: - Боковое меню
struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    @Binding var isLiveActivityEnabled: Bool
    let onToggle: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture { withAnimation { isMenuOpen = false } }

            VStack(alignment: .leading, spacing: 30) {
                Text("Управление")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.top, 50)

                Divider().background(Color.gray.opacity(0.3))

                HStack {
                    Image(systemName: "livephoto")
                        .foregroundColor(.blue)
                        .font(.title3)
                    Text("Dynamic Island")
                        .foregroundColor(.white)
                    Spacer()
                    Toggle("", isOn: $isLiveActivityEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .onChange(of: isLiveActivityEnabled) { _ in
                            onToggle()
                        }
                }
                .padding(.vertical, 8)

                Divider().background(Color.gray.opacity(0.3))

                if isLiveActivityEnabled {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(" Активна")
                            .foregroundColor(.green)
                        Text("Цель: 192.168.1.100")
                            .font(.caption)
                        Text("Осталось: 3:00")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                } else {
                    Text("Не активна")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .frame(width: 280, alignment: .leading)
            .background(
                LinearGradient(colors: [Color(red: 0.15, green: 0.15, blue: 0.25), Color(red: 0.25, green: 0.15, blue: 0.35)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }
}

// MARK: - StatCard
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 5)
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.white.opacity(0.8))
                Text(value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding()
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - ServerStatusCard
struct ServerStatusCard: View {
    @State private var isRunning = true
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 5)
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Статус сервера")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                    HStack(spacing: 8) {
                        Circle()
                            .fill(isRunning ? Color.green : Color.red)
                            .frame(width: 12, height: 12)
                            .shadow(color: isRunning ? .green.opacity(0.6) : .red.opacity(0.6), radius: 6)
                        Text(isRunning ? "run" : "stop")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                if isRunning {
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                        .frame(width: 40, height: 40)
                        .scaleEffect(1.0)
                        .opacity(0.8)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isRunning)
                }
            }
            .padding()
        }
        .frame(height: 80)
    }
}

// MARK: - AttackButton
struct AttackButton: View {
    @State private var isAnimating = false
    var body: some View {
        Button {
            isAnimating.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isAnimating.toggle()
            }
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.red, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .red.opacity(0.5), radius: 20, x: 0, y: 0)
                    .scaleEffect(isAnimating ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isAnimating)
                Image(systemName: "bolt.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.easeInOut(duration: 0.6), value: isAnimating)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
