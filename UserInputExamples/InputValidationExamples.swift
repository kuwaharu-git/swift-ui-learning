import SwiftUI

// MARK: - Input Validation Examples
// 入力検証とエラーハンドリングの包括的なサンプルファイル

struct InputValidationExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            InputValidationExamplesView()
        }
    }
}

struct InputValidationExamplesView: View {
    // MARK: - State Variables
    @State private var userRegistration = UserRegistrationData()
    @State private var loginData = LoginData()
    @State private var paymentData = PaymentData()
    @State private var profileData = ProfileData()
    
    // フォーム状態
    @State private var showRegistrationAlert = false
    @State private var showLoginAlert = false
    @State private var showPaymentAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // ユーザー登録フォーム（包括的バリデーション）
                    ExampleSection(title: "ユーザー登録フォーム（包括的バリデーション）") {
                        UserRegistrationFormView(
                            data: $userRegistration,
                            showAlert: $showRegistrationAlert
                        )
                    }
                    
                    // ログインフォーム（リアルタイムバリデーション）
                    ExampleSection(title: "ログインフォーム（リアルタイムバリデーション）") {
                        LoginFormView(
                            data: $loginData,
                            showAlert: $showLoginAlert
                        )
                    }
                    
                    // 支払い情報フォーム（高度なバリデーション）
                    ExampleSection(title: "支払い情報フォーム（高度なバリデーション）") {
                        PaymentFormView(
                            data: $paymentData,
                            showAlert: $showPaymentAlert
                        )
                    }
                    
                    // プロフィール設定（条件付きバリデーション）
                    ExampleSection(title: "プロフィール設定（条件付きバリデーション）") {
                        ProfileFormView(data: $profileData)
                    }
                    
                    // 単体バリデーション例
                    ExampleSection(title: "個別バリデーション例") {
                        IndividualValidationExamplesView()
                    }
                }
                .padding()
            }
            .navigationTitle("入力検証Examples")
        }
    }
}

// MARK: - Data Models

struct UserRegistrationData {
    var username = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var phoneNumber = ""
    var birthDate = Date()
    var agreeToTerms = false
    var agreeToNewsletter = false
    
    // バリデーション
    var usernameError: String? {
        if username.isEmpty {
            return "ユーザー名は必須です"
        } else if username.count < 3 {
            return "ユーザー名は3文字以上で入力してください"
        } else if username.count > 20 {
            return "ユーザー名は20文字以下で入力してください"
        } else if !username.allSatisfy({ $0.isLetter || $0.isNumber || $0 == "_" }) {
            return "ユーザー名は英数字とアンダースコアのみ使用可能です"
        }
        return nil
    }
    
    var emailError: String? {
        if email.isEmpty {
            return "メールアドレスは必須です"
        } else if !isValidEmail(email) {
            return "有効なメールアドレスを入力してください"
        }
        return nil
    }
    
    var passwordError: String? {
        if password.isEmpty {
            return "パスワードは必須です"
        } else if password.count < 8 {
            return "パスワードは8文字以上で入力してください"
        } else if !password.contains(where: { $0.isNumber }) {
            return "パスワードには数字を含めてください"
        } else if !password.contains(where: { $0.isUppercase }) {
            return "パスワードには大文字を含めてください"
        }
        return nil
    }
    
    var confirmPasswordError: String? {
        if confirmPassword.isEmpty {
            return "パスワード確認は必須です"
        } else if password != confirmPassword {
            return "パスワードが一致しません"
        }
        return nil
    }
    
    var phoneNumberError: String? {
        if phoneNumber.isEmpty {
            return "電話番号は必須です"
        } else if !isValidPhoneNumber(phoneNumber) {
            return "有効な電話番号を入力してください (例: 090-1234-5678)"
        }
        return nil
    }
    
    var birthDateError: String? {
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        if age < 13 {
            return "13歳以上である必要があります"
        } else if age > 120 {
            return "有効な生年月日を入力してください"
        }
        return nil
    }
    
    var termsError: String? {
        if !agreeToTerms {
            return "利用規約への同意が必要です"
        }
        return nil
    }
    
    var isValid: Bool {
        return usernameError == nil &&
               emailError == nil &&
               passwordError == nil &&
               confirmPasswordError == nil &&
               phoneNumberError == nil &&
               birthDateError == nil &&
               termsError == nil
    }
}

