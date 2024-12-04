async function sendToNative(message) {
    console.log("Dart to JS: " + message);
    // We can call C++ functions via the window.Juce object
    try {
        const response = await window.Juce.getNativeFunction('sendToNative')("Slider value changed: " + message);
        if (response) {
            console.log("Response from C++: " + response);
        }
    } catch (error) {
        console.error("Error calling native function: ", error);
    }
}