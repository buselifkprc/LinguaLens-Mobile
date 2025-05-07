import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer(minLength: 60)

                    Image("LinguaLensLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260)
                        .shadow(radius: 5)

                    VStack(spacing: 20) {
                        NavigationLink(destination: LoginView()) {
                            Text("🔑 Giriş Yap")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }

                        NavigationLink(destination: RegisterView()) {
                            Text("🆕 Kaydol")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 32)

                    Spacer(minLength: 50)
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
