import SwiftUI

// MARK: - Slider Examples
// スライダーの様々なパターンを示すサンプルファイル

struct SliderExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            SliderExamplesView()
        }
    }
}

struct SliderExamplesView: View {
    // MARK: - State Variables
    @State private var basicValue: Double = 50
    @State private var volume: Double = 75
    @State private var brightness: Double = 0.6
    @State private var temperature: Double = 22.5
    @State private var price: Double = 5000
    @State private var progress: Double = 0.3
    @State private var speed: Double = 60
    @State private var zoom: Double = 1.0
    @State private var opacity: Double = 1.0
    @State private var hue: Double = 0.5
    
    // 範囲スライダー（カスタム実装）
    @State private var rangeStart: Double = 20
    @State private var rangeEnd: Double = 80
    
    // 設定値
    @State private var showValue = true
    @State private var enableHapticFeedback = true
    @State private var sliderStyle = SliderStyleOption.default
    
    enum SliderStyleOption: String, CaseIterable {
        case `default` = "デフォルト"
        case custom = "カスタム"
        case minimal = "ミニマル"
        case colorful = "カラフル"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 基本的なSlider
                    ExampleSection(title: "基本的なSlider") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("値: \(Int(basicValue))")
                                .font(.headline)
                            
                            Slider(value: $basicValue, in: 0...100, step: 1)
                            
                            HStack {
                                Text("0")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("100")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    // 音量コントロール
                    ExampleSection(title: "音量コントロール") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "speaker.fill")
                                    .foregroundColor(.blue)
                                Text("音量: \(Int(volume))%")
                                    .font(.subheadline)
                                Spacer()
                                if volume == 0 {
                                    Image(systemName: "speaker.slash.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "speaker.wave.1")
                                    .foregroundColor(.gray)
                                
                                Slider(value: $volume, in: 0...100, step: 5)
                                    .accentColor(volumeColor)
                                
                                Image(systemName: "speaker.wave.3")
                                    .foregroundColor(.gray)
                            }
                            
                            VolumeIndicatorView(volume: volume)
                        }
                    }
                    
