//
//  FilterImageOperation.swift
//  MultithreadingCourseWork
//
//  Created by Артём Скрипкин on 07.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class FilterImageOperation: Operation {

    convenience init(image: UIImage?, filterName: String) {
        self.init()
        self.originalImage = image
        self.filterName = filterName
    }

    private(set) var outputImage: UIImage?

    private var originalImage: UIImage?

    private var filterName: String?



    override func main() {
        let context = CIContext(options: nil)

        guard let filterNameUnwrapped = filterName, let originalImageUnwrapped = originalImage else { fatalError() }

        guard let filter = CIFilter(name: filterNameUnwrapped) else { return }

        guard let ciOriginalImage = CIImage(image: originalImageUnwrapped) else { return }

        filter.setValue(ciOriginalImage, forKey: kCIInputImageKey)

        guard let ciFilteredImage = filter.outputImage else { return }

        guard let cgOutputImage = context.createCGImage(ciFilteredImage, from: ciFilteredImage.extent) else { return }

        outputImage = UIImage(cgImage: cgOutputImage)
        print("filtered image with \(filterNameUnwrapped)")
    }
}
