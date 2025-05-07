import SwiftUI

struct HomeView: View {
    @State private var navigateToProfile = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {

                Image("LinguaLensLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                    .padding(.top, 5)

                Button(action: {
                    navigateToProfile = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 26, height: 26)
                            .foregroundColor(.blue)

                        Text("Elif Buse Köprücü")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }

                
                Divider()
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .opacity(1.5)

                Spacer().frame(height: 50)

               
                VStack(spacing: 25) {
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
                        Text("🌍 Çeviri Sonuçları")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.indigo)
                            .cornerRadius(12)
                    }
                    NavigationLink(destination: RestaurantInfoView()) {
                                        Text("🍴 Restoran Bilgisi")
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.orange)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30) 

                Spacer()
            }
            .background(
                NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) {
                    EmptyView()
                }.hidden()
            )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HomeView()
}