                    // 明るさコントロール
                    ExampleSection(title: "明るさコントロール") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.yellow)
                                Text("明るさ: \(Int(brightness * 100))%")
                                    .font(.subheadline)
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "sun.min")
                                    .foregroundColor(.orange)
                                
                                Slider(value: $brightness, in: 0...1)
                                    .accentColor(.yellow)
                                
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.orange)
                            }
                            
                            BrightnessPreviewView(brightness: brightness)
                        }
                    }
                    
                    // 温度設定
                    ExampleSection(title: "温度設定") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "thermometer.medium")
                                    .foregroundColor(temperatureColor)
                                Text("温度: \(temperature, specifier: "%.1f")°C")
                                    .font(.subheadline)
                                Spacer()
                                TemperatureIconView(temperature: temperature)
                            }
                            
                            Slider(value: $temperature, in: 16...30, step: 0.5)
                                .accentColor(temperatureColor)
                            
                            HStack {
                                Text("16°C")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("23°C")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                Spacer()
                                Text("30°C")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            TemperatureSummaryView(temperature: temperature)
                        }
                    }
                    
                    // 価格範囲
                    ExampleSection(title: "価格範囲スライダー") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("予算: ¥\(Int(price))")
                                    .font(.subheadline)
                                Spacer()
                                Text(priceCategory)
                                    .font(.caption)
                                    .foregroundColor(priceCategoryColor)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(priceCategoryColor.opacity(0.2))
                                    .cornerRadius(4)
                            }
                            
                            Slider(value: $price, in: 1000...50000, step: 1000)
                                .accentColor(.green)
                            
                            HStack {
                                Text("¥1,000")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("¥25,000")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("¥50,000")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            PriceSuggestionView(price: price)
                        }
                    }
                    
                    // プログレスバー風
                    ExampleSection(title: "プログレスバー風Slider") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("進捗: \(Int(progress * 100))%")
                                .font(.subheadline)
                            
                            Slider(value: $progress, in: 0...1)
                                .accentColor(.blue)
                                .disabled(progress >= 1.0)
                            
                            ProgressIndicatorView(progress: progress)
                            
                            if progress >= 1.0 {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("完了!")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                    Spacer()
                                }
                            }
                        }
                    }
                    
                    // 速度コントロール
                    ExampleSection(title: "速度コントロール") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "speedometer")
                                    .foregroundColor(.blue)
                                Text("速度: \(Int(speed)) km/h")
                                    .font(.subheadline)
                                Spacer()
                                SpeedStatusView(speed: speed)
                            }
                            
                            Slider(value: $speed, in: 0...120, step: 5)
                                .accentColor(speedColor)
                            
                            HStack {
                                VStack {
                                    Text("0")
                                    Text("停止")
                                        .font(.caption)
                                }
                                .foregroundColor(.gray)
                                
                                Spacer()
                                
                                VStack {
                                    Text("60")
                                    Text("制限速度")
                                        .font(.caption)
                                }
                                .foregroundColor(.green)
                                
                                Spacer()
                                
                                VStack {
                                    Text("120")
                                    Text("最高速度")
                                        .font(.caption)
                                }
                                .foregroundColor(.red)
                            }
                            .font(.caption)
                        }
                    }
                    
                    // ズームコントロール
                    ExampleSection(title: "ズームコントロール") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ズーム倍率: \(zoom, specifier: "%.1f")x")
                                .font(.subheadline)
                            
                            HStack {
                                Button(action: { zoom = max(0.5, zoom - 0.1) }) {
                                    Image(systemName: "minus.magnifyingglass")
                                        .foregroundColor(.blue)
                                }
                                
                                Slider(value: $zoom, in: 0.5...3.0, step: 0.1)
                                    .accentColor(.blue)
                                
                                Button(action: { zoom = min(3.0, zoom + 0.1) }) {
                                    Image(systemName: "plus.magnifyingglass")
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            ZoomPreviewView(zoom: zoom)
                        }
                    }
                    
                    // 透明度コントロール
                    ExampleSection(title: "透明度コントロール") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("透明度: \(Int(opacity * 100))%")
                                .font(.subheadline)
                            
                            Slider(value: $opacity, in: 0...1)
                                .accentColor(.purple)
                            
                            OpacityPreviewView(opacity: opacity)
                        }
                    }
                    
                    // カラーピッカー風
                    ExampleSection(title: "色相スライダー") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("色相値: \(Int(hue * 360))°")
                                .font(.subheadline)
                            
                            Slider(value: $hue, in: 0...1)
                                .accentColor(Color(hue: hue, saturation: 1, brightness: 1))
                            
                            ColorPreviewView(hue: hue)
                        }
                    }
                    
                    // カスタムスタイル
                    ExampleSection(title: "カスタムスタイル") {
                        VStack(alignment: .leading, spacing: 15) {
                            Picker("スライダースタイル", selection: $sliderStyle) {
                                ForEach(SliderStyleOption.allCases, id: \.self) { style in
                                    Text(style.rawValue).tag(style)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            CustomStyledSlider(
                                value: $basicValue,
                                style: sliderStyle,
                                showValue: showValue
                            )
                            
                            Toggle("値を表示", isOn: $showValue)
                        }
                    }
                    
                    // 範囲スライダー（カスタム実装）
                    ExampleSection(title: "範囲スライダー") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("範囲: \(Int(rangeStart)) - \(Int(rangeEnd))")
                                .font(.subheadline)
                            
                            RangeSliderView(
                                start: $rangeStart,
                                end: $rangeEnd,
                                range: 0...100
                            )
                            
                            HStack {
                                Text("最小値: \(Int(rangeStart))")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("最大値: \(Int(rangeEnd))")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    // 実用例：オーディオイコライザー
                    ExampleSection(title: "実用例：オーディオイコライザー") {
                        AudioEqualizerView()
                    }
                }
                .padding()
            }
            .navigationTitle("Slider Examples")
        }
    }
    
    // MARK: - Computed Properties
    
    private var volumeColor: Color {
        if volume == 0 { return .gray }
        else if volume < 30 { return .green }
        else if volume < 70 { return .blue }
        else { return .orange }
    }
    
    private var temperatureColor: Color {
        if temperature < 20 { return .blue }
        else if temperature < 25 { return .green }
        else { return .red }
    }
    
    private var priceCategory: String {
        if price < 10000 { return "エコノミー" }
        else if price < 25000 { return "スタンダード" }
        else { return "プレミアム" }
    }
    
    private var priceCategoryColor: Color {
        if price < 10000 { return .green }
        else if price < 25000 { return .blue }
        else { return .purple }
    }
    
    private var speedColor: Color {
        if speed <= 60 { return .green }
        else if speed <= 100 { return .orange }
        else { return .red }
    }
}

