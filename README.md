# ChildBrowser plugin for PhoneGap

This is a prototype of a cross-platform ChildBrowser PhoneGap plugin.

In order of implementation, this will support Android, iOS, BlackBerry and
Windows Phone, based on existing implementations in this repo. For production
use, those existing implementations should be favored over this one.

The goal is for a single JavaScript file to be usable on all supported
platforms, and the native code to be installed in a project through a separate
script.

## The Structure

    plugin.xml
    -- src
      -- android
        -- ChildBrowser.java
      -- ios
        -- ChildBrowser.bundle
          -- arrow_left.png
          -- arrow_left@2x.png
          -- ...
        -- ChildBrowserCommand.h
        -- ChildBrowserCommand.m
        -- etc
    -- www
      -- childbrowser.js
      -- childbrowser
        -- icon_arrow_left.png
        -- icon_arrow_right.png
        -- ...

## plugin.xml

The plugin.xml file is loosely based on the W3C's Widget Config spec.

It is in XML to facilitate transfer of nodes from this cross platform manifest
to native XML manifests (AndroidManifest.xml, App-Info.plist, config.xml (BB)).

A specification for this file format will be forthcoming once more feedback
has been received, and the tooling around plugin installation is more mature. 
