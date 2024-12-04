# JUCE Webview + Flutter Web

This is a simple project to test running a Flutter Web UI inside a JUCE WebView and calling C++ functions from Dart code.

---

## How It Works:

### 1. User Interaction with Flutter:
- The app has a slider (`SliderWidget`).
- When the slider is moved, its value gets updated in Flutter, triggering the `_onSliderChanged` function.

---

### 2. Calling JavaScript:
- The updated slider value is sent to JavaScript using the `dart:js` library.

---

### 3. JavaScript as the Bridge:
- In `interop.js`, the `sendToNative` function acts as the middleman.
- It takes the slider value from Dart and sends it to a C++ function exposed by JUCE.
- To make JUCE's C++ functions accessible to JavaScript, the JUCE library is loaded into the `window` object via the `index.html`.
- This setup allows JavaScript in `interop.js` to call C++ functions registered in JUCE via window.Juce.

---

### 4. C++ Side:
- The C++ `sendToNative` function (registered as a "native function" in JUCE) processes the value received from JavaScript.
- C++ can optionally send a response back to JavaScript.

---

### 5. Logging Messages:
- In this example, messages sent back and forth are just printed to the console (C++ logs to the terminal, and the WebView logs to the browser console).
- We also log resources and requests.

---

## Request Path Parsing in the C++ Backend

1. **Handling Requests**:
   - The WebView sends requests for resources to the C++ backend (e.g., `/assets/images/logo.png` or `/`).

2. **Mapping Requests to Binary Resources**:
   - The C++ backend parses the request paths, converting them to match the renamed binary resource names.  
     Example: `/assets/images/logo.png` → `assets_images_logo_png`.

3. **Serving Resources**:
   - The backend retrieves and serves the correct binary data for each request, determining the MIME type based on the file extension (e.g., `.png` → `image/png`).

---

## Build Step (CMake Handles Flutter Build and File Renaming)

1. **Flutter Web Build via CMake**:
   - CMake automatically builds the Flutter UI by running `flutter build web` during the build process.

2. **Injecting File Paths into Binary Names**:
   - During the build process, CMake renames the files to include their original file paths in the binary names. This helps:
      - Preserve the relationship between requests and resources (while renaming `/` and `.` to `_`).
      - Ensure each file has a unique name.

3. **Embedding Resources into JUCE**:
   - These renamed files are then compiled into JUCE binary data, making them available for the C++ application.

---
