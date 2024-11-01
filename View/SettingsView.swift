import SwiftUI

struct SettingsView: View {
    let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @Binding var edited: Bool
    @Binding var changed: Bool
    
    @State private var userName: String = UserData.shared.getUserName()
    @State private var pushMessageTime: Date = UserData.shared.getPushMessageTime()
    @FocusState private var nameFocused: Bool
    
    @State private var showSaveAlert = false
    @State private var showBlankAlert = false
    @State private var showCancelAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Settings")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                Spacer()
                
                Button(action: {
                    if userName == UserData.shared.getUserName() {
                        dismiss()
                        edited = false
                    } else {
                        showCancelAlert = true
                    }
                }, label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 28, height: 28)
                })
            }
            .padding()
            .foregroundStyle(Color(.orange))
            
            VStack {
                HStack {
                    Label("User Name", systemImage: "person.fill")
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading)
                
                TextField(userName, text: $userName, prompt: Text(userName))
                    .padding()
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($nameFocused)
                    .submitLabel(.done)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: userName) {
                        if userName != UserData.shared.getUserName() {
                            edited = true
                        }
                    }
            }
            
            VStack {
                HStack {
                    Label("Push Message Time", systemImage: "message.badge")
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading)
                
                DatePicker("Select Push Message Time", selection: $pushMessageTime, displayedComponents: .hourAndMinute)
                    .padding()
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .onChange(of: pushMessageTime) {
                        if pushMessageTime != UserData.shared.getPushMessageTime() {
                            edited = true
                        }
                    }
            }
            
            HStack {
                Button(action: {
                    if userName == "" {
                        showBlankAlert = true
                        nameFocused = true
                    } else {
                        UserData.shared.setUserName(name: userName)
                        
                        let formatter_hour = DateFormatter()
                        formatter_hour.dateFormat = "HH"
                        let hour_string = formatter_hour.string(from: pushMessageTime)
                        let hour = Int(hour_string)
                        
                        let formatter_minute = DateFormatter()
                        formatter_minute.dateFormat = "mm"
                        let minute_string = formatter_minute.string(from: pushMessageTime)
                        let minute = Int(minute_string)
                        
                        UserData.shared.setPushMessageTime(time: pushMessageTime)
                        LocalNotificationHelper.shared.pushScheduledNotification(title: LocalNotificationHelper.shared.title, body: LocalNotificationHelper.shared.body, hour: hour!, minute: minute!, identifier: "customized_time")
                        showSaveAlert = true
                        changed = true
                        edited = false
                    }
                }, label: {
                    Text("Save")
                        .font(.title3)
                })
                .buttonStyle(.borderedProminent)
                .foregroundStyle(Color(.white))
                
                Button(action: {
                    if userName == UserData.shared.getUserName() {
                        dismiss()
                        edited = false
                    } else {
                        showCancelAlert = true
                    }
                }, label: {
                    Text("Cancel")
                        .font(.title3)
                })
                .buttonStyle(.bordered)
            }
            .padding()
            
            Spacer()
            
            Text("[Version \(version)] 2024 Yune Cho")
                .foregroundStyle(Color(.lightGray))
                .padding(.bottom)
        }
        .foregroundStyle(Color(colorScheme == .dark ? .white : .black))
        .alert("Save Success", isPresented: $showSaveAlert) {
            Button(action: {
                dismiss()
            }, label: {
                Text("Okay")
            })
        } message: {
            Text("Saved successfully!")
        }
        .sensoryFeedback(.success, trigger: showSaveAlert)
        .alert("Alert", isPresented: $showBlankAlert) {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Okay")
            })
        } message: {
            Text("Username textfield is blank!")
        }
        .sensoryFeedback(.error, trigger: showBlankAlert)
        .alert("Alert", isPresented: $showCancelAlert) {
            Button(role: .cancel) {
                nameFocused = true
            } label: {
                Text("Cancel")
            }
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Okay")
            })
        } message: {
            Text("If you exit, all the data will be deleted.")
        }
        .sensoryFeedback(.warning, trigger: showCancelAlert)
    }
}
