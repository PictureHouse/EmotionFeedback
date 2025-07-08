import SwiftUI

struct SheetHeader: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 22, weight: .black, design: .rounded))
            
            Spacer()
            
            Button(action: {
                action()
            }, label: {
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 28, height: 28)
            })
        }
        .padding()
        .foregroundStyle(Color.orange)
    }
}

#Preview {
    SheetHeader(title: "Preview", action: {})
}
