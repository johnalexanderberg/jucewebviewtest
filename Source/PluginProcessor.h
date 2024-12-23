#pragma once

#include "Parameters.h"

class WebviewTestAudioProcessor : public PluginHelpers::ProcessorBase
{
public:
    WebviewTestAudioProcessor();

    void processBlock(juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    juce::AudioProcessorEditor* createEditor() override;

    void getStateInformation(juce::MemoryBlock& destData) override;
    void setStateInformation(const void* data, int sizeInBytes) override;

    Parameters parameters;

private:
};
