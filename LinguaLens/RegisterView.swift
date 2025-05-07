import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var registrationSuccess = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Hesap Oluştur")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)

                Group {
                    TextField("Ad", text: $firstName)
                    TextField("Soyad", text: $lastName)
                    TextField("E-posta", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Şifre", text: $password)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button(action: registerUser) {
                    Text("Kayıt Ol")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $registrationSuccess) {
                HomeView() // Giriş sonrası yönlendirilecek ekran
            }
        }
    }

    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.registrationSuccess = true
            }
        }
    }
}
