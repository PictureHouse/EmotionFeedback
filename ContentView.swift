import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    @State private var presentInitModal = false
    @State private var presentEmotionInputModal = false
    
    @State private var emotionData = UserData.shared.getEmotionData()
    @State private var analyzeResult = UserData.shared.analyzeEmotionData()
    @State private var changed = false
    @State private var scaling = false
    @State private var tapped = false
    @State private var phone = true
    
    private func refreshData() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        emotionData = UserData.shared.getEmotionData()
        analyzeResult = UserData.shared.analyzeEmotionData()
    }
    
    var body: some View {
        VStack {
            if launchedBefore == false {
                HeaderView()
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
                HeaderView()
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
                HeaderView()
            }
            
            ZStack {
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
                    
                Color(colorScheme == .dark ? .black : .white)
                    .opacity(changed ? 0.7 : 0)
                    .ignoresSafeArea()
                
                ScrollView {
                    Image(systemName: "")
                        .resizable()
                        .frame(height: 200)
                    
                    Image(systemName: "arrowshape.down.fill")
                        .resizable()
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                        .scaleEffect(scaling ? 1 : 0.8)
                        .onAppear {
                            withAnimation(.spring().repeatForever()) {
                                scaling.toggle()
                            }
                        }
                    
                    Text("Your emotion data has been updated.\nPull to refresh!")
                        .padding(.top)
                        .multilineTextAlignment(.center)
                }
                .foregroundStyle(Color(.orange))
                .opacity(changed ? 1 : 0)
                .refreshable {
                    await refreshData()
                    changed = false
                    tapped = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
