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

async function gainSliderDragStarted() {
    Juce.getSliderState("gain").sliderDragStarted();
}

async function gainSliderDragEnded() {
    Juce.getSliderState("gain").sliderDragEnded();
}

async function gainSetNormalisedValue(value) {
    Juce.getSliderState("gain").setNormalisedValue(value)
}

async function gainGetNormalisedValue(){
    return Juce.getSliderState("gain").getNormalisedValue();
}

function setGainValueChangedFromDAWListener(onDAWGainValueChanged) {
Juce.getSliderState("gain").valueChangedEvent.addListener(()=>{
    const value = Juce.getSliderState("gain").getNormalisedValue();
    // Call the callback function to update Flutter with the new value
    onDAWGainValueChanged(value)
})}