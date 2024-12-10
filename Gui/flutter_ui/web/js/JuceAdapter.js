async function sendToNative(message) {
    console.log("Dart to JS: " + message);
    try {
        const response = await window.Juce.getNativeFunction('sendToNative')("Slider value changed: " + message);
        if (response) {
            console.log("Response from C++: " + response);
        }
    } catch (error) {
        console.error("Error calling native function: ", error);
    }
}

function sliderDragStarted(parameterID) {
    Juce.getSliderState(parameterID).sliderDragStarted();
}

function sliderDragEnded(parameterID) {
    Juce.getSliderState(parameterID).sliderDragEnded();
}

function setSliderNormalisedValue(parameterID, value) {
    Juce.getSliderState(parameterID).setNormalisedValue(value)
}

function getSliderNormalisedValue(parameterID){
    return Juce.getSliderState(parameterID).getNormalisedValue();
}

function addSliderListener(parameterID, callback) {
    Juce.getSliderState(parameterID).valueChangedEvent.addListener( ()=> {
        const value = Juce.getSliderState(parameterID).getNormalisedValue();
        callback(value)
    })}
