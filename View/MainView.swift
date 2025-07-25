import SwiftUI

struct MainView: View {
    @Environment(AppStateManager.self) private var appStateManager
    @Environment(NotificationManager.self) private var notificationManager
    @Environment(\.modelContext) private var modelContext
    
    @State private var emotionDataManager: EmotionDataManager?
    @State private var showMainView = false
    @State private var presentInitModal = false
    @State private var presentEmotionInputModal = false
    @State private var emotionData: [EmotionData] = []
    @State private var analyzeResult: [Int] = []
    @State private var changed = false
    @State private var tapped = false
    @State private var phone = true
    @State private var migrationStatus: Bool = false
    @State private var migrationCompleted: Bool = false
    
    var body: some View {
        if showMainView {
            VStack {
                MainViewHeader(changed: $changed)
                    .onAppear(perform: {
                        if appStateManager.launchedBefore == false {
                            presentInitModal = true
                        }
                    })
                    .fullScreenCover(isPresented: $presentInitModal, content: {
                        InitGuideView()
                            .onDisappear(perform: {
                                UserDefaults.standard.set(true, forKey: "launchedBefore")
                                notificationManager.setAuthorization()
                                notificationManager.pushScheduledNotification(
                                    title: notificationManager.title,
                                    body: notificationManager.body,
                                    hour: 22,
                                    minute: 0,
                                    identifier: "default_time"
                                )
                                presentEmotionInputModal = true
                            })
                    })
                    .fullScreenCover(isPresented: $presentEmotionInputModal, content: {
                        EmotionInputView(changed: $changed)
                            .onDisappear(perform: {
                                presentEmotionInputModal = false
                                if changed == true {
                                    tapped = false
                                }
                            })
                    })
                
                if migrationStatus {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        GeometryReader { geometry in
                            if geometry.size.height > geometry.size.width {
                                iPadVerticalView
                            } else {
                                iPadHorizontalView
                            }
                        }
                    } else {
                        iPhoneView
                    }
                } else {
                    migrationView
                }
            }
            .onAppear(perform: {
                if let emotionDataManager = emotionDataManager {
                    emotionData = emotionDataManager.fetchEmotionData()
                    analyzeResult = emotionDataManager.analyzeEmotionData()
                }
            })
            .onChange(of: changed) {
                if let emotionDataManager = emotionDataManager {
                    emotionData = emotionDataManager.fetchEmotionData()
                    analyzeResult = emotionDataManager.analyzeEmotionData()
                }
                changed = false
                tapped = false
            }
        } else {
            SplashView()
                .onAppear {
                    emotionDataManager = EmotionDataManager(modelContext: modelContext)
                    if let emotionDataManager = emotionDataManager {
                        UserData.shared.migrated = emotionDataManager.checkMigrationStatus()
                        migrationStatus = UserData.shared.migrated
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showMainView = true
                        }
                    }
                }
        }
    }
}

private extension MainView {
    var iPhoneView: some View {
        VStack {
            Section {
                ChartView(data: emotionData)
            } header: {
                SectionHeader(title: "Emotion Chart", icon: "chart.xyaxis.line", changed: $changed, phone: $phone)
            }
            
            Section {
                FeedbackView(result: analyzeResult, tapped: $tapped)
            } header: {
                SectionHeader(title: "Feedback Message", icon: tapped ? "checkmark.message" : "ellipsis.message", changed: $changed, phone: $phone)
            }
            
            Spacer()
        }
    }
    
    var iPadVerticalView: some View {
        VStack {
            Section {
                ChartView(data: emotionData)
            } header: {
                SectionHeader(title: "Emotion Chart", icon: "chart.xyaxis.line", changed: $changed, phone: $phone)
            }
            
            Button {
                presentEmotionInputModal = true
            } label: {
                Label("Input Emotion", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $presentEmotionInputModal, content: {
                EmotionInputView(changed: $changed)
            })
            .padding()
            
            Section {
                FeedbackView(result: analyzeResult, tapped: $tapped)
            } header: {
                SectionHeader(title: "Feedback Message", icon: tapped ? "checkmark.message" : "ellipsis.message", changed: $changed, phone: $phone)
            }
            
            Spacer()
        }
        .onAppear(perform: {
            tapped = false
            phone = false
        })
    }
    
    var iPadHorizontalView: some View {
        HStack {
            VStack {
                Section {
                    ChartView(data: emotionData)
                } header: {
                    SectionHeader(title: "Emotion Chart", icon: "chart.xyaxis.line", changed: $changed, phone: $phone)
                }
                
                Button {
                    presentEmotionInputModal = true
                } label: {
                    Label("Input Emotion", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $presentEmotionInputModal,content: {
                    EmotionInputView(changed: $changed)
                })
                .padding()
                
                Spacer()
            }
            
            VStack {
                Section {
                    Spacer()
                    FeedbackView(result: analyzeResult, tapped: $tapped)
                } header: {
                    SectionHeader(title: "Feedback Message", icon: tapped ? "checkmark.message" : "ellipsis.message", changed: $changed, phone: $phone)
                }
                
                Spacer()
            }
        }
        .onAppear(perform: {
            tapped = false
            phone = false
        })
    }
    
    var migrationView: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            
            Label(
                migrationCompleted ? "Migration Complete" : "Migration Alert",
                systemImage: migrationCompleted ? "checkmark.circle" : "exclamationmark.circle"
            )
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(Color.orange)
            
            Text(migrationCompleted ? "The migration is complete.\nLet's go back to Emotion Feedback!" : "The way data is stored has been updated.\nData migration is required.")
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
            
            TextButton(title: migrationCompleted ? "Finish" : "Migrate", accent: true) {
                if migrationCompleted {
                    UserData.shared.migrated = true
                    migrationStatus = UserData.shared.migrated
                } else {
                    if let emotionDataManager = emotionDataManager {
                        emotionDataManager.migrateFromUserData()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            migrationCompleted = true
                        }
                    }
                }
            }
            
            Spacer()
        }
        .sensoryFeedback(.success, trigger: migrationCompleted)
    }
}

#Preview {
    MainView()
        .environment(AppStateManager())
        .environment(NotificationManager())
}
