import SwiftUI
import Charts

struct ChartView: View {
    let data: [EmotionData]
    
    var body: some View {
        Chart {
            ForEach(data) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Emotion Value", dataPoint.value)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis {
            AxisMarks(values: data.map { $0.date })
        }
        .chartYScale(domain: -50 ... 50)
        .chartYAxis {
            AxisMarks(values: [-50, -25, 0, 25, 50])
        }
        .padding()
        .frame(minWidth: 320, idealWidth: .infinity, maxWidth: .infinity, minHeight: 300, idealHeight: 400, maxHeight: 500)
        .foregroundStyle(.linearGradient(colors: [.blue, .red], startPoint: .top, endPoint: .bottom))
    }
}
