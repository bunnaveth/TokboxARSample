import SwiftUI
import ARKit

struct PublisherView: View {
    var sceneView: ARSCNView
    @State var message = "To place a point, aim it at the ground and tap on the screen."

    var body: some View {
        ZStack {
            ARView(sceneView: self.sceneView).edgesIgnoringSafeArea(.all)

            Image(systemName: "plus").font(.largeTitle)

            VStack {
                Text(self.message)
                .padding()
                .background(Color.black.opacity(0.5))
                .frame(maxWidth: .infinity)

                Spacer()
            }
        }
        .foregroundColor(.white)
        .onAppear { self.startARSession() }
        .onDisappear { self.stopARSession() }
        .onTapGesture { self.addPoint() }
    }

    func startARSession() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        self.sceneView.session.run(config)
    }

    func stopARSession() {
        self.sceneView.session.pause()
        self.sceneView.removeFromSuperview()
    }

    /// Add a point to the scene
    func addPoint() {
        let hitTest = self.sceneView.hitTest(self.sceneView.center, types: [.existingPlaneUsingGeometry])

        if let column = hitTest.first?.worldTransform.columns.3 {
            let sphere = Sphere(position: SCNVector3(column.x, column.y, column.z))
            self.sceneView.scene.rootNode.addChildNode(sphere)
            self.message = "To place a point, aim it at the ground and tap on the screen."
        } else {
            self.message = "Plane not detected, wave the phone around some more."
        }
    }
}

class Sphere: SCNNode {
    init(position: SCNVector3) {
        super.init()
        self.position = position
        self.geometry = SCNSphere(radius: 0.02)

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        self.geometry?.materials = [material]
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
