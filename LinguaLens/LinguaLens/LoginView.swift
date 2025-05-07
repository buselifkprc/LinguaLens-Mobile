import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showResetAlert = false
    @State private var loginErrorMessage: String? = nil
    @AppStorage("user_id") var userId: Int?

    var body: some View {
        NavigationView {
            if authViewModel.isLoggedIn && userId != nil {
                HomeView()
            } else {
                VStack(spacing: 25) {
                    /* Text("Giriş yap")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.top, 1)
                        .frame(maxWidth: .infinity, alignment: .top) */

                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .padding(.top, 10)

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

                    Button {
                        showResetAlert = true
                    } label: {
                        Text("Şifremi Unuttum")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.bottom, 5)
                    }
                    .alert(isPresented: $showResetAlert) {
                        Alert(
                            title: Text("Şifre Sıfırlama"),
                            message: Text("Şifre sıfırlama bağlantısı e-posta ile gönderilecek."),
                            dismissButton: .default(Text("Tamam"))
                        )
                    }

                    Button {
                        authViewModel.login(email: email, password: password) { error in
                            if let error = error {
                                loginErrorMessage = error
                            } else {
                                loginErrorMessage = nil
                                backendLogin(email: email, password: password)
                            }
                        }
                    } label: {
                        Text("Giriş Yap")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    if let errorMessage = loginErrorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Button {
                        print("Google ile Giriş yapılacak")
                    } label: {
                        Text("Google ile Giriş Yap")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(8)
                    }

                    Button {
                        print("Apple ile Giriş yapılacak")
                    } label: {
                        Text("Apple ile Giriş Yap")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(8)
                    }

                    HStack {
                        Text("Hesabınız yok mu?")
                            .foregroundColor(.gray)
                        NavigationLink(destination: RegisterView()) {
                            Text("Kayıt Ol")
                                .foregroundColor(.blue)
                                .bold()
                        }
                    }

                    Spacer()
                }
                .padding()
                .navigationBarHidden(true)
                /*.navigationTitle("Giriş Yap")
                .navigationBarTitleDisplayMode(.inline)*/
            }
        }
    }

    func backendLogin(email: String, password: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Backend hata: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else { return }

            if httpResponse.statusCode == 200,
               let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let id = json["user_id"] as? Int {
                DispatchQueue.main.async {
                    self.userId = id
                    print("Backend user_id: \(id)")
                }
            } else {
                print("Backend login başarısız. Status code: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}

#Preview {
    LoginView()
}