struct LoginData {
    var email = ""
    var password = ""
    var rememberMe = false
    
    var emailError: String? {
        if email.isEmpty {
            return nil // リアルタイムバリデーションでは空の場合はエラーを表示しない
        } else if !isValidEmail(email) {
            return "有効なメールアドレスを入力してください"
        }
        return nil
    }
    
    var passwordError: String? {
        if password.isEmpty {
            return nil // リアルタイムバリデーションでは空の場合はエラーを表示しない
        } else if password.count < 6 {
            return "パスワードは6文字以上で入力してください"
        }
        return nil
    }
    
    var canLogin: Bool {
        return !email.isEmpty && !password.isEmpty && emailError == nil && passwordError == nil
    }
}

struct PaymentData {
    var cardNumber = ""
    var expiryMonth = 1
    var expiryYear = Calendar.current.component(.year, from: Date())
    var cvv = ""
    var cardholderName = ""
    var billingAddress = ""
    var zipCode = ""
    
    var cardNumberError: String? {
        if cardNumber.isEmpty {
            return "カード番号は必須です"
        } else if !isValidCreditCard(cardNumber) {
            return "有効なカード番号を入力してください"
        }
        return nil
    }
    
    var expiryError: String? {
        let currentDate = Date()
        let currentYear = Calendar.current.component(.year, from: currentDate)
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        
        if expiryYear < currentYear || (expiryYear == currentYear && expiryMonth < currentMonth) {
            return "有効期限が過去になっています"
        }
        return nil
    }
    
    var cvvError: String? {
        if cvv.isEmpty {
            return "CVVは必須です"
        } else if cvv.count < 3 || cvv.count > 4 {
            return "CVVは3-4桁で入力してください"
        } else if !cvv.allSatisfy({ $0.isNumber }) {
            return "CVVは数字のみで入力してください"
        }
        return nil
    }
    
    var cardholderNameError: String? {
        if cardholderName.isEmpty {
            return "カード名義人は必須です"
        } else if cardholderName.count < 2 {
            return "カード名義人は2文字以上で入力してください"
        }
        return nil
    }
    
    var zipCodeError: String? {
        if zipCode.isEmpty {
            return "郵便番号は必須です"
        } else if !isValidJapaneseZipCode(zipCode) {
            return "有効な郵便番号を入力してください (例: 123-4567)"
        }
        return nil
    }
    
    var isValid: Bool {
        return cardNumberError == nil &&
               expiryError == nil &&
               cvvError == nil &&
               cardholderNameError == nil &&
               !billingAddress.isEmpty &&
               zipCodeError == nil
    }
}

struct ProfileData {
    var displayName = ""
    var bio = ""
    var website = ""
    var isPublic = true
    var allowNotifications = true
    var profilePicture = ""
    
    var displayNameError: String? {
        if isPublic && displayName.isEmpty {
            return "公開プロフィールには表示名が必要です"
        } else if displayName.count > 50 {
            return "表示名は50文字以下で入力してください"
        }
        return nil
    }
    
    var bioError: String? {
        if bio.count > 500 {
            return "自己紹介は500文字以下で入力してください"
        }
        return nil
    }
    
    var websiteError: String? {
        if !website.isEmpty && !isValidURL(website) {
            return "有効なURLを入力してください"
        }
        return nil
    }
    
    var isValid: Bool {
        return displayNameError == nil &&
               bioError == nil &&
               websiteError == nil
    }
}

// MARK: - Form Views

struct UserRegistrationFormView: View {
    @Binding var data: UserRegistrationData
    @Binding var showAlert: Bool
    @State private var attemptedSubmit = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            // ユーザー名
            ValidatedTextField(
                title: "ユーザー名",
                text: $data.username,
                error: attemptedSubmit ? data.usernameError : nil,
                placeholder: "ユーザー名を入力"
            )
            
            // メールアドレス
            ValidatedTextField(
                title: "メールアドレス",
                text: $data.email,
                error: attemptedSubmit ? data.emailError : nil,
                placeholder: "example@email.com",
                keyboardType: .emailAddress
            )
            
            // パスワード
            ValidatedSecureField(
                title: "パスワード",
                text: $data.password,
                error: attemptedSubmit ? data.passwordError : nil,
                placeholder: "パスワード",
                showStrength: true
            )
            
