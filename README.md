# BattleRadar

![Version](https://img.shields.io/badge/version-0.0.1-blue.svg)
![Interface](https://img.shields.io/badge/interface-10.2.0-yellow.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

A World of Warcraft addon that tracks your combat statistics and gold earnings.

## Features

- 📊 **Statistics Tracking**
  - Combat kills counter
  - Gold earned from looting
  - Session and lifetime statistics

- 🎨 **Clean UI**
  - Movable main window
  - Character information display
  - Intuitive controls
  - Position saving between sessions

- 💾 **Data Management**
  - Persistent statistics storage
  - Reset and wipe functionality
  - Debug mode for troubleshooting

## Installation

1. Download the latest release
2. Extract the folder to your `World of Warcraft\_retail_\Interface\AddOns` directory
3. Restart World of Warcraft if it's running

## Usage

### Slash Commands

- `/brs` - Toggle the main window
- `/brr` - Reset statistics
- `/brr keeppos` - Reset statistics but keep window position
- `/brr wipe` - Complete database wipe
- `/brd` - Toggle debug mode

### Window Controls

The main window can be:
- Dragged with left mouse button
- Closed with the X button or Escape key
- Repositioned and saved between sessions

## Development

### Requirements

- World of Warcraft Retail
- Basic Lua knowledge
- VS Code with Lua extension (recommended)

### Project Structure 