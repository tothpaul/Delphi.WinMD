# Delphi WinMD Parser

This Delphi application allows you to read [Windows Medatadata (WinMD) files](https://learn.microsoft.com/en-us/uwp/winrt-cref/winmd-files).

You can find some winMD files in C:\Windows\System32\WinMetadata

But the main purpose of this project is to read [Windows.Win32.winmd](https://www.nuget.org/packages/Microsoft.Windows.SDK.Win32Metadata/), the metafile of Win32 API, like [LLSpy](https://github.com/microsoft/win32metadata) but to generate Delphi files.

At this time, there's no Delphi code generation, only a Table browser

![screenshot](Delphi.WinMD.PNG)