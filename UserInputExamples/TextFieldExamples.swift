import SwiftUI

// MARK: - TextField Examples
// テキスト入力の様々なパターンを示すサンプルファイル

struct TextFieldExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            TextFieldExamplesView()
        }
    }
}

struct TextFieldExamplesView: View {
    // MARK: - State Variables
    @State private var basicText = ""
    @State private var placeholderText = ""
    @State private var password = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var numberText = ""
    @State private var decimalNumber = ""
    @State private var multilineText = ""
    @State private var limitedText = ""
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 基本的なTextField
                    ExampleSection(title: "基本的なTextField") {
                        TextField("名前を入力してください", text: $basicText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !basicText.isEmpty {
                            Text("入力内容: \(basicText)")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    
                    // プレースホルダーのカスタマイズ
                    ExampleSection(title: "プレースホルダーのスタイリング") {
                        TextField("", text: $placeholderText, prompt: Text("カスタムプロンプト").foregroundColor(.blue))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // パスワード入力
                    ExampleSection(title: "パスワード入力 (SecureField)") {
                        SecureField("パスワードを入力", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        // パスワード強度インジケーター
                        PasswordStrengthView(password: password)
                    }
                    
                    // メールアドレス入力
                    ExampleSection(title: "メールアドレス入力") {
                        TextField("example@email.com", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !email.isEmpty {
                            EmailValidationView(email: email)
                        }
                    }
                    
                    // 電話番号入力
                    ExampleSection(title: "電話番号入力") {
                        TextField("090-1234-5678", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: phoneNumber) { newValue in
                                // 電話番号のフォーマット処理
                                phoneNumber = formatPhoneNumber(newValue)
                            }
                    }
                    
                    // 数値入力（整数）
                    ExampleSection(title: "数値入力（整数）") {
                        TextField("整数を入力", text: $numberText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: numberText) { newValue in
                                // 数値のみ許可
                                numberText = newValue.filter { $0.isNumber }
                            }
                        
                        if let number = Int(numberText), !numberText.isEmpty {
                            Text("入力された数値: \(number)")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                    
                    // 数値入力（小数）
                    ExampleSection(title: "数値入力（小数）") {
                        TextField("小数を入力", text: $decimalNumber)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if let number = Double(decimalNumber), !decimalNumber.isEmpty {
                            Text("入力された数値: \(number, specifier: "%.2f")")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                    
                    // 複数行テキスト
                    ExampleSection(title: "複数行テキスト (TextEditor)") {
                        TextEditor(text: $multilineText)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        
                        Text("文字数: \(multilineText.count)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // 文字数制限
                    ExampleSection(title: "文字数制限（最大20文字）") {
                        TextField("20文字まで入力可能", text: $limitedText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: limitedText) { newValue in
                                if newValue.count > 20 {
                                    limitedText = String(newValue.prefix(20))
                                }
                            }
                        
                        HStack {
                            Text("\(limitedText.count)/20")
                                .font(.caption)
                                .foregroundColor(limitedText.count > 15 ? .red : .gray)
                            Spacer()
                        }
                    }
                    
                    // 検索フィールド
                    ExampleSection(title: "検索フィールド") {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("検索...", text: $searchText)
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // カスタムスタイルのTextField
                    ExampleSection(title: "カスタムスタイル") {
                        CustomStyledTextField(text: $basicText, placeholder: "カスタムスタイル")
                    }
                }
                .padding()
            }
            .navigationTitle("TextField Examples")
        }
    }
    
    // 電話番号フォーマット関数
    private func formatPhoneNumber(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        
        if digits.count <= 3 {
            return digits
        } else if digits.count <= 7 {
            let first = digits.prefix(3)
            let second = digits.dropFirst(3)
            return "\(first)-\(second)"
        } else if digits.count <= 11 {
            let first = digits.prefix(3)
            let second = digits.dropFirst(3).prefix(4)
            let third = digits.dropFirst(7)
            return "\(first)-\(second)-\(third)"
        } else {
            let first = digits.prefix(3)
            let second = digits.dropFirst(3).prefix(4)
            let third = digits.dropFirst(7).prefix(4)
            return "\(first)-\(second)-\(third)"
        }
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
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content()
        }
    }
}

struct PasswordStrengthView: View {
    let password: String
    
    var strength: PasswordStrength {
        if password.isEmpty {
            return .none
        } else if password.count < 6 {
            return .weak
        } else if password.count < 8 || !password.contains(where: { $0.isNumber }) {
            return .medium
        } else if password.contains(where: { $0.isNumber }) && 
                  password.contains(where: { $0.isUppercase }) &&
                  password.contains(where: { $0.isLowercase }) {
            return .strong
        } else {
            return .medium
        }
    }
    
    var body: some View {
        if !password.isEmpty {
            HStack {
                Text("パスワード強度:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(strength.rawValue)
                    .font(.caption)
                    .foregroundColor(strength.color)
                    .bold()
                
                Spacer()
            }
        }
    }
}

enum PasswordStrength: String {
    case none = ""
    case weak = "弱い"
    case medium = "普通"
    case strong = "強い"
    
    var color: Color {
        switch self {
        case .none: return .clear
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }
}

struct EmailValidationView: View {
    let email: String
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    var body: some View {
        HStack {
            Image(systemName: isValidEmail ? "checkmark.circle" : "xmark.circle")
                .foregroundColor(isValidEmail ? .green : .red)
            
            Text(isValidEmail ? "有効なメールアドレス" : "無効なメールアドレス")
                .font(.caption)
                .foregroundColor(isValidEmail ? .green : .red)
            
            Spacer()
        }
    }
}

struct CustomStyledTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: text.isEmpty ? 1 : 2)
            )
            .scaleEffect(text.isEmpty ? 1.0 : 1.02)
            .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
    }
}

// MARK: - Preview
#Preview {
    TextFieldExamplesView()
}