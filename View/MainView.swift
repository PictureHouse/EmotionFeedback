import SwiftUI

struct MainView: View {
    @Environment(AppStateManager.self) private var appStateManager
    @Environment(NotificationManager.self) private var notificationManager
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showMainView = false
    @State private var presentInitModal = false
    @State private var presentEmotionInputModal = false
    
    @State private var emotionData = UserData.shared.getEmotionData()
    @State private var analyzeResult = UserData.shared.analyzeEmotionData()
    @State private var changed = false
    @State private var tapped = false
    @State private var phone = true
    
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
            }
            .onChange(of: changed) {
                emotionData = UserData.shared.getEmotionData()
                analyzeResult = UserData.shared.analyzeEmotionData()
                changed = false
                tapped = false
            }
        } else {
            SplashView()
                .onAppear {
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
            
            Button(action: {
                presentEmotionInputModal = true
            }, label: {
                Label("Input Emotion", systemImage: "plus")
            })
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
                
                Button(action: {
                    presentEmotionInputModal = true
                }, label: {
                    Label("Input Emotion", systemImage: "plus")
                })
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
}

#Preview {
    MainView()
        .environment(AppStateManager())
        .environment(NotificationManager())
}
