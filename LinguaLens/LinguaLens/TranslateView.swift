import SwiftUI

struct TranslateView: View {
    var originalText: String
    @State private var translatedText: String = "Çeviri bekleniyor..."
    @State private var isLoading = true
    @State private var targetLanguage = "en"

    let languageOptions = [
        "en": "İngilizce",
        "tr": "Türkçe",
        "de": "Almanca",
        "fr": "Fransızca",
        "es": "İspanyolca",
        "it": "İtalyanca"
    ]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 35) {
                
                Text("Tanımlanan Metin:")
                    .font(.headline)

                ScrollView {
                    Text(originalText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }

                HStack {
                    Text("🌐")
                    Text("Çeviri (\(languageOptions[targetLanguage]!)):")
                }.font(.headline)
                 .foregroundColor(.primary)


                ScrollView {
                    if isLoading {
                        ProgressView("Çeviri yapılıyor...")
                    } else {
                        Text(translatedText)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }
                }

                Spacer()
            }
            
            .padding()
            .navigationTitle("Çeviri Ekranı")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(languageOptions.keys.sorted(), id: \.self) { key in
                            Button(action: {
                                targetLanguage = key
                                isLoading = true
                                translateText()
                            }) {
                                Text(languageOptions[key]!)
                            }
                        }
                    } label: {
                        Label(languageOptions[targetLanguage]!, systemImage: "globe")
                    }
                }
            }
            .onAppear {
                translateText()
            }
        }
    }

    func translateText() {
        guard let url = URL(string: "https://translate.argosopentech.com/translate") else { return }

        let body: [String: Any] = [
            "q": originalText,
            "source": "auto",
            "target": targetLanguage,
            "format": "text"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("JSON oluşturulamadı: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print("İstek hatası: \(error)")
                return
            }

            guard let data = data else {
                print("Veri alınamadı")
                return
            }

            if let result = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.translatedText = result.translatedText
                    print("Çeviri: \(result.translatedText)")
                }
            } else {
                print("Yanıt çözümlenemedi")
                print(String(data: data, encoding: .utf8) ?? "veri çözümlenemedi")
            }
        }.resume()
    }
}

struct TranslationResponse: Codable {
    let translatedText: String
}

#Preview {
    TranslateView(originalText: "Merhaba! Bugün menüde pizza ve ayran var.")
}
