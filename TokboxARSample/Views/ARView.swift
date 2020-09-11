import SwiftUI
import ARKit

/// Converts an ARSCNView to a SwiftUI View
struct ARView: UIViewRepresentable {
    var sceneView: ARSCNView

    func makeUIView(context: Context) -> ARSCNView {
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [.showFeaturePoints]
        return self.sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) { }
}
