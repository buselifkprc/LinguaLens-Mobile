import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    @AppStorage("user_id") var userId: Int?

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
        /*Text("Kayıt Ol")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.top, 1)
                    .frame(maxWidth: .infinity, alignment: .top) */

                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.top, 10)

                TextField("Ad", text: $firstName)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                TextField("Soyad", text: $lastName)
                    .autocapitalization(.words)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                TextField("E-posta", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                SecureField("Şifre", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                Button(action: {
                    registerUser()
                }) {
                    Text("Kaydol")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                }

                HStack {
                    Text("Zaten hesabınız var mı?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: LoginView()) {
                        Text("Giriş Yap")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }

                Spacer()
            }
            .padding()
            //.navigationBarHidden(true)
            .navigationTitle("Kayıt Ol")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Bilgilendirme"), message: Text(alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
    }

    
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error as NSError? {
                if let errCode = AuthErrorCode(rawValue: error.code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        alertMessage = "Bu e-posta adresiyle zaten bir hesap oluşturulmuş."
                    case .invalidEmail:
                        alertMessage = "Geçersiz e-posta adresi girdiniz."
                    case .weakPassword:
                        alertMessage = "Şifreniz çok zayıf. Lütfen daha güçlü bir şifre girin."
                    default:
                        alertMessage = "Kayıt başarısız: \(error.localizedDescription)"
                    }
                } else {
                    alertMessage = "Bilinmeyen bir hata oluştu: \(error.localizedDescription)"
                }
                showAlert = true
            } else {
                
                backendRegister()
            }
        }
    }

   
    func backendRegister() {
        guard let url = URL(string: "http://127.0.0.1:5000/register") else { return }

        let body: [String: Any] = [
            "name": firstName,
            "surname": lastName,
            "email": email,
            "password": password,
            "profile_image": "" // Şu an boş ileride eklenebilir
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "Backend kayıt hatası: \(error.localizedDescription)"
                } else {
                    alertMessage = "Kayıt başarılı! Hoş geldin, \(firstName)!"
                }
                showAlert = true
            }
        }.resume()
    }
}

#Preview {
    RegisterView()
}
