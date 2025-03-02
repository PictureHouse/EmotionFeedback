import SwiftUI

struct TextButton: View {
    let title: String
    let accent: Bool
    let action: () -> Void
    
    var body: some View {
        if accent {
            Button(action: {
                action()
            }, label: {
                Text(title)
                    .font(.title3)
            })
            .buttonStyle(.borderedProminent)
            .foregroundStyle(Color(.white))
        } else {
            Button(action: {
                action()
            }, label: {
                Text(title)
                    .font(.title3)
            })
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    TextButton(title: "Save", accent: true, action: {})
}
