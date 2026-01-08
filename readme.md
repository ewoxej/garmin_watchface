# Analog Garmin Watch Face

This project is an **analog watch face for Garmin devices** built with the **Connect IQ SDK**.

## Features
- Classic analog clock
- Optional widgets:
  - Weather information
  - Current date
  - Battery level
  - Sunrise and sunset times
- **Always-On (AOD) mode** support
- Customizable settings:
  - Change widget colors
  - Adjust widget positions on the screen

## Supported Devices
- Garmin **Venu 2**
- Garmin **Venu 2 Plus**

## Requirements
To build this project, you need:
- **[Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)**
- **Garmin developer key**
You can generate a developer key to sign apps when they're compiled and packaged. The required key must be a RSA 4096 bit private key.
- **JDK**(see Connect IQ SDK documentaion)

All required paths and keys are configured in the `properties.mk` file.

## Build and run
Open terminal in the project folder and type:
`make target` where target could be one of the following values:
- build: only build *.prg
- buildall: build *.prg for all available devices
- run: build and run in emulator
- package: prepare package for publishing in the store

For example:

`make run`