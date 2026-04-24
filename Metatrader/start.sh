#!/bin/bash
# Copyright 2000-2026, MetaQuotes Ltd.

# MetaTrader and WebView2 download urls
URL_MT5="https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe"
URL_WEBVIEW="https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/f2910a1e-e5a6-4f17-b52d-7faf525d17f8/MicrosoftEdgeWebview2Setup.exe"

# Wine version to install: stable or devel
WINE_VERSION="staging"

# Prepare versions
. /etc/os-release

echo OS: $NAME $VERSION_ID

echo Download MetaTrader and WebView2 Runtime
curl $URL_MT5 --output mt5setup.exe
curl $URL_WEBVIEW --output webview2.exe

echo Set environment to Windows 11
WINEPREFIX=~/.mt5 winecfg -v=win11

if [ -e "/config/.webview_installed" ]; then
    echo "WebView2 Runtime is already installed."
else
    echo "Install WebView2 Runtime"
    WINEPREFIX=~/.mt5 wine webview2.exe /silent /install
    touch /config/.webview_installed
fi

if [ -e "/config/.mt5/drive_c/Program Files/MetaTrader 5/terminal64.exe" ]; then
    echo "MetaTrader 5 is already installed."
else
    echo "Install MetaTrader 5"
    WINEPREFIX=~/.mt5 wine mt5setup.exe /auto
fi

echo "All done!"

wine "/config/.mt5/drive_c/Program Files/MetaTrader 5/terminal64.exe"