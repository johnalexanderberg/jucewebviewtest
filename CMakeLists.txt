cmake_minimum_required(VERSION 3.22 FATAL_ERROR)

#This is temporarily needed due to a bug in Xcode 15:
if (CMAKE_CXX_COMPILER_ID MATCHES "AppleClang")
    if (NOT CMAKE_CXX_COMPILER_VERSION VERSION_LESS "15.0")
        add_compile_definitions(JUCE_SILENCE_XCODE_15_LINKER_WARNING=1)
        set(CMAKE_EXE_LINKER_FLAGS "-Wl,-ld_classic" CACHE INTERNAL "")
    endif ()
endif ()

#First, we'll add the CMake folder, incase we'll need to find_package later:
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake")

#Compile commands, useful for some IDEs like VS-Code
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

#Minimum MacOS target, set globally
if (CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set(CMAKE_OSX_DEPLOYMENT_TARGET 11.0 CACHE STRING "Minimum OS X deployment version" FORCE)

    #code signing to run on an iOS device:
    #    set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer" CACHE STRING "" FORCE)
    #    set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "XXXXXXXXXX" CACHE STRING "" FORCE)
else ()
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.11" CACHE STRING "Minimum OS X deployment version" FORCE)
endif ()

option(UniversalBinary "Build universal binary for mac" OFF)

if (UniversalBinary)
    set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64" CACHE INTERNAL "")
endif ()

#static linking in Windows
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

#We 'require' that we need juce. If JUCE isn't found, it will revert to what's in
#CMake/Findjuce.cmake, where you can see how JUCE is brought in/configured
find_package(juce REQUIRED)

#By default, we are building the provided plugin/app examples:

project(JuceWebviewTest VERSION 0.1.0)
set (BaseTargetName JuceWebviewTest)

juce_add_plugin("${BaseTargetName}"
        # VERSION ...                               # Set this if the plugin version is different to the project version
        # ICON_BIG ...                              # ICON_* arguments specify a path to an image file to use as an icon for the Standalone
        # ICON_SMALL ...
        COMPANY_NAME "Company"
        IS_SYNTH FALSE
        NEEDS_MIDI_INPUT TRUE
        NEEDS_MIDI_OUTPUT FALSE
        IS_MIDI_EFFECT FALSE
        EDITOR_WANTS_KEYBOARD_FOCUS FALSE
        COPY_PLUGIN_AFTER_BUILD TRUE
        PLUGIN_MANUFACTURER_CODE Juce
        PLUGIN_CODE NPtm
        FORMATS AU VST3 Standalone
        NEEDS_WEBVIEW2 TRUE
        PRODUCT_NAME "JuceFlutterWebTest")

target_compile_definitions(${BaseTargetName}
        PUBLIC
        JUCE_WEB_BROWSER=1
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        JUCE_USE_WIN_WEBVIEW2_WITH_STATIC_LINKING=1)

#file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/build/_deps/juce-src/modules/juce_gui_extra/native/javascript/"
#        DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/Gui/public/js/juce/")

add_custom_target(build_flutter_ui ALL
        COMMAND ${CMAKE_COMMAND} -E echo "Building Flutter web..."
        COMMAND flutter build web
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/Gui/flutter_ui
        COMMAND_EXPAND_LISTS
)

file(GLOB UI_FILES "${Gui}/*")
add_custom_command(
        OUTPUT ${CMAKE_BINARY_DIR}/juce_binarydata_Resources.cpp
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_BINARY_DIR}/juce_binarydata_Resources
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${UI_SOURCE_DIR} ${CMAKE_BINARY_DIR}/juce_binarydata_Resources
        COMMAND ${PROJ_BINARY_DATA_COMPILER} --juce --namespace juce_binarydata ${CMAKE_BINARY_DIR}/juce_binarydata_Resources
        DEPENDS ${UI_FILES}
)

# Link build_flutter_ui target to the main executable
add_dependencies(${BaseTargetName} build_flutter_ui)

# Define the temporary directory where resources will be copied and renamed
set(TEMP_RESOURCE_DIR ${CMAKE_BINARY_DIR}/temp_resources)

# Recursively find all files in the Flutter build directory
file(GLOB_RECURSE FLUTTER_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} Gui/flutter_ui/build/web/*)

# Create a list to hold renamed files for JUCE binary data
set(RENAME_FLUTTER_FILES)

# Loop through the found files
foreach(FILE ${FLUTTER_FILES})

    # Extract the directory part from the file path
    get_filename_component(DIR_PART ${FILE} PATH)

    # Replace "/" with "_" in the directory part
    string(REPLACE "/" "_" DIR_PART "${DIR_PART}")

    # Extract the filename from the path
    get_filename_component(FILE_NAME ${FILE} NAME)

    # Combine directory and filename to create the new file name
    string(CONCAT RENAMED_FILE "${DIR_PART}_${FILE_NAME}")

    # Remove the first part of the filename
    set(PREFIX_TO_REMOVE "Gui_flutter_ui_build_web_")
    string(REPLACE ${PREFIX_TO_REMOVE} "" RENAMED_FILE ${RENAMED_FILE})

    # Define the destination path
    set(DEST_PATH "${TEMP_RESOURCE_DIR}/${RENAMED_FILE}")

    # Copy the file to the temporary folder
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${FILE} ${DEST_PATH} COPYONLY)

    # Add the renamed file to the list for JUCE binary data
    list(APPEND RENAME_FLUTTER_FILES ${DEST_PATH})
    endforeach()

    # Add the renamed files as binary data in JUCE
    juce_add_binary_data(Resources
    SOURCES
    ${RENAME_FLUTTER_FILES}
    )

target_link_libraries(${BaseTargetName} PRIVATE
        Resources
        shared_plugin_helpers
        juce_recommended_config_flags
        juce_recommended_lto_flags
        juce_recommended_warning_flags)

#We're adding the modules and source folders:
add_subdirectory(Modules)
add_subdirectory(Source)

#optionally, we're also adding the unit tests:
option(BUILD_UNIT_TESTS "Build JUCE prototype examples" OFF)

if (BUILD_UNIT_TESTS)
    enable_testing()
    add_subdirectory(Tests)
endif ()

target_link_libraries(${BaseTargetName} PRIVATE Resources)

set(CMAKE_VERBOSE_MAKEFILE ON)
