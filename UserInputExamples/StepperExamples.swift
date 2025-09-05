import SwiftUI

// MARK: - Stepper Examples
// ステッパーの様々なパターンを示すサンプルファイル

struct StepperExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            StepperExamplesView()
        }
    }
}

struct StepperExamplesView: View {
    // MARK: - State Variables
    @State private var basicValue = 5
    @State private var quantity = 1
    @State private var temperature: Double = 20.0
    @State private var fontSize: Double = 16
    @State private var participants = 2
    @State private var volume = 50
    @State private var speed = 60
    @State private var brightness = 50
    @State private var pages = 10
    @State private var lives = 3
    
    // カスタム設定
    @State private var stepSize = 1
    @State private var enableHapticFeedback = true
    @State private var showValueDescription = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 基本的なStepper
                    ExampleSection(title: "基本的なStepper") {
                        VStack(alignment: .leading, spacing: 10) {
                            Stepper("値: \(basicValue)", value: $basicValue, in: 0...10)
                            
                            Text("現在の値は \(basicValue) です")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // 商品数量選択
                    ExampleSection(title: "商品数量選択") {
                        VStack(alignment: .leading, spacing: 10) {
                            Stepper("数量: \(quantity)", value: $quantity, in: 1...10)
                            
                            ProductSummaryView(quantity: quantity)
                        }
                    }
                    
                    // カスタム温度設定
                    ExampleSection(title: "温度設定（カスタムデザイン）") {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("エアコン温度設定")
                                .font(.subheadline)
                                .bold()
                            
                            CustomTemperatureStepper(temperature: $temperature)
                            
                            TemperatureStatusView(temperature: temperature)
                        }
                    }
                    
                    // フォントサイズ調整
                    ExampleSection(title: "フォントサイズ調整") {
                        VStack(alignment: .leading, spacing: 10) {
                            Stepper("フォントサイズ: \(Int(fontSize))pt", value: $fontSize, in: 8...32, step: 2)
                            
                            Text("これがサンプルテキストです")
                                .font(.system(size: fontSize))
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .animation(.easeInOut(duration: 0.2), value: fontSize)
                            
                            FontSizeRecommendationView(fontSize: fontSize)
                        }
                    }
                    
                    // 参加者数管理
                    ExampleSection(title: "参加者数管理") {
                        VStack(alignment: .leading, spacing: 10) {
                            Stepper("参加者数: \(participants)名", value: $participants, in: 1...20)
                            
                            ParticipantsSummaryView(participants: participants)
                        }
                    }
                    
                    // 音量調整（アイコン付き）
                    ExampleSection(title: "音量調整") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(.blue)
                                
                                Stepper("音量: \(volume)%", value: $volume, in: 0...100, step: 10)
                            }
                            
