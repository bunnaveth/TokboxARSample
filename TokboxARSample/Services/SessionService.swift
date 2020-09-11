import OpenTok
import ARKit

class ARVideoCapture: NSObject, OTVideoCapture {
    let FRAMES_PER_SECOND = 15
    var videoCaptureConsumer: OTVideoCaptureConsumer?
    let sceneView: ARSCNView
    var displayLink: CADisplayLink?
    var capturing = false
    let renderQueue = DispatchQueue(label: "RenderQueue", attributes: .concurrent)

    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
    }

    func initCapture() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.renderFrame))
        self.displayLink?.preferredFramesPerSecond = self.FRAMES_PER_SECOND
    }

    func start() -> Int32 {
        self.capturing = true
        self.displayLink?.add(to: .current, forMode: .common)
        return 0
    }

    func stop() -> Int32 {
        self.capturing = false
        self.displayLink?.remove(from: .current, forMode: .common)
        return 0
    }

    func releaseCapture() {
    }

    func isCaptureStarted() -> Bool {
        self.capturing
    }

    func captureSettings(_ videoFormat: OTVideoFormat) -> Int32 {
        0
    }

    @objc func renderFrame() {
        self.renderQueue.sync {
            if self.capturing,
                let pixelBuffer = self.sceneView.snapshot().cgImage?.pixelBuffer,
                let videoFrame = self.getVideoFrame(pixelBuffer: pixelBuffer)
            {
                CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)

                if let frameData = CVPixelBufferGetBaseAddress(pixelBuffer) {
                    videoFrame.orientation = .up
                    videoFrame.clearPlanes()
                    videoFrame.planes?.addPointer(frameData)
                    self.videoCaptureConsumer?.consumeFrame(videoFrame)
                }

                CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
            }
        }
    }

    func getVideoFrame(pixelBuffer: CVPixelBuffer) -> OTVideoFrame? {
        let videoFormat = OTVideoFormat()

        videoFormat.pixelFormat = .ARGB
        videoFormat.imageWidth = UInt32(CVPixelBufferGetWidth(pixelBuffer))
        videoFormat.imageHeight = UInt32(CVPixelBufferGetHeight(pixelBuffer))
        videoFormat.bytesPerRow = [CVPixelBufferGetBytesPerRow(pixelBuffer)]

        return OTVideoFrame(format: videoFormat)
    }
}

extension CGImage {
    var pixelBuffer: CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.width), Int(self.height), kCVPixelFormatType_32BGRA, nil, &pixelBuffer)

        if status == kCVReturnSuccess, let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)

            let data = CVPixelBufferGetBaseAddress(pixelBuffer)
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)

            let context = CGContext(
                data: data,
                width: Int(self.width),
                height: Int(self.height),
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                space: rgbColorSpace,
                bitmapInfo: bitmapInfo.rawValue
            )
            context?.draw(self, in: CGRect(x: 0, y: 0, width: self.width, height: self.height))

            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)

        }

        return pixelBuffer
    }
}
