# Bleakfiber's Unit Toggles - Forever

[![Interface](https://img.shields.io/badge/Interface-16001%20(WoW%20Forever)-0078D7.svg?style=flat-square)](https://github.com/Bleakfiber/BleakfibersUnitToggles-Forever)
[![Release](https://img.shields.io/badge/Release-v1.0.6-ffd100.svg?style=flat-square)](https://github.com/Bleakfiber/BleakfibersUnitToggles-Forever/releases)
[![License](https://img.shields.io/badge/License-Source--Available-crimson.svg?style=flat-square)](LICENSE.md)
[![Dependencies](https://img.shields.io/badge/Dependencies-Zero%20External-2ea44f.svg?style=flat-square)](https://github.com/Bleakfiber/BleakfibersUnitToggles-Forever)
[![Suite](https://img.shields.io/badge/Suite-Bleakfiber's%20Addon%20Suite-8a2be2.svg?style=flat-square)](https://github.com/Bleakfiber)

**Bleakfiber's Unit Toggles** is a high-performance, standalone unit name and nameplate CVar manager built specifically for **World of Warcraft: Forever** (Interface 16001).

Engineered to replace cumbersome macro scripts and deeply buried interface options, it delivers an instant, draggable **Dark Slate & Gold** control panel with 20 granular Blizzard CVars, quick-switch presets (PvP, PvE/Raid, Screenshot, Questing), an official Blizzard Defaults restoration button, and complete profile synchronization with the **Bleakfiber Addon Suite**.

Runs **100% standalone out of the box** with zero required third-party libraries or addons.

---

## 📑 Table of Contents

- [Key Highlights](#-key-highlights)
- [Feature Showcase](#-feature-showcase)
  - [1. 20 Granular Blizzard CVar Toggles](#1-20-granular-blizzard-cvar-toggles)
  - [2. One-Click Situational Presets](#2-one-click-situational-presets)
  - [3. Official Blizzard Defaults Restoration](#3-official-blizzard-defaults-restoration)
  - [4. Standalone Draggable HUD Panel](#4-standalone-draggable-hud-panel)
  - [5. Instant Live CVar Synchronization](#5-instant-live-cvar-synchronization)
  - [6. Master Hub & Profile Sync](#6-master-hub--profile-sync)
- [Interactive Controls & Mouse Shortcuts](#-interactive-controls--mouse-shortcuts)
- [Configuration Guide](#-configuration-guide)
- [Slash Commands Reference](#-slash-commands-reference)
- [Architecture & File Overview](#-architecture--file-overview)
- [Installation Guide](#-installation-guide)
- [Bleakfiber Addon Suite Ecosystem](#-bleakfiber-addon-suite-ecosystem)
- [License & Support](#-license--support)

---

## 🌟 Key Highlights

* **Pure Standalone Power**: Zero external dependencies. Self-contained CVar engine operates directly on native Blizzard Console Variables.
* **20 Granular CVar Controls**: Complete control over player names, NPC names, guild titles, honor titles, pets, minions, totems, and nameplates.
* **One-Click Presets**: Switch instantly between specialized presets for PvP Arenas/Battlegrounds, PvE Raids, Questing, and Clean UI Screenshots.
* **Official Blizzard Defaults**: One-click restoration button cleanly resets all unit CVars back to Blizzard factory defaults.
* **Compact Floating Control Panel**: Draggable, lockable standalone window styled in signature Dark Slate & Gold.
* **Non-Destructive Profile Capture**: Instant profile synchronization with `BleakfibersAddonConfig-Forever` that captures active settings upon profile creation.

---

## 🎯 Feature Showcase

### 1. 20 Granular Blizzard CVar Toggles
Direct, high-performance toggles for all unit display settings:
- **Player Names**: Friendly Player Names, Enemy Player Names.
- **NPC Names**: Friendly NPC Names, Enemy NPC Names.
- **Titles & Guilds**: Player Titles, Guild Names, Guild Titles.
- **Sub-Units**: Pets, Minions, Guardians, and Totems.
- **Nameplates**: Friendly Nameplates, Enemy Nameplates, Nameplate Motion Type (Overlapping vs. Stacking), and Castbars on Nameplates.
- **Visibility Conditions**: Combat-only nameplates, In-Combat names, and Target-only highlights.

### 2. One-Click Situational Presets
Adapt your interface to any gameplay scenario in a fraction of a second:
- **PvP Mode**: Highlights enemy player names and nameplates while suppressing friendly clutter and NPC titles.
- **PvE / Raid Mode**: Stacks enemy nameplates with castbars enabled, showing friendly names without cluttering screen space.
- **Questing Mode**: Shows friendly NPC names and enemy targets for easy questgiver and mob identification.
- **Clean Screenshot Mode**: Instantly hides all unit text and nameplates for pristine UI captures.

### 3. Official Blizzard Defaults Restoration
Safe experimentation with zero risk:
- Click the **[Blizzard Defaults]** button at any time to immediately revert all 20 managed CVars back to original client defaults.
- No need to delete WTF folders or guess default console variables.

### 4. Standalone Draggable HUD Panel
Convenient on-screen access:
- Sleek floating window accessible via `/but` or `/unittoggles`.
- Drag by header to place anywhere on your screen. Position persists across sessions.
- Optional auto-close or persistent on-screen positioning.

### 5. Instant Live CVar Synchronization
Always accurate:
- Listens for CVar state changes triggered externally (via keybinds or game menus).
- Checkbox indicators and toggle switches update instantly to reflect true active game engine state.

### 6. Master Hub & Profile Sync
Full integration into `BleakfibersAddonConfig-Forever`:
- Embedded directly within the BAC master hub sidebar.
- Non-destructive profile creation that clones current CVar profiles instead of wiping to factory defaults.
- Synchronized profile switching across all Bleakfiber addons.

---

## 🖱️ Interactive Controls & Mouse Shortcuts

| Action | Description |
| :--- | :--- |
| **`/but` or `/unittoggles`** | Toggles the standalone Unit Toggles control panel. |
| **Click Preset Button** | Instantly applies the selected preset (PvP, PvE, Screenshot, Questing). |
| **Click [Blizzard Defaults]** | Resets all managed unit CVars back to official Blizzard default values. |
| **Drag Header** | Repositions the control panel on screen. |

---

## 🛠️ Configuration Guide

Access settings via `/but`, `/unittoggles`, or through `/bac`:

1. **Preset Toolbar**: Quick-select buttons for PvP, PvE/Raid, Questing, and Screenshot profiles, plus the Blizzard Defaults restore button.
2. **Unit Names**: Checkboxes for Friendly Players, Enemy Players, Friendly NPCs, and Enemy NPCs.
3. **Identity Details**: Checkboxes for Guild Names, Guild Titles, and Player Titles.
4. **Pets & Totems**: Checkboxes for Friendly/Enemy Pets, Minions, Totems, and Guardians.
5. **Nameplate Settings**: Checkboxes for Friendly/Enemy Nameplates, Stacking vs. Overlapping motion, and Nameplate Castbars.
6. **Profiles**: Create, copy, delete, and switch configurations with full Bleakfiber Addon Suite synchronization.

---

## ⌨️ Slash Commands Reference

| Command | Description |
| :--- | :--- |
| `/but` | Toggles the Unit Toggles graphical control panel. |
| `/unittoggles` | Alternative shortcut to toggle the control panel. |
| `/but reset` | Reverts all managed CVars back to Blizzard defaults. |
| `/but profile <name>` | Switches active profile or prints current profile name. |

---

## 🏗️ Architecture & File Overview

```
BleakfibersUnitToggles-Forever/
├── BleakfibersUnitToggles-Forever.toc  # Addon metadata, SavedVariables & manifest
├── Config.lua                          # CVar definitions, presets schema & BAC registration
├── Core.lua                            # CVar read/write engine, event listeners & synchronization
└── UI.lua                              # Native Dark Slate & Gold panel & preset toolbar
```

---

## 💾 Installation Guide

1. Download the latest release package from the official [Releases](https://github.com/Bleakfiber/BleakfibersUnitToggles-Forever/releases) page.
2. Exit World of Warcraft completely.
3. Extract the downloaded archive (`BleakfibersUnitToggles-Forever 1.0.6.zip`).
4. Copy the `BleakfibersUnitToggles-Forever` folder into your WoW client AddOns directory:
   ```
   World of Warcraft/_forever_/Interface/AddOns/BleakfibersUnitToggles-Forever
   ```
5. Launch World of Warcraft, log into your character, and type `/but` to open the control panel.

---

## 🌌 Bleakfiber Addon Suite Ecosystem

Bleakfiber's Unit Toggles integrates seamlessly with the entire **Bleakfiber Addon Suite**:

* **[Bleakfiber's Addon Config](https://github.com/Bleakfiber/BleakfibersAddonConfig-Forever)**: Centralized master configuration hub with unified mover mode and cross-addon profile syncing.
* **[Bleakfiber's Action Bars](https://github.com/Bleakfiber/BleakfibersActionBars-Forever)**: Minimalist action bar suite with bags container, totem bars, and cooldown pulse.
* **[Bleakfiber's Quest Tracker](https://github.com/Bleakfiber/BleakfibersQuestTracker-Forever)**: High-performance quest tracker with 360° Wayfinder navigation and interactive quest items.
* **[Bleakfiber's Maps](https://github.com/Bleakfiber/BleakfibersMaps-Forever)**: Lightweight world map and minimap customization suite.

---

## 📜 License & Support

* **License**: Restricted - Source-Available (All Rights Reserved, No Derivatives). See [LICENSE.md](LICENSE.md) for full terms.
* **Issues & Feedback**: Encounter a bug or have a feature request? Open an issue on our [GitHub Issue Tracker](https://github.com/Bleakfiber/BleakfibersUnitToggles-Forever/issues).
* **Author**: Bleakfiber