                            VolumeVisualizationView(volume: volume)
                        }
                    }
                    
                    // 速度制御
                    ExampleSection(title: "速度制御") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "speedometer")
                                    .foregroundColor(speedColor)
                                
                                Stepper("速度: \(speed) km/h", value: $speed, in: 0...200, step: 10)
                            }
                            
                            SpeedGaugeView(speed: speed)
                        }
                    }
                    
                    // 明るさ調整
                    ExampleSection(title: "画面明度調整") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: brightnessIcon)
                                    .foregroundColor(.yellow)
                                
                                Stepper("明るさ: \(brightness)%", value: $brightness, in: 10...100, step: 10)
                            }
                            
                            BrightnessPreviewView(brightness: brightness)
                        }
                    }
                    
                    // ページ数設定
                    ExampleSection(title: "ページ数設定") {
                        VStack(alignment: .leading, spacing: 10) {
                            Stepper("ページ数: \(pages)", value: $pages, in: 1...100, step: 5)
                            
                            PageCalculationView(pages: pages)
                        }
                    }
                    
                    // ゲーム風ライフカウンター
                    ExampleSection(title: "ライフカウンター（ゲーム風）") {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                ForEach(0..<lives, id: \.self) { _ in
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                                
                                Spacer()
                                
                                Text("\(lives) / 5")
                                    .font(.headline)
                                    .bold()
                            }
                            
                            Stepper("ライフ: \(lives)", value: $lives, in: 0...5)
                            
                            LifeStatusView(lives: lives)
                        }
                    }
                    
                    // カスタマイズ可能なStepper
                    ExampleSection(title: "カスタマイズ可能なStepper") {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Text("ステップサイズ: \(stepSize)")
                                .font(.subheadline)
                            
                            Stepper("", value: $stepSize, in: 1...10)
                            
                            Toggle("ハプティックフィードバック", isOn: $enableHapticFeedback)
                            
                            Toggle("値の説明を表示", isOn: $showValueDescription)
                            
                            Divider()
                            
                            CustomizableStepperView(
                                value: $basicValue,
                                stepSize: stepSize,
                                enableHapticFeedback: enableHapticFeedback,
                                showValueDescription: showValueDescription
                            )
                        }
                    }
                    
                    // 複数のStepperを組み合わせた例
                    ExampleSection(title: "複数Stepper組み合わせ例") {
                        MultiStepperConfigView()
                    }
                    
                    // 実用例：レシピ分量計算機
                    ExampleSection(title: "実用例：レシピ分量計算機") {
                        RecipeCalculatorView()
                    }
                }
                .padding()
            }
            .navigationTitle("Stepper Examples")
        }
    }
    
    // MARK: - Computed Properties
    
    private var speedColor: Color {
        if speed <= 50 { return .green }
        else if speed <= 100 { return .yellow }
        else if speed <= 150 { return .orange }
        else { return .red }
    }
    
    private var brightnessIcon: String {
        if brightness < 30 { return "sun.min" }
        else if brightness < 70 { return "sun.max" }
        else { return "sun.max.fill" }
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

struct ProductSummaryView: View {
    let quantity: Int
    
    private let unitPrice = 1200
    private var totalPrice: Int { quantity * unitPrice }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("商品名: SwiftUIガイドブック")
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Text("単価: ¥\(unitPrice)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text("合計: ¥\(totalPrice)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.blue)
            }
            
            if quantity >= 5 {
                HStack {
                    Image(systemName: "gift.fill")
                        .foregroundColor(.green)
                    Text("5冊以上で送料無料!")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
}

struct CustomTemperatureStepper: View {
    @Binding var temperature: Double
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: { 
                if temperature > 16.0 {
                    temperature -= 0.5
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
                    .foregroundColor(temperature <= 16.0 ? .gray : .blue)
            }
            .disabled(temperature <= 16.0)
            
            VStack {
                Text("\(temperature, specifier: "%.1f")°C")
                    .font(.title2)
                    .bold()
                
                Text(temperatureDescription)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(width: 100)
            
            Button(action: { 
                if temperature < 30.0 {
                    temperature += 0.5
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(temperature >= 30.0 ? .gray : .red)
            }
            .disabled(temperature >= 30.0)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private var temperatureDescription: String {
        if temperature < 18 { return "寒い" }
        else if temperature < 22 { return "涼しい" }
        else if temperature < 26 { return "快適" }
        else { return "暑い" }
    }
}

struct TemperatureStatusView: View {
    let temperature: Double
    
    var body: some View {
        HStack {
            Circle()
                .fill(temperatureColor)
                .frame(width: 12, height: 12)
            
            Text(temperatureStatusText)
                .font(.caption)
                .foregroundColor(temperatureColor)
            
            Spacer()
            
            Text("範囲: 16.0°C - 30.0°C")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(temperatureColor.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var temperatureColor: Color {
        if temperature < 20 { return .blue }
        else if temperature < 25 { return .green }
        else { return .red }
    }
    
    private var temperatureStatusText: String {
        if temperature < 20 { return "冷房設定 - 電力消費: 高" }
        else if temperature < 25 { return "エコモード - 電力消費: 低" }
        else { return "暖房設定 - 電力消費: 高" }
    }
}

struct FontSizeRecommendationView: View {
    let fontSize: Double
    
    var body: some View {
        HStack {
            Image(systemName: recommendationIcon)
                .foregroundColor(recommendationColor)
            Text(recommendationText)
                .font(.caption)
                .foregroundColor(recommendationColor)
            Spacer()
        }
        .padding(6)
        .background(recommendationColor.opacity(0.1))
        .cornerRadius(4)
    }
    
    private var recommendationIcon: String {
        if fontSize < 12 { return "exclamationmark.triangle" }
        else if fontSize <= 18 { return "checkmark.circle" }
        else if fontSize <= 24 { return "eye" }
        else { return "exclamationmark.triangle" }
    }
    
    private var recommendationColor: Color {
        if fontSize < 12 { return .orange }
        else if fontSize <= 18 { return .green }
        else if fontSize <= 24 { return .blue }
        else { return .red }
    }
    
    private var recommendationText: String {
        if fontSize < 12 { return "小さすぎて読みにくい可能性があります" }
        else if fontSize <= 18 { return "読みやすいサイズです" }
        else if fontSize <= 24 { return "大きめで見やすいサイズです" }
        else { return "大きすぎる可能性があります" }
    }
}

struct ParticipantsSummaryView: View {
    let participants: Int
    
    private var roomType: String {
        if participants <= 4 { return "小会議室" }
        else if participants <= 10 { return "中会議室" }
        else { return "大会議室" }
    }
    
    private var costPerPerson: Int { 2500 }
    private var totalCost: Int { participants * costPerPerson }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("推奨会場: \(roomType)")
                    .font(.caption)
                    .bold()
                Spacer()
                Text("1人あたり: ¥\(costPerPerson)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text("総額: ¥\(totalCost)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.blue)
                Spacer()
                
                if participants >= 10 {
                    HStack {
                        Image(systemName: "gift")
                            .foregroundColor(.green)
                        Text("団体割引適用")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct VolumeVisualizationView: View {
    let volume: Int
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<10, id: \.self) { index in
                Rectangle()
                    .fill(volume > index * 10 ? volumeColor(for: index) : Color.gray.opacity(0.3))
                    .frame(width: 8, height: CGFloat(8 + index * 3))
                    .cornerRadius(2)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
    
    private func volumeColor(for index: Int) -> Color {
        if index < 3 { return .green }
        else if index < 7 { return .yellow }
        else { return .red }
    }
}

struct SpeedGaugeView: View {
    let speed: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(speedStatus)
                    .font(.caption)
                    .bold()
                    .foregroundColor(speedColor)
                Spacer()
                Text("最高速度: 200 km/h")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(speedColor)
                        .frame(width: geometry.size.width * (Double(speed) / 200.0), height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 0.3), value: speed)
                }
            }
            .frame(height: 6)
        }
        .padding(8)
        .background(speedColor.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var speedStatus: String {
        if speed == 0 { return "停止中" }
        else if speed <= 60 { return "安全速度" }
        else if speed <= 100 { return "標準速度" }
        else if speed <= 150 { return "高速" }
        else { return "危険速度" }
    }
    
    private var speedColor: Color {
        if speed == 0 { return .gray }
        else if speed <= 60 { return .green }
        else if speed <= 100 { return .blue }
        else if speed <= 150 { return .orange }
        else { return .red }
    }
}

struct BrightnessPreviewView: View {
    let brightness: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Rectangle()
                    .fill(Color.white)
                    .opacity(Double(brightness) / 100.0)
                    .frame(width: 60, height: 40)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                VStack(alignment: .leading) {
                    Text("画面プレビュー")
                        .font(.caption)
                        .bold()
                    Text("明度: \(brightness)%")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            if brightness < 20 {
                Text("⚠️ 暗すぎる可能性があります")
                    .font(.caption)
                    .foregroundColor(.orange)
            } else if brightness > 90 {
                Text("⚠️ 明るすぎてバッテリーを消耗します")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct PageCalculationView: View {
    let pages: Int
    
    private var estimatedReadingTime: Int {
        pages * 2 // 1ページ2分として計算
    }
    
    private var paperCost: Int {
        Int(ceil(Double(pages) / 4.0)) * 10 // 4ページで1枚、1枚10円
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("推定読了時間: \(estimatedReadingTime)分")
                    .font(.caption)
                Spacer()
                Text("用紙コスト: ¥\(paperCost)")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("用紙枚数: \(Int(ceil(Double(pages) / 4.0)))枚")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                
                if pages > 50 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.orange)
                        Text("大量印刷")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct LifeStatusView: View {
    let lives: Int
    
    var body: some View {
        HStack {
            Text(lifeStatus)
                .font(.caption)
                .bold()
                .foregroundColor(lifeColor)
            Spacer()
        }
        .padding(6)
        .background(lifeColor.opacity(0.1))
        .cornerRadius(4)
    }
    
    private var lifeStatus: String {
        switch lives {
        case 0: return "ゲームオーバー"
        case 1: return "危険! 残り1ライフ"
        case 2: return "注意! 残り2ライフ"
        case 3...4: return "安全圏"
        case 5: return "フルライフ"
        default: return ""
        }
    }
    
    private var lifeColor: Color {
        switch lives {
        case 0: return .red
        case 1: return .red
        case 2: return .orange
        case 3...4: return .green
        case 5: return .blue
        default: return .gray
        }
    }
}

struct CustomizableStepperView: View {
    @Binding var value: Int
    let stepSize: Int
    let enableHapticFeedback: Bool
    let showValueDescription: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Stepper("カスタム値: \(value)", value: $value, in: 0...100, step: stepSize)
                .onChange(of: value) { _ in
                    if enableHapticFeedback {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                }
            
            if showValueDescription {
                Text(valueDescription)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text("ステップサイズ: \(stepSize)")
                    .font(.caption)
                    .foregroundColor(.blue)
                Spacer()
                Text("範囲: 0-100")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(8)
        .background(Color.blue.opacity(0.05))
        .cornerRadius(6)
    }
    
    private var valueDescription: String {
        switch value {
        case 0...20: return "低い値です"
        case 21...40: return "やや低い値です"
        case 41...60: return "中程度の値です"
        case 61...80: return "やや高い値です"
        case 81...100: return "高い値です"
        default: return "値が範囲外です"
        }
    }
}

struct MultiStepperConfigView: View {
    @State private var red: Int = 128
    @State private var green: Int = 128
    @State private var blue: Int = 128
    @State private var alpha: Int = 100
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RGB カラー設定")
                .font(.subheadline)
                .bold()
            
            VStack(spacing: 8) {
                HStack {
                    Text("R:")
                        .foregroundColor(.red)
                        .frame(width: 20)
                    Stepper("", value: $red, in: 0...255)
                    Text("\(red)")
                        .frame(width: 30)
                        .font(.monospaced(.body)())
                }
                
                HStack {
                    Text("G:")
                        .foregroundColor(.green)
                        .frame(width: 20)
                    Stepper("", value: $green, in: 0...255)
                    Text("\(green)")
                        .frame(width: 30)
                        .font(.monospaced(.body)())
                }
                
                HStack {
                    Text("B:")
                        .foregroundColor(.blue)
                        .frame(width: 20)
                    Stepper("", value: $blue, in: 0...255)
                    Text("\(blue)")
                        .frame(width: 30)
                        .font(.monospaced(.body)())
                }
                
                HStack {
                    Text("α:")
                        .foregroundColor(.gray)
                        .frame(width: 20)
                    Stepper("", value: $alpha, in: 0...100)
                    Text("\(alpha)%")
                        .frame(width: 30)
                        .font(.monospaced(.body)())
                }
            }
            
            // カラープレビュー
            HStack {
                Rectangle()
                    .fill(Color(
                        red: Double(red) / 255.0,
                        green: Double(green) / 255.0,
                        blue: Double(blue) / 255.0,
                        opacity: Double(alpha) / 100.0
                    ))
                    .frame(width: 60, height: 40)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                VStack(alignment: .leading) {
                    Text("RGB(\(red), \(green), \(blue))")
                        .font(.caption)
                        .font(.monospaced(.caption)())
                    Text("不透明度: \(alpha)%")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button("リセット") {
                    red = 128
                    green = 128
                    blue = 128
                    alpha = 100
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
        }
    }
}

struct RecipeCalculatorView: View {
    @State private var servings = 4
    @State private var originalServings = 4
    
    // 基本レシピ（4人分）
    private let baseRecipe = [
        ("鶏もも肉", 600, "g"),
        ("玉ねぎ", 2, "個"),
        ("人参", 1, "本"),
        ("じゃがいも", 3, "個"),
        ("カレールー", 1, "箱"),
        ("水", 800, "ml")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("カレーレシピ計算機")
                .font(.subheadline)
                .bold()
            
            HStack {
                Text("人数:")
                Stepper("", value: $servings, in: 1...20)
                Text("\(servings)人分")
                    .bold()
                
                Spacer()
                
                if servings != originalServings {
                    Text("倍率: \(Double(servings) / Double(originalServings), specifier: "%.1f")x")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("材料:")
                    .font(.caption)
                    .bold()
                
                ForEach(baseRecipe, id: \.0) { ingredient, amount, unit in
                    let adjustedAmount = Double(amount) * Double(servings) / Double(originalServings)
                    
                    HStack {
                        Text("• \(ingredient):")
                            .font(.caption)
                        Spacer()
                        Text("\(formatAmount(adjustedAmount))\(unit)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(8)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(6)
            
            if servings > 10 {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                    Text("大人数用レシピです。調理器具のサイズにご注意ください。")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
    private func formatAmount(_ amount: Double) -> String {
        if amount == floor(amount) {
            return String(Int(amount))
        } else {
            return String(format: "%.1f", amount)
        }
    }
}

// MARK: - Preview
#Preview {
    StepperExamplesView()
}