// MARK: - Helper Views

struct ExampleSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content()
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct VolumeIndicatorView: View {
    let volume: Double
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<10, id: \.self) { index in
                Rectangle()
                    .fill(volume > Double(index * 10) ? volumeLevelColor(index) : Color.gray.opacity(0.3))
                    .frame(width: 4, height: CGFloat(8 + index * 2))
                    .cornerRadius(2)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
    
    private func volumeLevelColor(_ level: Int) -> Color {
        if level < 3 { return .green }
        else if level < 7 { return .yellow }
        else { return .red }
    }
}

struct BrightnessPreviewView: View {
    let brightness: Double
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.white)
            .opacity(brightness)
            .frame(height: 40)
            .overlay(
                Text("プレビュー")
                    .foregroundColor(.black)
                    .opacity(brightness > 0.5 ? 1 : 0)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct TemperatureIconView: View {
    let temperature: Double
    
    var body: some View {
        Group {
            if temperature < 18 {
                Image(systemName: "snowflake")
                    .foregroundColor(.blue)
            } else if temperature < 22 {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
            } else if temperature < 26 {
                Image(systemName: "sun.max.fill")
                    .foregroundColor(.orange)
            } else {
                Image(systemName: "flame.fill")
                    .foregroundColor(.red)
            }
        }
    }
}

struct TemperatureSummaryView: View {
    let temperature: Double
    
    var body: some View {
        HStack {
            Text(temperatureDescription)
                .font(.caption)
                .foregroundColor(temperatureColor)
            Spacer()
        }
        .padding(6)
        .background(temperatureColor.opacity(0.1))
        .cornerRadius(4)
    }
    
    private var temperatureDescription: String {
        if temperature < 18 { return "寒い - 暖房をおすすめします" }
        else if temperature < 22 { return "涼しい - 快適な温度です" }
        else if temperature < 26 { return "適温 - 理想的な温度です" }
        else { return "暑い - 冷房をおすすめします" }
    }
    
    private var temperatureColor: Color {
        if temperature < 18 { return .blue }
        else if temperature < 22 { return .green }
        else if temperature < 26 { return .green }
        else { return .red }
    }
}

struct PriceSuggestionView: View {
    let price: Double
    
    var suggestions: [String] {
        if price < 10000 {
            return ["カジュアルダイニング", "ファストフード", "お弁当"]
        } else if price < 25000 {
            return ["レストラン", "居酒屋", "カフェ"]
        } else {
            return ["高級レストラン", "特別なディナー", "記念日"]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("おすすめ:")
                .font(.caption)
                .bold()
            
            ForEach(suggestions, id: \.self) { suggestion in
                Text("• \(suggestion)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(6)
    }
}

struct ProgressIndicatorView: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .green]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: geometry.size.width * progress, height: 8)
                    .cornerRadius(4)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 8)
    }
}

struct SpeedStatusView: View {
    let speed: Double
    
    var body: some View {
        Text(speedStatus)
            .font(.caption)
            .foregroundColor(statusColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .cornerRadius(4)
    }
    
    private var speedStatus: String {
        if speed == 0 { return "停止" }
        else if speed <= 40 { return "低速" }
        else if speed <= 60 { return "標準" }
        else if speed <= 100 { return "高速" }
        else { return "危険" }
    }
    
    private var statusColor: Color {
        if speed == 0 { return .gray }
        else if speed <= 40 { return .green }
        else if speed <= 60 { return .blue }
        else if speed <= 100 { return .orange }
        else { return .red }
    }
}

struct ZoomPreviewView: View {
    let zoom: Double
    
