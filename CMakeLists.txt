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
        COMPANY_NAME "Hypnus"
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
        PRODUCT_NAME "JuceWebviewTest")

target_compile_definitions(${BaseTargetName}
        PUBLIC
        JUCE_WEB_BROWSER=1
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        JUCE_USE_WIN_WEBVIEW2_WITH_STATIC_LINKING=1)

#file(COPY "${CMAKE_CURRENT_SOURCE_DIR}/build/_deps/juce-src/modules/juce_gui_extra/native/javascript/"
#        DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/Gui/public/js/juce/")

file(GLOB_RECURSE GUI_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} Gui/public/*)

foreach(file IN LISTS GUI_FILES)
    get_filename_component(dir ${file} DIRECTORY)
    get_filename_component(name ${file} NAME_WE)
    get_filename_component(ext ${file} EXT)
    string(REPLACE "/" "_" var_name ${dir}/${name}${ext})
    file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${dir})
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${file} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/${dir})
    set(${var_name} ${CMAKE_CURRENT_BINARY_DIR}/${file})
endforeach()

juce_add_binary_data(Resources
        SOURCES
        ${GUI_FILES}
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
