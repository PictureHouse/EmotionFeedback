import SwiftUI

struct GuideView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State private var scaling = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Emotion Feedback Guide")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                })
            }
            .padding()
            .foregroundStyle(Color(.orange))
            
            ScrollView {
                HStack {
                    VStack {
                        Text("Emotion Feedback\nMain Screen")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(Color(.orange))
                            .multilineTextAlignment(.center)
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Text("You can see all of the app's items on the main screen.\nBelow are the main screen icons.\n\n\(Image(systemName: "info.bubble")) : Guide Screen\n\(Image(systemName: "gearshape")) : Settings\n\(Image(systemName: "chart.xyaxis.line")) : Chart Area\n\(Image(systemName: "plus")) : Input Emotion\n\(Image(systemName: "ellipsis.message")) : Feedback\n\t  Message Area")
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .padding(.bottom)
                        Spacer()
                    }
                    Spacer()
                    
                    Image(colorScheme == .dark ? "main_dark" : "main_light")
                        .resizable()
                        .frame(width: 180, height: 390)
                        .padding(.trailing)
                }
                
                Divider()
                    .padding()
                
                HStack {
                    Image(colorScheme == .dark ? "input_dark" : "input_light")
                        .resizable()
                        .frame(width: 180, height: 390)
                        .padding(.leading)
                    Spacer()
                    
                    VStack {
                        Text("Emotion Input Screen")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(Color(.orange))
                            .multilineTextAlignment(.center)
                            .padding(.trailing)
                            .padding(.bottom)
                        
                        Text("Step 0.\nSelect the date to enter.\nYou can also add past data.\n\nStep 1 ~ 5.\nEnter your answer to the question by adjusting the slider value.")
                            .multilineTextAlignment(.leading)
                            .padding(.trailing)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                }
                
                Divider()
                    .padding()
                
                HStack {
                    VStack {
                        Text("Refresh after Emotion Input")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(Color(.orange))
                            .multilineTextAlignment(.center)
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Text("To view the newly changed chart and feedback message according to the emotional data you entered, you must refresh the screen by following the instructions on the screen.")
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                    
                    Image(colorScheme == .dark ? "refresh_dark" : "refresh_light")
                        .resizable()
                        .frame(width: 180, height: 390)
                        .padding(.trailing)
                }
                
                Divider()
                    .padding()
                
                HStack {
                    Image(colorScheme == .dark ? "chart_dark" : "chart_light")
                        .resizable()
                        .frame(width: 180, height: 390)
                        .padding(.leading)
                    Spacer()
                    
                    VStack {
                        Text("Emotion Chart Area")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(Color(.orange))
                            .multilineTextAlignment(.center)
                            .padding(.trailing)
                            .padding(.bottom)
                        
                        Text("Among the emotional data you entered, you can view a chart corresponding to the last 7 days.")
                            .multilineTextAlignment(.leading)
                            .padding(.trailing)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                }
                
                Divider()
                    .padding()
                
                HStack {
                    VStack {
                        Text("Feedback Message Area")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(Color(.orange))
                            .multilineTextAlignment(.center)
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Text("If you follow the instructions below the speech bubble with the '...' mark and touch the speech bubble, the '...' mark in the speech bubble will change to a check mark and a feedback message about your chart will appear on the screen.")
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                    
                    Image(colorScheme == .dark ? "feedback_dark" : "feedback_light")
                        .resizable()
                        .frame(width: 180, height: 390)
                        .padding(.trailing)
                }
                
                Divider()
                    .padding()
                
                HStack {
                    Image(colorScheme == .dark ? "settings_dark" : "settings_light")
                        .resizable()
                        .frame(width: 180, height: 390)
                        .padding(.leading)
                    Spacer()
                    
                    VStack {
                        Text("Settings")
                            .font(.system(size: 17, weight: .black, design: .rounded))
                            .foregroundStyle(Color(.orange))
                            .multilineTextAlignment(.center)
                            .padding(.trailing)
                            .padding(.bottom)
                        
                        Text("You can change 'User Name' and 'Push Message Time'.\n(Default push message time is 10PM.)")
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            .padding(.trailing)
                            .padding(.bottom)
                        
                        Spacer()
                    }
                }
                
                Divider()
                    .padding()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Got It!")
                        .font(.title3)
                })
                .buttonStyle(.borderedProminent)
                .padding()
                .foregroundStyle(Color(.white))
                .scaleEffect(scaling ? 1 : 0.9)
                .onAppear {
                    withAnimation(.spring().repeatForever()) {
                        scaling.toggle()
                    }
                }
                
                Spacer()
            }
        }
        .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
    }
}