            // パスワード確認
            ValidatedSecureField(
                title: "パスワード確認",
                text: $data.confirmPassword,
                error: attemptedSubmit ? data.confirmPasswordError : nil,
                placeholder: "パスワードを再入力"
            )
            
            // 電話番号
            ValidatedTextField(
                title: "電話番号",
                text: $data.phoneNumber,
                error: attemptedSubmit ? data.phoneNumberError : nil,
                placeholder: "090-1234-5678",
                keyboardType: .phonePad
            )
            
            // 生年月日
            VStack(alignment: .leading, spacing: 5) {
                Text("生年月日")
                    .font(.headline)
                DatePicker("", selection: $data.birthDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                
                if let error = attemptedSubmit ? data.birthDateError : nil {
                    ErrorMessageView(error: error)
                }
            }
            
            // 利用規約同意
            VStack(alignment: .leading, spacing: 5) {
                Toggle("利用規約に同意する", isOn: $data.agreeToTerms)
                    .toggleStyle(CheckboxToggleStyle())
                
                if let error = attemptedSubmit ? data.termsError : nil {
                    ErrorMessageView(error: error)
                }
            }
            
            // ニュースレター同意
            Toggle("ニュースレターを受け取る（任意）", isOn: $data.agreeToNewsletter)
                .toggleStyle(CheckboxToggleStyle())
            
            // 登録ボタン
            Button("登録") {
                attemptedSubmit = true
                if data.isValid {
                    showAlert = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(data.isValid || !attemptedSubmit ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(attemptedSubmit && !data.isValid)
        }
        .alert("登録完了", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text("ユーザー登録が完了しました！")
        }
    }
}

struct LoginFormView: View {
    @Binding var data: LoginData
    @Binding var showAlert: Bool
    @State private var showPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            // メールアドレス（リアルタイムバリデーション）
            VStack(alignment: .leading, spacing: 5) {
                Text("メールアドレス")
                    .font(.headline)
                
                TextField("メールアドレス", text: $data.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        HStack {
                            Spacer()
                            if !data.email.isEmpty {
                                Image(systemName: data.emailError == nil ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(data.emailError == nil ? .green : .red)
                                    .padding(.trailing, 8)
                            }
                        }
                    )
                
                if let error = data.emailError {
                    ErrorMessageView(error: error)
                }
            }
            
            // パスワード（表示切り替え機能付き）
            VStack(alignment: .leading, spacing: 5) {
                Text("パスワード")
                    .font(.headline)
                
                HStack {
                    if showPassword {
                        TextField("パスワード", text: $data.password)
                    } else {
                        SecureField("パスワード", text: $data.password)
                    }
                    
                    Button(action: { showPassword.toggle() }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if let error = data.passwordError {
                    ErrorMessageView(error: error)
                }
            }
            
            // ログイン状態を保持
            Toggle("ログイン状態を保持", isOn: $data.rememberMe)
            
            // ログインボタン
            Button("ログイン") {
                if data.canLogin {
                    showAlert = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(data.canLogin ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(!data.canLogin)
            
            // 状態表示
            LoginStatusView(data: data)
        }
        .alert("ログイン", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text("ログインしました！")
        }
    }
}

struct PaymentFormView: View {
    @Binding var data: PaymentData
    @Binding var showAlert: Bool
    @State private var attemptedSubmit = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            // カード番号
            ValidatedTextField(
                title: "カード番号",
                text: $data.cardNumber,
                error: attemptedSubmit ? data.cardNumberError : nil,
                placeholder: "1234 5678 9012 3456",
                keyboardType: .numberPad
            )
            .onChange(of: data.cardNumber) { newValue in
                data.cardNumber = formatCreditCardNumber(newValue)
            }
            
            // 有効期限
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("有効期限")
                        .font(.headline)
                    
                    HStack {
                        Picker("月", selection: $data.expiryMonth) {
                            ForEach(1...12, id: \.self) { month in
                                Text(String(format: "%02d", month)).tag(month)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 60)
                        
                        Text("/")
                        
                        Picker("年", selection: $data.expiryYear) {
                            ForEach(Calendar.current.component(.year, from: Date())...(Calendar.current.component(.year, from: Date()) + 10), id: \.self) { year in
                                Text(String(year % 100)).tag(year)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 60)
                        
                        Spacer()
                    }
                    
                    if let error = attemptedSubmit ? data.expiryError : nil {
                        ErrorMessageView(error: error)
                    }
                }
                
                Spacer()
                
                // CVV
                VStack(alignment: .leading, spacing: 5) {
                    Text("CVV")
                        .font(.headline)
                    
                    SecureField("CVV", text: $data.cvv)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                    
                    if let error = attemptedSubmit ? data.cvvError : nil {
                        ErrorMessageView(error: error)
                    }
                }
            }
            
            // カード名義人
            ValidatedTextField(
                title: "カード名義人",
                text: $data.cardholderName,
                error: attemptedSubmit ? data.cardholderNameError : nil,
                placeholder: "TARO YAMADA"
            )
            
            // 請求先住所
            VStack(alignment: .leading, spacing: 5) {
                Text("請求先住所")
                    .font(.headline)
                
                TextField("住所を入力", text: $data.billingAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if attemptedSubmit && data.billingAddress.isEmpty {
                    ErrorMessageView(error: "請求先住所は必須です")
                }
            }
            
            // 郵便番号
            ValidatedTextField(
                title: "郵便番号",
                text: $data.zipCode,
                error: attemptedSubmit ? data.zipCodeError : nil,
                placeholder: "123-4567",
                keyboardType: .numberPad
            )
            .onChange(of: data.zipCode) { newValue in
                data.zipCode = formatZipCode(newValue)
            }
            
            // 決済ボタン
            Button("決済を実行") {
                attemptedSubmit = true
                if data.isValid {
                    showAlert = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(data.isValid || !attemptedSubmit ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(attemptedSubmit && !data.isValid)
            
            PaymentSummaryView(data: data, attemptedSubmit: attemptedSubmit)
        }
        .alert("決済完了", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text("決済が完了しました！")
        }
    }
}

struct ProfileFormView: View {
    @Binding var data: ProfileData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            // 公開設定
            Toggle("プロフィールを公開する", isOn: $data.isPublic)
                .font(.headline)
            
            // 表示名（条件付き必須）
            ValidatedTextField(
                title: "表示名" + (data.isPublic ? " *" : ""),
                text: $data.displayName,
                error: data.displayNameError,
                placeholder: data.isPublic ? "表示名は必須です" : "表示名（任意）"
            )
            
            // 自己紹介
            VStack(alignment: .leading, spacing: 5) {
                Text("自己紹介")
                    .font(.headline)
                
                TextEditor(text: $data.bio)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(data.bioError != nil ? Color.red : Color.gray, lineWidth: 1)
                    )
                
                HStack {
                    if let error = data.bioError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    Text("\(data.bio.count)/500")
                        .font(.caption)
                        .foregroundColor(data.bio.count > 450 ? .red : .gray)
                }
            }
            
            // ウェブサイト
            ValidatedTextField(
                title: "ウェブサイト",
                text: $data.website,
                error: data.websiteError,
                placeholder: "https://example.com",
                keyboardType: .URL
            )
            
            // 通知設定
            if data.isPublic {
                Toggle("フォロー通知を受け取る", isOn: $data.allowNotifications)
            }
            
            // 保存ボタン
            Button("保存") {
                // 保存処理
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(data.isValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .disabled(!data.isValid)
            
            ProfilePreviewView(data: data)
        }
    }
}

struct IndividualValidationExamplesView: View {
    @State private var emailInput = ""
    @State private var phoneInput = ""
    @State private var urlInput = ""
    @State private var numberInput = ""
    @State private var passwordInput = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text("個別バリデーション例")
                .font(.title2)
                .bold()
            
            // メール検証
            ValidationExample(
                title: "メールアドレス検証",
                input: $emailInput,
                placeholder: "email@example.com",
                isValid: isValidEmail(emailInput),
                errorMessage: "有効なメールアドレスを入力してください"
            )
            
            // 電話番号検証
            ValidationExample(
                title: "電話番号検証",
                input: $phoneInput,
                placeholder: "090-1234-5678",
                isValid: isValidPhoneNumber(phoneInput),
                errorMessage: "有効な電話番号を入力してください"
            )
            
            // URL検証
            ValidationExample(
                title: "URL検証",
                input: $urlInput,
                placeholder: "https://example.com",
                isValid: isValidURL(urlInput),
                errorMessage: "有効なURLを入力してください"
            )
            
            // 数値検証
            ValidationExample(
                title: "数値検証（1-100）",
                input: $numberInput,
                placeholder: "50",
                isValid: isValidNumber(numberInput, min: 1, max: 100),
                errorMessage: "1から100の数値を入力してください",
                keyboardType: .numberPad
            )
            
            // パスワード強度
            PasswordStrengthExample(password: $passwordInput)
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
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            content()
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ValidatedTextField: View {
    let title: String
    @Binding var text: String
    let error: String?
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .sentences)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error != nil ? Color.red : Color.clear, lineWidth: 1)
                )
            
            if let error = error {
                ErrorMessageView(error: error)
            }
        }
    }
}

struct ValidatedSecureField: View {
    let title: String
    @Binding var text: String
    let error: String?
    let placeholder: String
    var showStrength: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
            
            SecureField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error != nil ? Color.red : Color.clear, lineWidth: 1)
                )
            
            if showStrength && !text.isEmpty {
                PasswordStrengthIndicator(password: text)
            }
            
            if let error = error {
                ErrorMessageView(error: error)
            }
        }
    }
}

