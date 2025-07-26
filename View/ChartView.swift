import SwiftUI
import Charts

struct ChartView: View {
    @Binding var data: [EmotionData]
    
    @State private var isAnimated: Bool = false
    
    var body: some View {
        Chart {
            ForEach(data) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.date),
                    y: .value("Emotion Value", dataPoint.isAnimated ? dataPoint.value : medianValue)
                )
                .symbol(.circle)
                .symbolSize(100)
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis {
            AxisMarks(values: data.map { $0.date })
        }
        .chartYScale(domain: yAxisDomain)
        .chartYAxis {
            AxisMarks(values: [-50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50])
        }
        .padding(32)
        .frame(minWidth: 320, idealWidth: .infinity, maxWidth: .infinity, minHeight: 300, idealHeight: 400, maxHeight: 500)
        .foregroundStyle(.linearGradient(colors: [.blue, .green, .orange, .red], startPoint: .top, endPoint: .bottom))
        .clipped()
        .onAppear {
            animateChart()
            resetAnimation()
        }
        .onChange(of: data.count) {
            resetAnimation()
            animateChart()
        }
        .onChange(of: data.map { $0.value }) {
            resetAnimation()
            animateChart()
        }
    }
}

private extension ChartView {
    var yAxisDomain: ClosedRange<Double> {
        guard !data.isEmpty else { return -50 ... 50 }
        let values = data.map { $0.value }
        let minValue = values.min() ?? -50
        let maxValue = values.max() ?? 50
        return minValue - 5 ... maxValue + 5
    }
    
    var medianValue: Double {
        guard !data.isEmpty else { return 0 }
        let values = data.map { $0.value }
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 0
        return (minValue + maxValue) / 2
    }
    
    func animateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        $data.enumerated().forEach { index, dataPoint in
            let delay = Double(index) * 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.linear(duration: 0.5)) {
                    dataPoint.wrappedValue.isAnimated = true
                }
            }
        }
    }
    
    func resetAnimation() {
        isAnimated = false
        $data.enumerated().forEach { index, dataPoint in
            dataPoint.wrappedValue.isAnimated = false
        }
    }
}
