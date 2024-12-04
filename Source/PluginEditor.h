#pragma once

#include "PluginProcessor.h"
#include <juce_gui_extra/juce_gui_extra.h>

class WebviewTestAudioProcessorEditor : public juce::AudioProcessorEditor
{
public:
    explicit WebviewTestAudioProcessorEditor(WebviewTestAudioProcessor&);

private:
    std::optional<juce::WebBrowserComponent::Resource> getResource(const juce::String& url);
    void resized() override;
    juce::WebSliderRelay gainRelay;
    juce::WebSliderParameterAttachment gainAttachment;
    juce::WebBrowserComponent webView;


};