    var body: some View {
        VStack {
            Text("サンプルテキスト")
                .font(.system(size: 16 * zoom))
                .scaleEffect(zoom)
                .frame(height: 60)
                .animation(.easeInOut(duration: 0.2), value: zoom)
            
            Text("ズーム: \(zoom, specifier: "%.1f")x")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct OpacityPreviewView: View {
    let opacity: Double
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.blue)
                .opacity(opacity)
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            
            Rectangle()
                .fill(Color.red)
                .opacity(opacity)
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            
            Rectangle()
                .fill(Color.green)
                .opacity(opacity)
                .frame(width: 40, height: 40)
                .cornerRadius(8)
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct ColorPreviewView: View {
    let hue: Double
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(hue: hue, saturation: 1, brightness: 1))
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("HSB値:")
                    .font(.caption)
                    .bold()
                Text("H: \(Int(hue * 360))°")
                    .font(.caption)
                Text("S: 100%")
                    .font(.caption)
                Text("B: 100%")
                    .font(.caption)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct CustomStyledSlider: View {
    @Binding var value: Double
    let style: SliderExamplesView.SliderStyleOption
    let showValue: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if showValue {
                Text("値: \(Int(value))")
                    .font(.subheadline)
            }
            
            switch style {
            case .default:
                Slider(value: $value, in: 0...100)
                
            case .custom:
                Slider(value: $value, in: 0...100)
                    .accentColor(.purple)
                    .background(
                        Capsule()
                            .fill(Color.purple.opacity(0.2))
                            .frame(height: 8)
                    )
                
            case .minimal:
                Slider(value: $value, in: 0...100)
                    .accentColor(.black)
                
            case .colorful:
                Slider(value: $value, in: 0...100)
                    .accentColor(Color(hue: value / 100, saturation: 1, brightness: 1))
            }
        }
    }
}

struct RangeSliderView: View {
    @Binding var start: Double
    @Binding var end: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                // Active range
                Rectangle()
                    .fill(Color.blue)
                    .frame(
                        width: (end - start) / (range.upperBound - range.lowerBound) * geometry.size.width,
                        height: 4
                    )
                    .cornerRadius(2)
                    .offset(x: (start - range.lowerBound) / (range.upperBound - range.lowerBound) * geometry.size.width)
                
                // Start thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .offset(x: (start - range.lowerBound) / (range.upperBound - range.lowerBound) * (geometry.size.width - 20))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = range.lowerBound + (value.location.x / geometry.size.width) * (range.upperBound - range.lowerBound)
                                start = min(max(newValue, range.lowerBound), end - 1)
                            }
                    )
                
                // End thumb
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .offset(x: (end - range.lowerBound) / (range.upperBound - range.lowerBound) * (geometry.size.width - 20))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newValue = range.lowerBound + (value.location.x / geometry.size.width) * (range.upperBound - range.lowerBound)
                                end = max(min(newValue, range.upperBound), start + 1)
                            }
                    )
            }
        }
        .frame(height: 40)
    }
}

struct AudioEqualizerView: View {
    @State private var frequencies = [0.5, 0.3, 0.7, 0.9, 0.6, 0.4, 0.8, 0.2]
    
    let frequencyLabels = ["60Hz", "170Hz", "310Hz", "600Hz", "1kHz", "3kHz", "6kHz", "12kHz"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("オーディオイコライザー")
                .font(.subheadline)
                .bold()
            
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(0..<frequencies.count, id: \.self) { index in
                    VStack(spacing: 8) {
                        Slider(
                            value: $frequencies[index],
                            in: 0...1
                        )
                        .rotationEffect(.degrees(-90))
                        .frame(width: 20, height: 100)
                        .accentColor(frequencyColor(frequencies[index]))
                        
                        Text(frequencyLabels[index])
                            .font(.caption)
                            .foregroundColor(.gray)
                            .rotationEffect(.degrees(-45))
                    }
                }
            }
            
            HStack {
                Button("リセット") {
                    frequencies = Array(repeating: 0.5, count: 8)
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Button("ロック風") {
                    frequencies = [0.7, 0.5, 0.3, 0.4, 0.6, 0.8, 0.9, 0.8]
                }
                .foregroundColor(.red)
                
                Button("ジャズ風") {
                    frequencies = [0.4, 0.3, 0.4, 0.5, 0.6, 0.5, 0.4, 0.3]
                }
                .foregroundColor(.green)
            }
            .font(.caption)
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(12)
    }
    
    private func frequencyColor(_ value: Double) -> Color {
        if value < 0.3 { return .blue }
        else if value < 0.7 { return .green }
        else { return .red }
    }
}

// MARK: - Preview
#Preview {
    SliderExamplesView()
}