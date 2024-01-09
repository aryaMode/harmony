//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <file_selector_windows/file_selector_windows.h>
#include <rive_common/rive_plugin.h>
#include <tflite_flutter_plus/tflite_flutter_plus_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  RivePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RivePlugin"));
  TfliteFlutterPlusPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TfliteFlutterPlusPluginCApi"));
}
