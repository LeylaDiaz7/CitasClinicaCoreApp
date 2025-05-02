import UIKit
import ImageIO
import MobileCoreServices

// MARK: - UIImageView+GIF
extension UIImageView {
    func loadGif(name: String) {
        DispatchQueue.global().async {
            guard let path = Bundle.main.path(forResource: name, ofType: "gif"),
                  let data = NSData(contentsOfFile: path),
                  let source = CGImageSourceCreateWithData(data, nil) else { return }

            var images = [UIImage]()
            var duration: Double = 0
            let count = CGImageSourceGetCount(source)

            for i in 0..<count {
                if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage(cgImage: cgImage))

                    // Leer el tiempo de cada frame
                    if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any],
                       let gifDict = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
                       let frameDuration = gifDict[kCGImagePropertyGIFUnclampedDelayTime] as? Double ?? gifDict[kCGImagePropertyGIFDelayTime] as? Double {
                        duration += frameDuration
                    }
                }
            }

            DispatchQueue.main.async {
                self.animationImages = images
                self.animationDuration = duration
                self.startAnimating()
            }
        }
    }
}
