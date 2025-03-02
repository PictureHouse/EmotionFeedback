import SwiftUI

struct SettingsView: View {
    @Environment(AppStateManager.self) private var appStateManager
    
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
            SheetHeader(title: "Settings") {
                if userName == UserData.shared.getUserName() {
                    dismiss()
                    edited = false
                } else {
                    showCancelAlert = true
                }
            }
            
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
                TextButton(title: "Save", accent: true) {
                    updateSettings()
                }
                
                TextButton(title: "Cancel", accent: false) {
                    cancel()
                }
            }
            .padding()
            
            Spacer()
            
            Text("[Version \(appStateManager.version)] 2024 Yune Cho")
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

private extension SettingsView {
    func updateSettings() {
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
            NotificationManager.shared.pushScheduledNotification(
                title: NotificationManager.shared.title,
                body: NotificationManager.shared.body,
                hour: hour!,
                minute: minute!,
                identifier: "customized_time"
            )
            showSaveAlert = true
            changed = true
            edited = false
        }
    }
    
    func cancel() {
        if userName == UserData.shared.getUserName() {
            dismiss()
            edited = false
        } else {
            showCancelAlert = true
        }
    }
}
