import SwiftUI

// MARK: - DatePicker Examples
// 日付・時刻選択の様々なパターンを示すサンプルファイル

struct DatePickerExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            DatePickerExamplesView()
        }
    }
}

struct DatePickerExamplesView: View {
    // MARK: - State Variables
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @State private var reservationDate = Date()
    @State private var appointmentDateTime = Date()
    @State private var startDate = Date()
    @State private var endDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    @State private var eventDate = Date()
    @State private var reminderTime = Date()
    @State private var workStartTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var workEndTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date()
    
    // カスタム設定
    @State private var allowPastDates = false
    @State private var selectedTimeZone = TimeZone.current
    @State private var use24HourFormat = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 基本的な日付選択
                    ExampleSection(title: "基本的な日付選択") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("日付を選択してください")
                                .font(.subheadline)
                            
                            DatePicker("日付", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .frame(maxHeight: 300)
                            
                            DateResultView(
                                label: "選択された日付",
                                date: selectedDate,
                                style: .date
                            )
                        }
                    }
                    
                    // 時刻選択
                    ExampleSection(title: "時刻選択") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("時刻を選択してください")
                                .font(.subheadline)
                            
                            DatePicker("時刻", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(height: 120)
                                .clipped()
                            
                            DateResultView(
                                label: "選択された時刻",
                                date: selectedTime,
                                style: .time
                            )
                        }
                    }
                    
                    // コンパクトスタイル
                    ExampleSection(title: "コンパクトスタイル") {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            HStack {
                                Text("予約日:")
                                    .font(.subheadline)
                                Spacer()
                                DatePicker("", selection: $reservationDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                            }
                            
                            HStack {
                                Text("予約時刻:")
                                    .font(.subheadline)
                                Spacer()
                                DatePicker("", selection: $reservationDate, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(CompactDatePickerStyle())
                            }
                            
                            ReservationSummaryView(date: reservationDate)
                        }
                    }
                    
                    // 日付範囲制限
                    ExampleSection(title: "日付範囲制限") {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            // 未来の日付のみ（今日から3ヶ月後まで）
                            VStack(alignment: .leading, spacing: 5) {
                                Text("イベント日（今日〜3ヶ月後）")
                                    .font(.subheadline)
                                
                                DatePicker(
                                    "イベント日",
                                    selection: $eventDate,
                                    in: Date()...Calendar.current.date(byAdding: .month, value: 3, to: Date())!,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(CompactDatePickerStyle())
                                
                                Text("選択可能範囲: \(Date(), formatter: shortDateFormatter) 〜 \(Calendar.current.date(byAdding: .month, value: 3, to: Date())!, formatter: shortDateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            // 過去の日付のみ（生年月日）
                            VStack(alignment: .leading, spacing: 5) {
                                Text("生年月日（1900年〜今日）")
                                    .font(.subheadline)
                                
                                DatePicker(
                                    "生年月日",
                                    selection: $birthDate,
                                    in: Calendar.current.date(byAdding: .year, value: -123, to: Date())!...Date(),
                                    displayedComponents: .date
                                )
                                .datePickerStyle(WheelDatePickerStyle())
                                .frame(height: 120)
                                .clipped()
                                
                                AgeDisplayView(birthDate: birthDate)
                            }
                        }
                    }
                    
                    // 日付と時刻の組み合わせ
                    ExampleSection(title: "日付と時刻の組み合わせ") {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("予約日時を選択してください")
                                .font(.subheadline)
                            
                            DatePicker(
                                "予約日時",
                                selection: $appointmentDateTime,
                                in: Date()...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            
                            AppointmentSummaryView(dateTime: appointmentDateTime)
                        }
                    }
                    
                    // 期間選択
                    ExampleSection(title: "期間選択") {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("プロジェクト期間を選択してください")
                                .font(.subheadline)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("開始日")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    DatePicker("開始日", selection: $startDate, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("終了日")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    DatePicker("終了日", selection: $endDate, in: startDate..., displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                }
                            }
                            
                            PeriodSummaryView(startDate: startDate, endDate: endDate)
                        }
                        .onChange(of: startDate) { newStartDate in
                            if endDate < newStartDate {
                                endDate = Calendar.current.date(byAdding: .day, value: 1, to: newStartDate) ?? newStartDate
                            }
                        }
                    }
                    
                    // 勤務時間設定
                    ExampleSection(title: "勤務時間設定") {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("勤務時間を設定してください")
                                .font(.subheadline)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("開始時刻")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    DatePicker("開始時刻", selection: $workStartTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(WheelDatePickerStyle())
                                        .frame(height: 80)
                                        .clipped()
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("終了時刻")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    DatePicker("終了時刻", selection: $workEndTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(WheelDatePickerStyle())
                                        .frame(height: 80)
                                        .clipped()
                                }
                            }
                            
                            WorkHoursSummaryView(startTime: workStartTime, endTime: workEndTime)
                        }
                    }
                    
                    // リマインダー設定
                    ExampleSection(title: "リマインダー設定") {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("リマインダー時刻を設定してください")
                                .font(.subheadline)
                            
                            DatePicker(
                                "リマインダー時刻",
                                selection: $reminderTime,
                                displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .frame(height: 120)
                            .clipped()
                            
                            ReminderPreviewView(reminderTime: reminderTime)
                        }
                    }
                    
                    // カスタム設定
                    ExampleSection(title: "カスタム設定") {
                        VStack(alignment: .leading, spacing: 15) {
                            
                            Toggle("過去の日付を許可", isOn: $allowPastDates)
                            
                            Toggle("24時間形式を使用", isOn: $use24HourFormat)
                            
                            CustomDatePickerView(
                                selectedDate: $selectedDate,
                                allowPastDates: allowPastDates,
                                use24HourFormat: use24HourFormat
                            )
                        }
                    }
                    
                    // インライン表示
                    ExampleSection(title: "インライン表示") {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("誕生日を選択してください")
                                .font(.subheadline)
                            
                            DatePicker("誕生日", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .frame(maxHeight: 300)
                        }
                    }
                    
                    // 実用的な例：イベントスケジューラー
                    ExampleSection(title: "実用例：イベントスケジューラー") {
                        EventSchedulerView()
                    }
                }
                .padding()
            }
            .navigationTitle("DatePicker Examples")
        }
    }
    
    // MARK: - Formatters
    private var shortDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
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

