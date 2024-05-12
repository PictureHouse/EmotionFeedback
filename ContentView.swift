import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showMainView = false
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
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
                if launchedBefore == false {
                    HeaderView(changed: $changed)
                        .onAppear(perform: {
                            presentInitModal = true
                        })
                        .fullScreenCover(isPresented: $presentInitModal, content: {
                            InitGuideView()
                                .onDisappear(perform: {
                                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                                    LocalNotificationHelper.shared.setAuthorization()
                                    LocalNotificationHelper.shared.pushScheduledNotification(title: LocalNotificationHelper.shared.title, body: LocalNotificationHelper.shared.body, hour: 22, minute: 0, identifier: "default_time")
                                    presentEmotionInputModal = true
                                })
                        })
                        .sheet(isPresented: $presentEmotionInputModal, content: {
                            EmotionInputView(changed: $changed)
                                .onDisappear(perform: {
                                    presentEmotionInputModal = false
                                    if changed == true {
                                        tapped = false
                                    }
                                })
                        })
                } else if presentEmotionInputModal == true {
                    HeaderView(changed: $changed)
                        .sheet(isPresented: $presentEmotionInputModal, content: {
                            EmotionInputView(changed: $changed)
                                .onDisappear(perform: {
                                    presentEmotionInputModal = false
                                    if changed == true {
                                        tapped = false
                                    }
                                })
                        })
                } else {
                    HeaderView(changed: $changed)
                }
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    GeometryReader { geometry in
                        if geometry.size.height > geometry.size.width {
                            VStack {
                                Section {
                                    ChartView(data: emotionData)
                                } header: {
                                    SectionHeaderView(title: "Emotion Chart", icon: "chart.xyaxis.line", changed: $changed, phone: $phone)
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
                                    SectionHeaderView(title: "Feedback Message", icon: tapped ? "checkmark.message" : "ellipsis.message", changed: $changed, phone: $phone)
                                }
                                
                                Spacer()
                            }
                            .onAppear(perform: {
                                tapped = false
                                phone = false
                            })
                        } else {
                            HStack {
                                VStack {
                                    Section {
                                        ChartView(data: emotionData)
                                    } header: {
                                        SectionHeaderView(title: "Emotion Chart", icon: "chart.xyaxis.line", changed: $changed, phone: $phone)
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
                                        SectionHeaderView(title: "Feedback Message", icon: tapped ? "checkmark.message" : "ellipsis.message", changed: $changed, phone: $phone)
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
                } else {
                    VStack {
                        Section {
                            ChartView(data: emotionData)
                        } header: {
                            SectionHeaderView(title: "Emotion Chart", icon: "chart.xyaxis.line", changed: $changed, phone: $phone)
                        }
                        
                        Section {
                            FeedbackView(result: analyzeResult, tapped: $tapped)
                        } header: {
                            SectionHeaderView(title: "Feedback Message", icon: tapped ? "checkmark.message" : "ellipsis.message", changed: $changed, phone: $phone)
                        }
                        
                        Spacer()
                    }
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

#Preview {
    ContentView()
}
