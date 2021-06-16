import SwiftUI
import ARKit

struct SessionView: View {
    @EnvironmentObject var sessionService: SessionService

    let apiKey = "45752712"
    let sessionId = "2_MX40NTc1MjcxMn5-MTYyMzg3NDI4MTg0M34vMU85TXVHaTZTTGdHTlJZaFRlQUU5VmF-fg"
    let token = "T1==cGFydG5lcl9pZD00NTc1MjcxMiZzaWc9MDdkMjBiY2VmZTk5NzVkZjIxMzE3OTY3YThiMWQ4Y2Y0Mjc0ODJkYzpzZXNzaW9uX2lkPTJfTVg0ME5UYzFNamN4TW41LU1UWXlNemczTkRJNE1UZzBNMzR2TVU4NVRYVkhhVFpUVEdkSFRsSlphRlJsUVVVNVZtRi1mZyZjcmVhdGVfdGltZT0xNjIzODc0MjgyJm5vbmNlPTAuMzQxMzU2MjIzNjMwNTA1JnJvbGU9bW9kZXJhdG9yJmV4cGlyZV90aW1lPTE2MjM5NjA2ODImaW5pdGlhbF9sYXlvdXRfY2xhc3NfbGlzdD0="

    var body: some View {
        ZStack {
            if self.sessionService.isPublishing {
                PublisherView(sceneView: self.sessionService.sceneView)
            } else {
                Button("Join Session") {
                    self.sessionService.joinSession(
                        apiKey: self.apiKey,
                        sessionId: self.sessionId,
                        token: self.token
                    )
                }
            }
        }
    }
}