struct DateResultView: View {
    let label: String
    let date: Date
    let style: DateStyle
    
    enum DateStyle {
        case date, time, dateTime
    }
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.blue)
            Text("\(label): \(formattedDate)")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var iconName: String {
        switch style {
        case .date: return "calendar"
        case .time: return "clock"
        case .dateTime: return "calendar.badge.clock"
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        
        switch style {
        case .date:
            formatter.dateStyle = .long
            return formatter.string(from: date)
        case .time:
            formatter.timeStyle = .short
            return formatter.string(from: date)
        case .dateTime:
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
}

struct ReservationSummaryView: View {
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("予約サマリー")
                .font(.caption)
                .bold()
            
            HStack {
                Image(systemName: "calendar.badge.checkmark")
                    .foregroundColor(.green)
                Text(formattedDateTime)
                    .font(.caption)
                Spacer()
            }
            
            Text("※ 予約確定後にメールでご連絡いたします")
                .font(.caption)
                .foregroundColor(.gray)
                .italic()
        }
        .padding(8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AgeDisplayView: View {
    let birthDate: Date
    
    private var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }
    
    private var zodiacSign: String {
        let month = Calendar.current.component(.month, from: birthDate)
        let day = Calendar.current.component(.day, from: birthDate)
        
        switch (month, day) {
        case (3, 21...31), (4, 1...19): return "♈ 牡羊座"
        case (4, 20...30), (5, 1...20): return "♉ 牡牛座"
        case (5, 21...31), (6, 1...20): return "♊ 双子座"
        case (6, 21...30), (7, 1...22): return "♋ 蟹座"
        case (7, 23...31), (8, 1...22): return "♌ 獅子座"
        case (8, 23...31), (9, 1...22): return "♍ 乙女座"
        case (9, 23...30), (10, 1...22): return "♎ 天秤座"
        case (10, 23...31), (11, 1...21): return "♏ 蠍座"
        case (11, 22...30), (12, 1...21): return "♐ 射手座"
        case (12, 22...31), (1, 1...19): return "♑ 山羊座"
        case (1, 20...31), (2, 1...18): return "♒ 水瓶座"
        case (2, 19...29), (3, 1...20): return "♓ 魚座"
        default: return "不明"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("年齢: \(age)歳")
                    .font(.caption)
                    .bold()
                Spacer()
                Text(zodiacSign)
                    .font(.caption)
                    .foregroundColor(.purple)
            }
            
            Text("生年月日: \(birthDate, formatter: dateFormatter)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}

struct AppointmentSummaryView: View {
    let dateTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("予約詳細")
                .font(.caption)
                .bold()
            
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.orange)
                Text(formattedDateTime)
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(.orange)
                Text("所要時間: 60分")
                    .font(.caption)
                Spacer()
            }
            
            Text(timeUntilAppointment)
                .font(.caption)
                .foregroundColor(.gray)
                .italic()
        }
        .padding(8)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
    
    private var timeUntilAppointment: String {
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date(), to: dateTime)
        
        if let days = components.day, days > 0 {
            return "予約まで\(days)日と\(components.hour ?? 0)時間"
        } else if let hours = components.hour, hours > 0 {
            return "予約まで\(hours)時間\(components.minute ?? 0)分"
        } else if let minutes = components.minute, minutes > 0 {
            return "予約まで\(minutes)分"
        } else {
            return "予約時刻です"
        }
    }
}

struct PeriodSummaryView: View {
    let startDate: Date
    let endDate: Date
    
    private var duration: String {
        let components = Calendar.current.dateComponents([.day], from: startDate, to: endDate)
        let days = components.day ?? 0
        
        if days == 0 {
            return "同日"
        } else if days == 1 {
            return "1日間"
        } else {
            return "\(days)日間"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("プロジェクト期間")
                .font(.caption)
                .bold()
            
            HStack {
                Image(systemName: "calendar.badge.plus")
                    .foregroundColor(.blue)
                Text("\(startDate, formatter: dateFormatter) 〜 \(endDate, formatter: dateFormatter)")
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.blue)
                Text("期間: \(duration)")
                    .font(.caption)
                Spacer()
            }
        }
        .padding(8)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}

struct WorkHoursSummaryView: View {
    let startTime: Date
    let endTime: Date
    
    private var workDuration: String {
        let startHour = Calendar.current.component(.hour, from: startTime)
        let startMinute = Calendar.current.component(.minute, from: startTime)
        let endHour = Calendar.current.component(.hour, from: endTime)
        let endMinute = Calendar.current.component(.minute, from: endTime)
        
        let startTotalMinutes = startHour * 60 + startMinute
        let endTotalMinutes = endHour * 60 + endMinute
        let durationMinutes = endTotalMinutes - startTotalMinutes
        
        let hours = durationMinutes / 60
        let minutes = durationMinutes % 60
        
        if minutes == 0 {
            return "\(hours)時間"
        } else {
            return "\(hours)時間\(minutes)分"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("勤務時間サマリー")
                .font(.caption)
                .bold()
            
            HStack {
                Image(systemName: "clock.badge.checkmark")
                    .foregroundColor(.green)
                Text("\(startTime, formatter: timeFormatter) 〜 \(endTime, formatter: timeFormatter)")
                    .font(.caption)
                Spacer()
            }
            
            HStack {
                Image(systemName: "hourglass")
                    .foregroundColor(.green)
                Text("労働時間: \(workDuration)")
                    .font(.caption)
                Spacer()
            }
            
            if workDuration.contains("8時間") {
                Text("※ 標準的な労働時間です")
                    .font(.caption)
                    .foregroundColor(.green)
                    .italic()
            }
        }
        .padding(8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}

struct ReminderPreviewView: View {
    let reminderTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("リマインダープレビュー")
                .font(.caption)
                .bold()
            
            HStack {
                Image(systemName: "bell.badge")
                    .foregroundColor(.red)
                Text("毎日 \(reminderTime, formatter: timeFormatter) にお知らせします")
                    .font(.caption)
                Spacer()
            }
            
            Text("※ 設定は後で変更できます")
                .font(.caption)
                .foregroundColor(.gray)
                .italic()
        }
        .padding(8)
        .background(Color.red.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
}

struct CustomDatePickerView: View {
    @Binding var selectedDate: Date
    let allowPastDates: Bool
    let use24HourFormat: Bool
    
    private var dateRange: PartialRangeFrom<Date>? {
        allowPastDates ? nil : Date()...
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("カスタム設定適用済み DatePicker")
                .font(.subheadline)
            
            if let range = dateRange {
                DatePicker(
                    "日付時刻",
                    selection: $selectedDate,
                    in: range,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(CompactDatePickerStyle())
            } else {
                DatePicker(
                    "日付時刻",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(CompactDatePickerStyle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("現在の設定:")
                    .font(.caption)
                    .bold()
                
                Text("• 過去の日付: \(allowPastDates ? "許可" : "禁止")")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("• 時刻形式: \(use24HourFormat ? "24時間" : "12時間")")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(6)
        }
    }
}

// MARK: - Complex Example

struct EventSchedulerView: View {
    @State private var eventTitle = ""
    @State private var eventDate = Date()
    @State private var eventDuration: TimeInterval = 3600 // 1 hour
    @State private var isAllDay = false
    @State private var reminder = ReminderOption.fifteenMinutes
    @State private var repeatOption = RepeatOption.never
    
    enum ReminderOption: String, CaseIterable {
        case none = "なし"
        case fifteenMinutes = "15分前"
        case thirtyMinutes = "30分前"
        case oneHour = "1時間前"
        case oneDay = "1日前"
        
        var timeInterval: TimeInterval {
            switch self {
            case .none: return 0
            case .fifteenMinutes: return -15 * 60
            case .thirtyMinutes: return -30 * 60
            case .oneHour: return -60 * 60
            case .oneDay: return -24 * 60 * 60
            }
        }
    }
    
    enum RepeatOption: String, CaseIterable {
        case never = "なし"
        case daily = "毎日"
        case weekly = "毎週"
        case monthly = "毎月"
        case yearly = "毎年"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("イベント作成")
                .font(.subheadline)
                .bold()
            
            // イベントタイトル
            TextField("イベントタイトル", text: $eventTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // 終日イベント
            Toggle("終日", isOn: $isAllDay)
            
            // 日付・時刻
            if isAllDay {
                DatePicker("日付", selection: $eventDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
            } else {
                DatePicker("開始日時", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(CompactDatePickerStyle())
                
                // 継続時間
                HStack {
                    Text("継続時間:")
                    Spacer()
                    Picker("継続時間", selection: $eventDuration) {
                        Text("30分").tag(TimeInterval(30 * 60))
                        Text("1時間").tag(TimeInterval(60 * 60))
                        Text("1.5時間").tag(TimeInterval(90 * 60))
                        Text("2時間").tag(TimeInterval(120 * 60))
                        Text("3時間").tag(TimeInterval(180 * 60))
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            
            // リマインダー
            HStack {
                Text("リマインダー:")
                Spacer()
                Picker("リマインダー", selection: $reminder) {
                    ForEach(ReminderOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // 繰り返し
            HStack {
                Text("繰り返し:")
                Spacer()
                Picker("繰り返し", selection: $repeatOption) {
                    ForEach(RepeatOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            // プレビュー
            EventPreviewView(
                title: eventTitle,
                date: eventDate,
                duration: eventDuration,
                isAllDay: isAllDay,
                reminder: reminder,
                repeatOption: repeatOption
            )
            
            // 作成ボタン
            Button("イベントを作成") {
                // イベント作成処理
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(eventTitle.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(eventTitle.isEmpty)
        }
    }
}

struct EventPreviewView: View {
    let title: String
    let date: Date
    let duration: TimeInterval
    let isAllDay: Bool
    let reminder: EventSchedulerView.ReminderOption
    let repeatOption: EventSchedulerView.RepeatOption
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("イベントプレビュー")
                .font(.caption)
                .bold()
            
            if !title.isEmpty {
                HStack {
                    Image(systemName: "calendar.badge.plus")
                        .foregroundColor(.blue)
                    Text(title)
                        .font(.headline)
                    Spacer()
                }
            }
            
            HStack {
                Image(systemName: isAllDay ? "sun.max" : "clock")
                    .foregroundColor(.orange)
                
                if isAllDay {
                    Text("\(date, formatter: dateFormatter) (終日)")
                        .font(.caption)
                } else {
                    Text("\(date, formatter: dateTimeFormatter) (\(formattedDuration))")
                        .font(.caption)
                }
                
                Spacer()
            }
            
            if reminder != .none {
                HStack {
                    Image(systemName: "bell")
                        .foregroundColor(.red)
                    Text("リマインダー: \(reminder.rawValue)")
                        .font(.caption)
                    Spacer()
                }
            }
            
            if repeatOption != .never {
                HStack {
                    Image(systemName: "repeat")
                        .foregroundColor(.green)
                    Text("繰り返し: \(repeatOption.rawValue)")
                        .font(.caption)
                    Spacer()
                }
            }
        }
        .padding(10)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
    
    private var dateTimeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }
    
    private var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)時間\(minutes)分"
        } else if hours > 0 {
            return "\(hours)時間"
        } else {
            return "\(minutes)分"
        }
    }
}

// MARK: - Preview
#Preview {
    DatePickerExamplesView()
}