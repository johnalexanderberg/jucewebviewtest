# JUCE Webview + Flutter web

This is a simple project to test running a Flutter Web UI inside a JUCE WebView and call C++ functions from the Dart code.

---

## How It Works:

### 1. User Interaction with Flutter:
- The app features a slider (`SliderWidget`).
- When the user moves the slider, the value is updated in Flutter, triggering the `_onSliderChanged` function.

---

### 2. Calling JavaScript:
- The updated slider value is sent to JavaScript using the `dart:js` library.
- This happens via the `sendToNative` function, defined in the JavaScript file (`interop.js`).

---

### 3. JavaScript as the Bridge:
- In `interop.js`, the `sendToNative` function serves as an intermediate step.
- It receives the slider value from Dart and forwards it to a C++ function exposed by JUCE.
- The JUCE-native functions are exposed to the JavaScript runtime via the `window.Juce` object in the `index.html` file.
- This makes it possible for the `interop.js` file to call C++ functions registered in JUCE.
---

### 4. Native C++ Execution:
- The `sendToNative` function in C++ (registered as a "native function" in JUCE) processes the value received from JavaScript.
- C++ can optionally send a response back to JavaScript.

---

### 5. Logging Messages:
- In this example, messages sent back and forth are just printed to the console (C++ logs to the terminal, and the WebView logs to the browser console).

---
