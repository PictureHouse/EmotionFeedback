import SwiftUI
import Charts

struct ChartView: View {
    let data: [(Date, Double, Bool)]
    
    var body: some View {
        Chart {
            if data[0].2 == true {
                LineMark(
                    x: .value("Day0", data[0].0),
                    y: .value("Emotion0", data[0].1)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
            
            if data[1].2 == true {
                LineMark(
                    x: .value("Day1", data[1].0),
                    y: .value("Emotion1", data[1].1)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
            
            if data[2].2 == true {
                LineMark(
                    x: .value("Day2", data[2].0),
                    y: .value("Emotion2", data[2].1)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
            
            if data[3].2 == true {
                LineMark(
                    x: .value("Day3", data[3].0),
                    y: .value("Emotion3", data[3].1)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
            
            if data[4].2 == true {
                LineMark(
                    x: .value("Day4", data[4].0),
                    y: .value("Emotion4", data[4].1)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
            
            if data[5].2 == true {
                LineMark(
                    x: .value("Day5", data[5].0),
                    y: .value("Emotion5", data[5].1)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
            
            if data[6].2 == true {
                LineMark(
                    x: .value("Day6", data[6].0),
                    y: .value("Emotion6", data[6].1)
                )
                .symbol(.circle)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis {
            AxisMarks(values: [data[0].0, data[1].0, data[2].0, data[3].0, data[4].0, data[5].0, data[6].0])
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
