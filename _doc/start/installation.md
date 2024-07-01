---
title: Installation
sections:
  - Step One
  - Step Two
  - Step Three
---

### Requirements

To start using Enceladus you will need either a JailBroken PS2 (capable of running unsigned code) or a PS2 Emulator such as PCSX2

If you want to run this on Real hardware, you will need to store the executable in a storage device recognized by both your console current software and Enceladus, the best example of this would be any USB storage device, FAT32 (or EXFAT if you use modern PS2 homebrew)

### Step Two

The recommended launcher is wLaunchELF. wich is a Homebrew Filebrowser. inside it, your USB will be shown as `mass:/`, inside you should locate the enceladus binaries and run the `.ELF` file bundled

### Step Three

See the magic happen!

Enceladus stock software is designed to look for several external scripts and if any is found, it will try to run them. all of them are searched as relative paths.

Here is a list (in order):
- `System/index.lua`
- `System/script.lua`
- `System/system.lua`
- `index.lua`
- `script.lua`
- `system.lua`