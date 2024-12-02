function sendToJs(message) {
    console.log("Message from Dart to JS:", message);
    // You can do something with JUCE's API here
    window.Juce.getNativeFunction('sendToNative')("Message from JS to C++").then((response) => {
        console.log(response);
    });
}