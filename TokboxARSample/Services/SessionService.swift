import SwiftUI
import OpenTok
import ARKit

/// SessionService is responsible for connecting and publishing to the tokbox session
class SessionService: NSObject, ObservableObject {
    static var `default` = SessionService()

    var session: OTSession?
    @Published var publisher: OTPublisher?
    var publisherSettings: OTPublisherSettings
    var sceneView = ARSCNView()

    override init() {
        /// Here are the settings that Raj suggested, this improves performance on the iPhone XS Max
        self.publisherSettings = OTPublisherSettings()
        self.publisherSettings.cameraResolution = .medium
        self.publisherSettings.cameraFrameRate = .rate30FPS
    }

    /// Whether or not you are publishing the video feed
    var isPublishing: Bool {
        self.publisher?.view != nil
    }

    /// Joins a tokbox session
    func joinSession(apiKey: String, sessionId: String, token: String) {
        if let session = OTSession(apiKey: apiKey, sessionId: sessionId, delegate: self) {
            self.session = session
            session.connect(withToken: token, error: nil)
            print(#function)
        }
    }

    /// Publishes the video feed from the ARScene and transmits it to tokbox
    func publish(session: OTSession) {
        if let publisher = OTPublisher(delegate: self, settings: self.publisherSettings) {
            self.publisher = publisher
            publisher.videoCapture = ARVideoCapture(sceneView: self.sceneView)
            session.publish(publisher, error: nil)
            print(#function)
        }
    }
}

/// Session Events
extension SessionService: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print(#function, session)
        self.publish(session: session)
    }

    func sessionDidDisconnect(_ session: OTSession) {
        print(#function, session)
    }

    func session(_ session: OTSession, didFailWithError error: OTError) {
        print(#function, error)
    }

    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print(#function, stream)
    }

    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print(#function, stream)
    }
}

/// Publisher Events
extension SessionService: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print(#function, error)
    }
}
