import SwiftUI

struct InitGuideView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentTab: Int = 0
    
    @State private var userName: String = ""
    @FocusState private var nameFocused: Bool
    @State private var showBlankAlert = false
    
    var body: some View {
        TabView(selection: $currentTab, content: {
            VStack {
                Text("Welcome to Emotion Feedback!")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .font(.title)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding()
                
                Text("'Emotion Feedback' is an emotional self-diagnosis app for mental health.")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding()
                
                Text("This app will create and display a chart based on the last week's data based on the emotional questionnaire you enter every day and provide you with feedback.")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding()
                
                Text("It will help you reflect on your emotions and control them so that you can feel better.")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding()
                
                Text("Since your emotional data is for self-diagnosis only, it is stored locally on your device and only you can see it.")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding()
                
                Text("If you turn on notification settings, you can receive a 'Reminder' notification at a set time every day so you don't forget to fill out the emotional survey.")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding()
            }
            .foregroundStyle(Color(.orange))
            .tag(0)

            VStack {
                Text("What is your name?")
                    .padding()
                    .foregroundStyle(Color(.orange))
                    .font(.system(size: 30, weight: .black, design: .rounded))
                
                TextField(userName, text: $userName, prompt: Text("Input Your Name"))
                    .padding()
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .focused($nameFocused)
                    .submitLabel(.done)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 300, alignment: .center)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    if userName == "" {
                        showBlankAlert = true
                        nameFocused = true
                    } else {
                        UserData.shared.setUserName(name: userName)
                        dismiss()
                    }
                }, label: {
                    Text("Get Started!")
                        .font(.title3)
                })
                .buttonStyle(.borderedProminent)
                .padding()
                .foregroundStyle(Color(.white))
            }
            .tag(1)
        })
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .alert("Alert", isPresented: $showBlankAlert) {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Okay")
            })
        } message: {
            Text("Username textfield is blank!")
        }
        .sensoryFeedback(.error, trigger: showBlankAlert)
    }
}
