//
//  HomeView.swift
//  CoreImagePro
//
//  Created by Shah Md Imran Hossain on 29/10/23.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct HomeView: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
}

// MARK: - Methods
extension HomeView {
    func loadImage() {
        guard let inputImage = UIImage(named: "batman") else {
            print("[HomeView] input image load failed")
            return
        }
        
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()
        // sepiaTone - 0 - original image
        // sepiaTone - 1 - full sepiatone image
//        let currentFilter = CIFilter.sepiaTone()
//        let currentFilter = CIFilter.pixellate()
        let currentFilter = CIFilter.crystallize()
//        let currentFilter = CIFilter.twirlDistortion()
        currentFilter.inputImage = beginImage
//        currentFilter.intensity = 1
//        currentFilter.scale = 100
//        currentFilter.radius = 100
        
        let amount = 1.0
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(amount, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(amount * 1000, forKey: kCIInputRadiusKey)
            currentFilter.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(amount * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else {
            print("failed to generate output image")
            return
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            print("output image creation failed")
            return
        }
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    HomeView()
}