struct ErrorMessageView: View {
    let error: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.caption)
            Text(error)
                .font(.caption)
                .foregroundColor(.red)
        }
    }
}

struct PasswordStrengthIndicator: View {
    let password: String
    
    private var strength: PasswordStrength {
        if password.isEmpty {
            return .none
        } else if password.count < 6 {
            return .weak
        } else if password.count < 8 || !password.contains(where: { $0.isNumber }) {
            return .medium
        } else if password.contains(where: { $0.isNumber }) && 
                  password.contains(where: { $0.isUppercase }) &&
                  password.contains(where: { $0.isLowercase }) &&
                  password.contains(where: { "!@#$%^&*()".contains($0) }) {
            return .veryStrong
        } else if password.contains(where: { $0.isNumber }) && 
                  password.contains(where: { $0.isUppercase }) &&
                  password.contains(where: { $0.isLowercase }) {
            return .strong
        } else {
            return .medium
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("パスワード強度:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(strength.rawValue)
                    .font(.caption)
                    .bold()
                    .foregroundColor(strength.color)
            }
            
            HStack(spacing: 2) {
                ForEach(1...4, id: \.self) { index in
                    Rectangle()
                        .fill(index <= strength.level ? strength.color : Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .cornerRadius(2)
                }
            }
        }
    }
}

enum PasswordStrength: String {
    case none = ""
    case weak = "弱い"
    case medium = "普通"
    case strong = "強い"
    case veryStrong = "とても強い"
    
