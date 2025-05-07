import SwiftUI
import PhotosUI

struct PhotoOCRView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Fotoğraf Yükle")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 20)

            // Fotoğraf önizleme
            if let imageData = selectedImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(12)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay(Text("Henüz görsel seçilmedi").foregroundColor(.gray))
                    .cornerRadius(12)
            }

            // Galeriden fotoğraf seç
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Text("Galeriden Fotoğraf Seç")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Spacer()
        }
        .padding()
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                    print("📸 Fotoğraf verisi alındı.")
                    // OCR işlemine hazır hale gelecek
                }
            }
        }
    }
}

#Preview {
    PhotoOCRView()
}
