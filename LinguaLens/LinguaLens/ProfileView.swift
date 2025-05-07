import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("user_id") var userId: Int?

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var translationSummaries: [String] = []
    @State private var restaurantHistory: [String] = []
    @AppStorage("user_id") var id: Int?
    @State private var userProfile: UserProfile?
    @State private var isLoading = true

    @State private var navigateToSettings = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                
                    Button(action: {
                        navigateToSettings = true
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)

                            Text("\(firstName) \(lastName)")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text(email)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🌍 Çeviri Geçmişi")
                            .font(.headline)

                        ForEach(translationSummaries, id: \.self) { item in
                            HStack {
                                Image(systemName: "text.book.closed")
                                    .foregroundColor(.blue)
                                Text(item)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }

                   
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🍽️ Restoran Geçmişi")
                            .font(.headline)

                        ForEach(restaurantHistory, id: \.self) { place in
                            HStack {
                                Image(systemName: "fork.knife")
                                    .foregroundColor(.orange)
                                Text(place)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }

                    Spacer()
                }
                .padding()
                .navigationTitle("Profil")
                .navigationBarTitleDisplayMode(.inline)

                .background(
                    NavigationLink(destination: AccountSettingsView(), isActive: $navigateToSettings) {
                        EmptyView()
                    }
                    .hidden()
                )
                .onAppear {
                    fetchProfile()
                    fetchTranslations()
                    fetchUserProfile()
                    

                }
            }
        }
    }

   
    func fetchProfile() {
        guard let id = userId,
              let url = URL(string: "http://127.0.0.1:5000/profile/\(id)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print(" Profil verisi alınamadı.")
                return
            }

            DispatchQueue.main.async {
                self.firstName = json["name"] as? String ?? ""
                self.lastName = json["surname"] as? String ?? ""
                self.email = json["email"] as? String ?? ""
            }
        }.resume()
    }

    
    func fetchTranslations() {
        guard let id = userId,
              let url = URL(string: "http://127.0.0.1:5000/translations/\(id)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let array = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                print(" Çeviri verisi alınamadı.")
                return
            }

            DispatchQueue.main.async {
                self.translationSummaries = array.map {
                    "\($0["original_text"] as? String ?? "") → \($0["target_language"] as? String ?? "")"
                }
            }
        }.resume()
    }
    func fetchUserProfile() {
        guard let userId = userId,
              let url = URL(string: "http://127.0.0.1:5000/profile/\(userId)") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
                    DispatchQueue.main.async {
                        self.userProfile = decoded
                        self.isLoading = false
                    }
                } else {
                    print(" JSON decode hatası")
                }
            } else {
                print(" Veri alınamadı: \(error?.localizedDescription ?? "bilinmiyor")")
            }
        }.resume()
    }

}

#Preview {
    ProfileView()
}
