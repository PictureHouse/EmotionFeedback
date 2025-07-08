import SwiftUI

struct FeedbackView: View {
    let result: [Int]
    @Binding var tapped: Bool
    
    @State private var text1 = ""
    @State private var text2 = ""
    
    var body: some View {
        VStack {
            Button(action: {
                setFeedbackMessage()
                tapped = true
            }, label: {
                VStack {
                    Image(systemName: tapped ? "checkmark.message" : "ellipsis.message")
                        .resizable()
                        .frame(width: 50, height: 50)
                    
                    if tapped == false {
                        Text("Tap to check the feedback!\n")
                    } else {
                        Text(text1)
                            .multilineTextAlignment(.center)
                        Text(text2)
                            .multilineTextAlignment(.center)
                    }
                }
                .sensoryFeedback(.success, trigger: tapped)
            })
        }
        .frame(minWidth: 320, idealWidth: .infinity, maxWidth: .infinity, minHeight: 100, idealHeight: 120, maxHeight: 150)
        .foregroundStyle(Color.orange)
    }
}

private extension FeedbackView {
    func setFeedbackMessage() {
        if result[0] == 0 {
            text1 = "There is no emotion data yet! How about entering emotion data?"
            text2 = "Let’s click the + button at the top right of the chart!"
        } else if result[0] == 1 && result[1] == 1 {
            text1 = "You have entered your first emotion data!"
            text2 = "It was a nice day! Shall we maintain this feeling in the future?"
        } else if result[0] == 1 && result[2] == 1 {
            text1 = "You have entered your first emotion data!"
            text2 = "It wasn't a very good day. Shall we do our best to feel a little better next time?"
        } else if result[0] == 1 && result[3] == 1 {
            text1 = "You have entered your first emotion data!"
            text2 = "It was an okay day! Right?"
        } else if result[0] > 1 && result[0] == result[1] {
            text1 = "Perfect!"
            text2 = "Let's keep this feeling going!"
        } else if result[0] > 1 && result[0] == result[2] {
            text1 = "Are there any difficult or stressful things going on?"
            text2 = "If you solve the problems that are bothering you, you will feel better!"
        } else if result[0] > 1 && result[6] >= (result[0] - 1) / 3 && result[6] > 0 {
            text1 = "Ops! You have some big mood swings!"
            text2 = "If you find the cause of severe emotional changes, you will be able to reduce the ups and downs!"
        } else if result[0] > 1 && result[1] + result[3] > result[2] && result[4] > 0 && result[5] == 0 {
            text1 = "Overall, your feelings have improved!"
            text2 = "Let's keep these good feelings going!"
        } else if result[0] > 1 && result[1] + result[3] < result[2] && result[4] == 0 && result[5] > 0 {
            text1 = "Overall, your emotions have turned negative."
            text2 = "How about finding the cause of the change and solving it?"
        } else if result[0] > 1 && result[4] + result[5] > (result[0] - 1) / 2 && result[4] + result[5] > 0 {
            text1 = "There seems to be ups and downs in emotional changes."
            text2 = "Let’s find the cause of the change and keep the positive emotions going!"
        } else if result[0] > 1 && result[1] + result[3] > result[0] / 2 {
            text1 = "Good enough!"
            text2 = "A little more positive emotions would be perfect!"
        } else if result[0] > 1 && result[2] + result[3] > result[0] / 2 {
            text1 = "Let's think about what's making me feel bad."
            text2 = "If you find the reason, you will be able to feel a little more positive!"
        } else {
            text1 = "Sorry, we can't analyze emotion data patterns."
        }
    }
}
