import SwiftUI

struct GuideTitleRightCell: View {
    let title: String
    let description: String
    let colorScheme: ColorScheme
    let imageName: String
    
    var body: some View {
        HStack {
            Image(colorScheme == .dark ? "\(imageName)_dark" : "\(imageName)_light")
                .resizable()
                .frame(width: 180, height: 390)
                .padding(.horizontal)
            
            VStack {
                Text(title)
                    .font(.system(size: 17, weight: .black, design: .rounded))
                    .foregroundStyle(Color(.orange))
                    .multilineTextAlignment(.center)
                    .padding(.trailing)
                    .padding(.bottom)
                
                Text(description)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                
                Spacer()
            }
        }
        
        Divider()
            .padding()
    }
}

#Preview {
    GuideTitleRightCell(title: "Title", description: "Description", colorScheme: .light, imageName: "input")
}
