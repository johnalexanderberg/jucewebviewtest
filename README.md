
# JUCE Webview + Flutter Web

This is a simple project to test running a Flutter Web UI inside a JUCE WebView and calling C++ functions from Dart code.

<details>
  <summary>How it works</summary>

### 1. User Interaction with Flutter:
- The app has a slider (`slider_param.dart`). That is bound to a JUCE parameter (`gain`) in the C++ backend.
- It controls the gain parameter aswell as listening to updates from the backend.

---

### 2. Calling JavaScript:
- To make JUCE's C++ functions accessible to JavaScript, the JUCE js library is loaded into the window object in index.html.
- The dart:js library is used to call JavaScript functions from Dart code.
- I didn´t get it to work send callbacks to the JUCE library directly from the dart code. So for now, JuceAdapter.js have some functions acting as a bridge.

---

### 3. C++ Side:
- A JUCE parameter (gain), is exposed to the front end using **gainRelay** and **gainAttachment**.
- A native function (sendToNative) is set up as another way to recieve data from the front end, but is not currently used.
---

## Request Path Parsing in the C++ Backend

1. **Handling Requests**:
    - The WebView sends requests for resources to the C++ backend (e.g., `/assets/images/logo.png` or `/`).

2. **Mapping Requests to Binary Resources**:
    - The C++ backend parses the request paths, converting them to match the renamed binary resource names.  
      Example: `/assets/images/logo.png` → `assets_images_logo_png`.
    - New file types needs to be added to the getMimeType function in `PluginEditor.cpp`. Such as wasm, font types, etc.

## Build Step

1. **Flutter Web Build**:
    - CMake automatically builds the Flutter UI by running `flutter build web` during the build process.

2. **Inserting File Paths into Binary Names**:
    - Cmake renames all the flutter files during the build step to include their original file paths in the binary names.This is to keep the relationship between requests and resources (while renaming `/` and `.` to `_`).
</details>