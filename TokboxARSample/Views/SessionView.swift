import SwiftUI
import ARKit

struct SessionView: View {
    @EnvironmentObject var sessionService: SessionService

    let apiKey = "45752712"
    let sessionId = "2_MX40NTc1MjcxMn5-MTU5OTgzNjAyNjg4N35JMXRlQTdpZndCNjVDZzNJNSt5RDBVMjh-fg"
    let token = "T1==cGFydG5lcl9pZD00NTc1MjcxMiZzaWc9NzE3ZDk4MTAxZGMwOTM0ZDIwMDkzN2JlYjFhZjVjODQ5MGE4NzQ2YjpzZXNzaW9uX2lkPTJfTVg0ME5UYzFNamN4TW41LU1UVTVPVGd6TmpBeU5qZzROMzVKTVhSbFFUZHBabmRDTmpWRFp6TkpOU3Q1UkRCVk1qaC1mZyZjcmVhdGVfdGltZT0xNTk5ODM2MDI3Jm5vbmNlPTAuMTU3MzE5MjcwMjU5Mjk1Mzcmcm9sZT1tb2RlcmF0b3ImZXhwaXJlX3RpbWU9MTYwMjQyODAyNyZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="

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
