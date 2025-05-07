import SwiftUI
import PhotosUI
import Vision

struct PhotoOCRView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var ocrText: String = ""
    @State private var navigateToTranslate = false
    @State private var showNoTextAlert = false
    @State private var isCameraPresented = false
    @State private var capturedImage: UIImage? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                /* Text("Fotoğraf Yükle")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top,10) */

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

                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Galeriden Fotoğraf Seç")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button("Kamera ile Fotoğraf Çek") {
                    isCameraPresented = true
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer()

                NavigationLink(
                    destination: TranslateView(originalText: ocrText),
                    isActive: $navigateToTranslate
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Fotoğraf Yükle")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImageData = data
                        performOCR(on: uiImage)
                    }
                }
            }
            .onChange(of: capturedImage) { newImage in
                if let image = newImage {
                    selectedImageData = image.jpegData(compressionQuality: 0.8)
                    performOCR(on: image)
                }
            }
            .alert("Fotoğrafta tanınabilir metin bulunamadı.", isPresented: $showNoTextAlert) {
                Button("Tamam", role: .cancel) { }
            }
            .sheet(isPresented: $isCameraPresented) {
                CameraView(image: $capturedImage)
            }
        }
    }

    func performOCR(on image: UIImage) {
        guard let cgImage = image.cgImage else {
            print("CGImage'e dönüştürülemedi.")
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("OCR hatası: \(error.localizedDescription)")
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation] ?? []
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")

            DispatchQueue.main.async {
                if recognizedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showNoTextAlert = true
                } else {
                    ocrText = recognizedText
                    navigateToTranslate = true
                }
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        do {
            try requestHandler.perform([request])
        } catch {
            print("OCR işlem hatası: \(error.localizedDescription)")
        }
    }
}

#Preview {
    PhotoOCRView()
}
