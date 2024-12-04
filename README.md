# JUCE Webview + Flutter Web

This is a simple project to test running a Flutter Web UI inside a JUCE WebView and calling C++ functions from Dart code. Its based on the Juce demo and adapted to work with Flutter Web.
To build this project, you need to have the Flutter SDK installed.

---

## How It Works:

### 1. User Interaction with Flutter:
- The app has a slider (`SliderWidget`).
- When the slider is moved, its value gets updated in Flutter, triggering the `_onSliderChanged` function.

---

### 2. Calling JavaScript:
- The slider value is sent to JavaScript using the `dart:js` library.

---

### 3. JavaScript as the Bridge:
- In `interop.js`, the `sendToNative` function acts as the middleman.
- It takes the slider value and sends it to a C++ function exposed by JUCE.
- To make JUCE's C++ functions accessible to JavaScript, the JUCE js library is loaded into the `window` object in `index.html`.
- This setup allows JavaScript in `interop.js` to call C++ functions registered in JUCE via window.Juce.

---

### 4. C++ Side:
- The C++ `sendToNative` function (registered as a "native function" in JUCE) processes the value received from JavaScript.
- C++ can optionally send a response back to JavaScript.

---

### 5. Logging Messages:
- In this example, messages sent back and forth are just printed to the console (C++ logs to the terminal, and the WebView logs to the browser console).

---

## Request Path Parsing in the C++ Backend

1. **Handling Requests**:
   - The WebView sends requests for resources to the C++ backend (e.g., `/assets/images/logo.png` or `/`).

2. **Mapping Requests to Binary Resources**:
   - The C++ backend parses the request paths, converting them to match the renamed binary resource names.  
     Example: `/assets/images/logo.png` → `assets_images_logo_png`.

## Build Step

1. **Flutter Web Build**:
   - CMake automatically builds the Flutter UI by running `flutter build web` during the build process.

2. **Inserting File Paths into Binary Names**:
   - Then renames the flutter files to include their original file paths in the binary names. This is to keep the relationship between requests and resources (while renaming `/` and `.` to `_`).