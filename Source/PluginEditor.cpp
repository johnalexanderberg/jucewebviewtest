#include "PluginProcessor.h"
#include "PluginEditor.h"
#include "BinaryData.h"

namespace {
auto streamToVector (juce::InputStream& stream)
{
    std::vector<std::byte> result ((size_t) stream.getTotalLength());
    stream.setPosition (0);
    [[maybe_unused]] const auto bytesRead = stream.read (result.data(), result.size());
    jassert (bytesRead == (ssize_t) result.size());
    return result;
}

const char* getMimeForExtension (const juce::String& extension)
{
    static const std::unordered_map<juce::String, const char*> mimeMap =
        {
            { { "htm"   },  "text/html"                },
            { { "html"  },  "text/html"                },
            { { "txt"   },  "text/plain"               },
            { { "jpg"   },  "image/jpeg"               },
            { { "jpeg"  },  "image/jpeg"               },
            { { "svg"   },  "image/svg+xml"            },
            { { "ico"   },  "image/vnd.microsoft.icon" },
            { { "json"  },  "application/json"         },
            { { "png"   },  "image/png"                },
            { { "css"   },  "text/css"                 },
            { { "map"   },  "application/json"         },
            { { "js"    },  "text/javascript"          },
            { { "woff2" },  "font/woff2"               }
        };

    if (const auto it = mimeMap.find (extension.toLowerCase()); it != mimeMap.end())
        return it->second;

    jassertfalse;
    return "";
}

}
WebviewTestAudioProcessorEditor::WebviewTestAudioProcessorEditor(WebviewTestAudioProcessor& p)
    : AudioProcessorEditor(&p),
    webView {juce::WebBrowserComponent::Options{}.withBackend(juce::WebBrowserComponent::Options::Backend::webview2)
                 .withWinWebView2Options(juce::WebBrowserComponent::Options::WinWebView2{}.withUserDataFolder(juce::File::getSpecialLocation(juce::File::tempDirectory)))
                 .withResourceProvider([this](const auto& url){
                                           return getResource(url);}).withNativeIntegrationEnabled()}
{
    addAndMakeVisible(webView);
    webView.goToURL(webView.getResourceProviderRoot());
    setSize(800, 600);

#if JUCE_DEBUG
    for (int i = 0; i < BinaryData::namedResourceListSize; ++i)
    {
        auto message = "Resource available: " + juce::String(BinaryData::namedResourceList[i]);
        std::cout << message << std::endl;
    }
#endif
}

void WebviewTestAudioProcessorEditor::resized()
{
    webView.setBounds(getLocalBounds());
}

std::optional<juce::WebBrowserComponent::Resource>
    WebviewTestAudioProcessorEditor::getResource(const juce::String& url)
{


    const auto resourceToRetrieve = url == "/" ? "index_html" : url.fromFirstOccurrenceOf("/", false, true);

    int dataSize = 0;
    if (auto* data = BinaryData::getNamedResource(resourceToRetrieve.toRawUTF8(), dataSize)) {
        const auto extension = resourceToRetrieve.fromLastOccurrenceOf("_", false, true);

        return juce::WebBrowserComponent::Resource{
            std::vector<std::byte>(reinterpret_cast<const std::byte*>(data),
                                   reinterpret_cast<const std::byte*>(data + dataSize)),
            getMimeForExtension(extension)};
    }
    return std::nullopt;
}


