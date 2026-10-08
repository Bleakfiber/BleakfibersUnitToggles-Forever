# Bleakfiber's Unit Toggles - Forever

**Bleakfiber's Unit Toggles** is a dedicated, zero-dependency CVar management suite crafted specifically for **World of Warcraft: Forever** (Interface 16001).

Tired of memorizing `/console UnitName...` commands or digging through nested default interface menus just to declutter combat nameplates? Bleakfiber's Unit Toggles puts all **20 native unit overhead name, pet, guardian, totem, minion, and title CVars** into an intuitive Dark Slate & Gold control center with instant visual feedback, one-click combat presets, and full profile synchronization.

Runs 100% standalone out of the box with **zero required external libraries**, and automatically integrates into **Bleakfiber's Addon Config** when installed.

---

## Key Highlights

- **Zero External Dependencies**: Pure, lightweight native WoW Lua. No Ace3, LibSharedMedia, or external frameworks required.
- **Complete Overhead Text Authority (20 CVars)**: Fine-grained individual toggles for friendly players, enemy players, pets, minions, guardians, totems, questgivers, critters, guild names, titles, and trivial mob suppression.
- **Official Blizzard Defaults**: Preset defaults strictly aligned with native World of Warcraft engine configurations.
- **Instant Visual Synchronization**: All checkboxes immediately check or uncheck the moment you click a preset, change a profile, or toggle an option.
- **Real-Time Toggle Status Readout**: Live feedback indicator displays exactly how many toggles are active at any moment (e.g., `Active: 16 / 20 toggles enabled`).
- **One-Click Tactical Presets**:
  - **`[Enable All]`**: Instantly turns on all 20 unit overhead names and titles (20/20).
  - **`[Disable All]`**: Clears screen clutter by disabling all unit overhead names (0/20).
  - **`[PvP Preset]`**: Optimizes visibility for Battlegrounds and Arenas by enabling enemy players, pets, minions, guardians, totems, and friendly players while stripping away ambient titles and minor units.
  - **`[Blizzard Def]`**: Restores standard factory Blizzard UI default values in one click (16/20).
  - **`[Sync Live]`**: Reads whatever values are currently active in your game engine and stores them directly to your active profile.
- **Bidirectional Live Sync (`CVAR_UPDATE`)**: If you change a CVar via chat or Blizzard's options, the addon automatically detects the engine event and syncs your profile and open UI in real time.
- **Dual-Mode Architecture**:
  - **Standalone Mode**: Opens a sleek, draggable **Dark Slate & Gold** (`#141A21` / `#D1AE47`) options window complete with title bar, close button, and standard `ESC`-key closing.
  - **Master Hub Mode**: Seamlessly hooks into **`BleakfibersAddonConfig-Forever`**, embedding its balanced two-column canvas into the unified sidebar and syncing with master global profiles.

---

## Managed CVar Catalog (All 20 Toggles)

### Friendly Units
| Control | Console Variable | Blizzard Default | Description |
| :--- | :--- | :---: | :--- |
| **Friendly Players** | `UnitNameFriendlyPlayerName` | `1` (ON) | Overhead names for friendly player characters |
| **Friendly Pets** | `UnitNameFriendlyPetName` | `1` (ON) | Overhead names for friendly player pets |
| **Friendly Minions** | `UnitNameFriendlyMinionName` | `1` (ON) | Overhead names for friendly summoned minions |
| **Friendly Guardians** | `UnitNameFriendlyGuardianName` | `1` (ON) | Overhead names for friendly guardians |
| **Friendly Totems** | `UnitNameFriendlyTotemName` | `1` (ON) | Overhead names for friendly shaman totems |
| **Friendly Special NPCs** | `UnitNameFriendlySpecialNPCName` | `1` (ON) | Questgivers, vendors, flight masters, and key NPCs |

### NPCs & World
| Control | Console Variable | Blizzard Default | Description |
| :--- | :--- | :---: | :--- |
| **My Own Name** | `UnitNameOwn` | `0` (OFF) | Your character's name above your own head |
| **All NPCs** | `UnitNameNPC` | `0` (OFF) | Overhead names for all neutral/friendly NPCs |
| **Interactive NPCs** | `UnitNameInteractiveNPC` | `1` (ON) | Bankers, flight masters, and interaction targets |
| **Critters & Companions** | `UnitNameNonCombatCreatureName` | `0` (OFF) | Ambient critters and non-combat vanity pets |

### Enemy Units
| Control | Console Variable | Blizzard Default | Description |
| :--- | :--- | :---: | :--- |
| **Enemy Players** | `UnitNameEnemyPlayerName` | `1` (ON) | Overhead names for enemy/hostile players |
| **Enemy Pets** | `UnitNameEnemyPetName` | `1` (ON) | Overhead names for enemy pets |
| **Enemy Minions** | `UnitNameEnemyMinionName` | `1` (ON) | Overhead names for enemy summoned minions |
| **Enemy Guardians** | `UnitNameEnemyGuardianName` | `1` (ON) | Overhead names for enemy guardians |
| **Enemy Totems** | `UnitNameEnemyTotemName` | `1` (ON) | Overhead names for enemy totems |
| **Hostile NPCs** | `UnitNameHostleNPC` | `1` (ON) | Overhead names for hostile monsters and NPCs |

### Guild & Titles
| Control | Console Variable | Blizzard Default | Description |
| :--- | :--- | :---: | :--- |
| **Player Guild Names** | `UnitNamePlayerGuild` | `1` (ON) | Guild names beneath character names |
| **Player Guild Titles** | `UnitNameGuildTitle` | `1` (ON) | Guild rank and title suffixes |
| **Player PvP Titles** | `UnitNamePlayerPVPTitle` | `1` (ON) | PvP titles and ranks on player characters |
| **Force Hide Minor Units** | `UnitNameForceHideMinus` | `0` (OFF) | Force hide overhead names for trivial/minor mobs |

---

## Slash Commands Reference

| Command | Action |
| :--- | :--- |
| `/but` or `/unittoggles` | Opens the configuration interface (Master Hub if installed, standalone window otherwise). |
| `/but standalone` | Forces opening the standalone options window. |
| `/but list` or `/but status` | Prints the live `[ON]` / `[OFF]` status of all 20 CVars directly to your chat window. |
| `/but all [on\|off]` | Batch toggles all 20 unit nameplates on or off at once. |
| `/but pvp` | Immediately applies the optimized PvP visibility preset. |
| `/but <cvar> [0\|1]` | Directly toggles or sets any specific CVar from chat (e.g., `/but UnitNameEnemyTotemName 1`). |
| `/but reset` | Resets the active profile back to Blizzard defaults. |

---

## Suite Integration

Part of **Bleakfiber's Addon Suite for World of Warcraft Forever**:
- **Bleakfiber's Addon Config** — Unified master configuration hub and profile manager.
- **Bleakfiber's Action Bars** — Modular standalone action bar suite.
- **Bleakfiber's Maps** — Minimap and World Map enhancements.
- **Bleakfiber's Quest Tracker** — Modular quest tracking and Wayfinder 360° navigation HUD.
- **Bleakfiber's Unit Toggles** — Instant CVar nameplate and title manager.

