# Running the Sample Application

1. From the terminal, open the base project directory and run `pod install` to install the OpenTok dependency.
2. Open the `TokboxARSample.xcworkspace` workspace file.
3. Generate and enter your **API Key**, **Session ID**, and **Token** into the `constants.swift` file.
4. Run the app from Xcode.
5. Open a web browser to the OpenTok Playground https://tokbox.com/developer/tools/playground/ and join the session to observe the transmission.

# Latency Issue

When running the app on an iPhone 7 Plus, the latency is very noticeable.
We would like to optimize the code to minimize this latency.
We think there can be improvements made to the `ARVideoCapture.swift` file.
Any suggestions or code samples would be very helpful.
