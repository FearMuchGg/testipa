// ContentView.swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Верхние показатели
                    HStack(spacing: 16) {
                        StatCard(title: "Всего ботов", value: "35", icon: "person.3.fill")
                        StatCard(title: "Онлайн", value: "30", icon: "wifi")
                    }
                    
                    // Статус сервера
                    ServerStatusCard()
                    
                    // Кнопка атаки (без текста)
                    AttackButton()
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Кнопка-заглушка (три полоски) — без функционала
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                        .foregroundColor(.primary)
                        // можно добавить .onTapGesture { } если нужно, но оставим просто как декорацию
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

// MARK: - Карточка статистики
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

// MARK: - Карточка статуса сервера
struct ServerStatusCard: View {
    @State private var isRunning = true // для демонстрации можно переключать
    
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
                // Небольшой индикатор пульсации для эффекта
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

// MARK: - Кнопка запуска атаки (без подписи)
struct AttackButton: View {
    @State private var isAnimating = false
    
    var body: some View {
        Button {
            // Заглушка: просто вибрация или анимация
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
