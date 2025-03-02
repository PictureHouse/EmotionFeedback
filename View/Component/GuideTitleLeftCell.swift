import SwiftUI

struct GuideTitleLeftCell: View {
    let title: String
    let description: String
    let colorScheme: ColorScheme
    let imageName: String
    
    var body: some View {
        HStack {
            VStack {
                Text(title)
                    .font(.system(size: 17, weight: .black, design: .rounded))
                    .foregroundStyle(Color(.orange))
                    .multilineTextAlignment(.center)
                    .padding(.leading)
                    .padding(.bottom)
                
                Text(description)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .padding(.bottom)
                
                Spacer()
            }
            
            Image(colorScheme == .dark ? "\(imageName)_dark" : "\(imageName)_light")
                .resizable()
                .frame(width: 180, height: 390)
                .padding(.horizontal)
        }
        
        Divider()
            .padding()
    }
}

#Preview {
    GuideTitleLeftCell(title: "Title", description: "Description", colorScheme: .light, imageName: "input")
}
