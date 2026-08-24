// ContentView.swift
import SwiftUI

struct ContentView: View {
    @State private var isMenuOpen = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            DashboardView(isMenuOpen: $isMenuOpen)
                .offset(x: isMenuOpen ? 240 : 0)
                .scaleEffect(isMenuOpen ? 0.9 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isMenuOpen)
            
            SideMenuView(isMenuOpen: $isMenuOpen)
                .offset(x: isMenuOpen ? 0 : -300)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isMenuOpen)
        }
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.width > 80 {
                        isMenuOpen = true
                    } else if gesture.translation.width < -80 {
                        isMenuOpen = false
                    }
                }
        )
    }
}

struct DashboardView: View {
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    HStack(spacing: 16) {
                        StatCard(title: "Всего ботов", value: "30", icon: "person.3.fill")
                        StatCard(title: "Онлайн", value: "35", icon: "wifi")
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
                        withAnimation {
                            isMenuOpen.toggle()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.1, blue: 0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
}

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
                            .shadow(color: isRunning ? .green : .red, radius: 6)
                        Text(isRunning ? "run" : "stop")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                Image(systemName: "server.rack")
                    .font(.largeTitle)
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding()
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
    }
}

struct AttackButton: View {
    @State private var isPulsing = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red.opacity(0.2))
                .frame(width: 160, height: 160)
                .scaleEffect(isPulsing ? 1.2 : 1.0)
                .opacity(isPulsing ? 0.0 : 0.8)
                .animation(
                    Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: false),
                    value: isPulsing
                )
            
            Button {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
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
                        .frame(width: 120, height: 120)
                        .shadow(color: .red.opacity(0.4), radius: 20, x: 0, y: 8)
                    
                    Image(systemName: "play.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.top, 10)
        .onAppear {
            isPulsing = true
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isMenuOpen = false
                    }
                }
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.8))
                    Text("Тестовый режим")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("v0.1")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.bottom, 20)
                
                Divider().background(Color.white.opacity(0.2))
                
                MenuItem(icon: "house.fill", title: "Главная")
                MenuItem(icon: "chart.pie.fill", title: "Статистика")
                MenuItem(icon: "gearshape.fill", title: "Настройки")
                MenuItem(icon: "questionmark.circle.fill", title: "Помощь")
                
                Spacer()
            }
            .padding(.top, 60)
            .padding(.horizontal, 28)
            .frame(width: 280, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.15, green: 0.1, blue: 0.25), Color(red: 0.05, green: 0.05, blue: 0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .offset(x: isMenuOpen ? 0 : -280)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isMenuOpen)
        }
    }
}

struct MenuItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 28)
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture { }
    }
}

#Preview {
    ContentView()
}
