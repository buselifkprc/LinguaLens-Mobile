import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.purple)
                    .padding(.top, 20)

                NavigationLink(destination: PhotoOCRView()) {
                    Text("📸 Fotoğraf Yükle ve Tanı")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                }

                NavigationLink(destination: TranslateView(originalText: "OCR'dan gelen metin")) {
                    Text("🌐 Çeviri Sonuçları")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }

                /*
                NavigationLink(destination: RestaurantInfoView()) {
                    Text("🍽️ Restoran Bilgisi")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                */

                Spacer()
            }
            .padding()
            .navigationTitle("LinguaLens")
            /*
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                    }
                }
            }
            */
        }
    }
}

#Preview {
    HomeView()
}
