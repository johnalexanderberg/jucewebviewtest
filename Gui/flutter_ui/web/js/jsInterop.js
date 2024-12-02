function sendToNative(message) {
    console.log("Message from Dart code: " +message);
    // We can call C++ functions from the window.Juce object
    window.Juce.getNativeFunction('sendToNative')("Slider value changed: " +message).then((response) => {
        if (response)
        {
            console.log("Response from C++: " +response);
        }
    });
}