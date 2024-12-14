
# JUCE Webview + Flutter Web

This is a simple project to test running a Flutter Web UI inside a JUCE WebView and calling C++ functions from Dart code.

<details>
  <summary>How it works</summary>

### 1. User Interaction with Flutter:
- The app has a slider (`slider_param.dart`). That is bound to a JUCE parameter (`gain`) in the C++ backend.

---

### 2. Calling JavaScript:
- To make JUCE's C++ functions accessible to JavaScript, the JUCE js library is loaded into the window object in index.html.
- The dart:js library is used to call JavaScript functions from Dart code.

---

### 3. C++ Side:
- A JUCE parameter (gain), is connected to the front end using **gainRelay** and **gainAttachment**.
- A native function (sendToNative) processes values received from JavaScript (not currently used).
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
    - Then renames the flutter files to include their original file paths in the binary names.This is to keep the relationship between requests and resources (while renaming `/` and `.` to `_`).
    - New file types needs to be added to the getMimeType function in `juce_WebviewFlutter.cpp`. Such as wasm, woff2, etc.
</details>