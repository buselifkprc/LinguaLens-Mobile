import FirebaseAuth
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    init() {
        checkAuthStatus()
    }

    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorMessage = self.getLocalizedErrorMessage(error)
                completion(errorMessage)
            } else {
                Task { @MainActor in
                    self.isLoggedIn = true
                }
                completion(nil)
            }
        }
    }

    func checkAuthStatus() {
        if Auth.auth().currentUser != nil {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }

    private func getLocalizedErrorMessage(_ error: Error) -> String {
        let errCode = AuthErrorCode(_bridgedNSError: error as NSError)

        switch errCode?.code {
        case .invalidEmail:
            return "Geçersiz e-posta adresi."
        case .wrongPassword:
            return "Şifre hatalı."
        case .userNotFound:
            return "Kullanıcı bulunamadı."
        case .userDisabled:
            return "Bu hesap devre dışı bırakılmış."
        case .tooManyRequests:
            return "Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin."
        case .networkError:
            return "Ağ hatası oluştu. Lütfen bağlantınızı kontrol edin."
        case .credentialAlreadyInUse:
            return "Bu kimlik bilgisi başka bir hesapta kullanılıyor."
        case .expiredActionCode:
            return "Bağlantının süresi dolmuş."
        case .invalidActionCode:
            return "Geçersiz işlem kodu."
        default:
            return "Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin."
        }
    }
}
