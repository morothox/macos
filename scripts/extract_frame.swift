import AVFoundation
import CoreGraphics
import ImageIO
import Foundation

let arguments = CommandLine.arguments
guard arguments.count >= 3 else {
    print("Usage: extract_frame <video-path> <output-image-path>")
    exit(1)
}

let videoPath = arguments[1]
let outputPath = arguments[2]

let url = URL(fileURLWithPath: videoPath)
let asset = AVURLAsset(url: url)
let generator = AVAssetImageGenerator(asset: asset)
generator.appliesPreferredTrackTransform = true
generator.requestedTimeToleranceBefore = .zero
generator.requestedTimeToleranceAfter = .zero

do {
    // Extract frame at 1 second to avoid potential black frame at start of video
    let time = CMTime(seconds: 1.0, preferredTimescale: 600)
    let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
    
    let outputURL = URL(fileURLWithPath: outputPath)
    guard let destination = CGImageDestinationCreateWithURL(outputURL as CFURL, "public.png" as CFString, 1, nil) else {
        print("Error: Could not create CGImageDestination")
        exit(1)
    }
    
    CGImageDestinationAddImage(destination, imageRef, nil)
    if CGImageDestinationFinalize(destination) {
        print("Successfully extracted frame to \(outputPath)")
    } else {
        print("Error: Could not finalize image destination")
        exit(1)
    }
} catch {
    print("Error extracting frame: \(error)")
    exit(1)
}
