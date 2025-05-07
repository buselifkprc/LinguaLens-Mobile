import SwiftUI
import FirebaseAuth

struct AccountSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showImagePicker = false
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill")
    @State private var newPassword: String = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showDeleteConfirm = false
    @State private var navigateToWelcome = false

    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("Profil Fotoğrafı")) {
                    HStack {
                        profileImage?
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .foregroundColor(.gray)

                        Button("Fotoğraf Seç") {
                            showImagePicker = true
                        }
                    }
                }

                
                Section(header: Text("Hesap Bilgisi")) {
                    Text(Auth.auth().currentUser?.email ?? "bilgi yok")
                }

                
                Section(header: Text("Şifreyi Değiştir")) {
                    HStack {
                        if isPasswordVisible {
                            TextField("Yeni Şifre", text: $newPassword)
                                .autocapitalization(.none)
                        } else {
                            SecureField("Yeni Şifre", text: $newPassword)
                        }

                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }

                    Button("Şifreyi Güncelle") {
                        updatePassword()
                    }
                }


                Section {
                    Button("Çıkış Yap") {
                        alertMessage = "Çıkış yapıldı. Giriş ekranına yönlendiriliyorsunuz..."
                        showAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            do {
                                try Auth.auth().signOut()
                                navigateToWelcome = true
                            } catch {
                                alertMessage = "Çıkış yapılamadı: \(error.localizedDescription)"
                                showAlert = true
                            }
                        }
                    }
                    .foregroundColor(.red)
                }

               
                Section {
                    Button("Hesabı Kalıcı Olarak Sil") {
                        showDeleteConfirm = true
                    }
                    .foregroundColor(.red)
                }
            }
            
            .navigationTitle("Hesap Ayarları")
            .navigationBarTitleDisplayMode(.inline)

            .sheet(isPresented: $showImagePicker) {
                Text("Görsel seçme özelliği yakında")
                    .font(.headline)
            }

            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Bilgilendirme"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Tamam"))
                )
            }

            .alert(isPresented: $showDeleteConfirm) {
                Alert(
                    title: Text("Hesabı Sil"),
                    message: Text("Bu işlem geri alınamaz. Emin misiniz?"),
                    primaryButton: .destructive(Text("Sil"), action: {
                        deleteAccount()
                    }),
                    secondaryButton: .cancel()
                )
            }
        }
    }

   
    func updatePassword() {
        guard newPassword.count >= 6 else {
            alertMessage = "Şifre en az 6 karakter olmalıdır."
            showAlert = true
            return
        }

        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                alertMessage = "Şifre güncellenemedi: \(error.localizedDescription)"
            } else {
                alertMessage = "Şifre başarıyla güncellendi."
                newPassword = ""
            }
            showAlert = true
        }
    }

    
    func deleteAccount() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                alertMessage = "Hesap silinemedi: \(error.localizedDescription)"
                showAlert = true
            } else {
                alertMessage = "Hesap silindi. Giriş ekranına yönlendiriliyorsunuz..."
                showAlert = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    navigateToWelcome = true
                }
            }
        }
    }
}

#Preview {
    AccountSettingsView()
}
