import SwiftUI
import ARKit

struct PublisherView: View {
    var sceneView: ARSCNView

    var body: some View {
        ARView(sceneView: self.sceneView)
        .onAppear { self.startARSession() }
        .onDisappear { self.stopARSession() }
    }

    func startARSession() {
        let config = ARWorldTrackingConfiguration()
        self.sceneView.session.run(config)
    }

    func stopARSession() {
        self.sceneView.session.pause()
        self.sceneView.removeFromSuperview()
    }
}
