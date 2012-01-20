# ChildBrowser plugin for PhoneGap

This is a prototype of a cross-platform ChildBrowser plugin for plugin. It will
initially support Android, iOS and BlackBerry; @purplecabbage's WinPhone plugin
will be included at a later date.

## The ChildBrowser

ChildBrowser allows you display external webpages from within your PhoneGap
app. An obvious use case: having an external link in your app, displaying the
contents to the user without exiting or hijacking your app entirely.

## API

> showWebPage

    window.plugins.ChildBrowser.showWebPage(url, [options]);

> close

    window.plugins.ChildBrowser.close();