    var color: Color {
        switch self {
        case .none: return .clear
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        case .veryStrong: return .blue
        }
    }
    
    var level: Int {
        switch self {
        case .none: return 0
        case .weak: return 1
        case .medium: return 2
        case .strong: return 3
        case .veryStrong: return 4
        }
    }
}

struct LoginStatusView: View {
    let data: LoginData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("ログイン状態:")
                .font(.caption)
                .bold()
            
            HStack {
                Image(systemName: data.canLogin ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(data.canLogin ? .green : .red)
                Text(data.canLogin ? "ログイン可能" : "入力情報を確認してください")
                    .font(.caption)
                    .foregroundColor(data.canLogin ? .green : .red)
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct PaymentSummaryView: View {
    let data: PaymentData
    let attemptedSubmit: Bool
    
    var errorCount: Int {
        var count = 0
        if data.cardNumberError != nil { count += 1 }
        if data.expiryError != nil { count += 1 }
        if data.cvvError != nil { count += 1 }
        if data.cardholderNameError != nil { count += 1 }
        if data.billingAddress.isEmpty { count += 1 }
        if data.zipCodeError != nil { count += 1 }
        return count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("入力状況:")
                .font(.caption)
                .bold()
            
            HStack {
                Image(systemName: data.isValid ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(data.isValid ? .green : .orange)
                
                if data.isValid {
                    Text("すべての項目が正しく入力されています")
                        .font(.caption)
                        .foregroundColor(.green)
                } else if attemptedSubmit {
                    Text("\(errorCount)個の項目に問題があります")
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Text("必要な情報を入力してください")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
}

struct ProfilePreviewView: View {
    let data: ProfileData
    
    var body: some View {
        if data.isPublic {
            VStack(alignment: .leading, spacing: 8) {
                Text("プロフィールプレビュー:")
                    .font(.caption)
                    .bold()
                
                VStack(alignment: .leading, spacing: 4) {
                    if !data.displayName.isEmpty {
                        Text(data.displayName)
                            .font(.headline)
                    }
                    
                    if !data.bio.isEmpty {
                        Text(data.bio)
                            .font(.caption)
                            .lineLimit(3)
                    }
                    
                    if !data.website.isEmpty {
                        Link(data.website, destination: URL(string: data.website) ?? URL(string: "https://example.com")!)
                            .font(.caption)
                    }
                }
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(6)
        }
    }
}

struct ValidationExample: View {
    let title: String
    @Binding var input: String
    let placeholder: String
    let isValid: Bool
    let errorMessage: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .bold()
            
            HStack {
                TextField(placeholder, text: $input)
                    .keyboardType(keyboardType)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Image(systemName: input.isEmpty ? "minus.circle" : (isValid ? "checkmark.circle.fill" : "xmark.circle.fill"))
                    .foregroundColor(input.isEmpty ? .gray : (isValid ? .green : .red))
            }
            
            if !input.isEmpty && !isValid {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct PasswordStrengthExample: View {
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("パスワード強度チェック")
                .font(.subheadline)
                .bold()
            
            SecureField("パスワードを入力", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !password.isEmpty {
                PasswordStrengthIndicator(password: password)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("チェック項目:")
                        .font(.caption)
                        .bold()
                    
                    CheckItem(text: "8文字以上", isValid: password.count >= 8)
                    CheckItem(text: "大文字を含む", isValid: password.contains(where: { $0.isUppercase }))
                    CheckItem(text: "小文字を含む", isValid: password.contains(where: { $0.isLowercase }))
                    CheckItem(text: "数字を含む", isValid: password.contains(where: { $0.isNumber }))
                    CheckItem(text: "記号を含む", isValid: password.contains(where: { "!@#$%^&*()".contains($0) }))
                }
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
        }
    }
}

struct CheckItem: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .green : .gray)
                .font(.caption)
            Text(text)
                .font(.caption)
                .foregroundColor(isValid ? .green : .gray)
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 18))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
                .font(.system(size: 14))
        }
    }
}

// MARK: - Validation Functions

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: email)
}

func isValidPhoneNumber(_ phone: String) -> Bool {
    let phoneRegex = "^0\\d{1,4}-\\d{1,4}-\\d{4}$"
    let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegex)
    return phoneTest.evaluate(with: phone)
}

func isValidURL(_ url: String) -> Bool {
    if let url = URL(string: url) {
        return UIApplication.shared.canOpenURL(url)
    }
    return false
}

func isValidNumber(_ numberString: String, min: Int, max: Int) -> Bool {
    guard let number = Int(numberString) else { return false }
    return number >= min && number <= max
}

func isValidCreditCard(_ cardNumber: String) -> Bool {
    let digits = cardNumber.filter { $0.isNumber }
    return digits.count >= 13 && digits.count <= 19
}

func isValidJapaneseZipCode(_ zipCode: String) -> Bool {
    let zipRegex = "^\\d{3}-\\d{4}$"
    let zipTest = NSPredicate(format:"SELF MATCHES %@", zipRegex)
    return zipTest.evaluate(with: zipCode)
}

// MARK: - Formatting Functions

func formatCreditCardNumber(_ input: String) -> String {
    let digits = input.filter { $0.isNumber }
    var formatted = ""
    
    for (index, digit) in digits.enumerated() {
        if index > 0 && index % 4 == 0 {
            formatted += " "
        }
        formatted += String(digit)
        
        if formatted.count >= 19 { // 16 digits + 3 spaces
            break
        }
    }
    
    return formatted
}

func formatZipCode(_ input: String) -> String {
    let digits = input.filter { $0.isNumber }
    
    if digits.count <= 3 {
        return digits
    } else if digits.count <= 7 {
        let prefix = digits.prefix(3)
        let suffix = digits.dropFirst(3)
        return "\(prefix)-\(suffix)"
    } else {
        let prefix = digits.prefix(3)
        let suffix = digits.dropFirst(3).prefix(4)
        return "\(prefix)-\(suffix)"
    }
}

// MARK: - Preview
#Preview {
    InputValidationExamplesView()
}