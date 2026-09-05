# Directory Guide

Fell free to add more specifications of new structures added!!

## Main Structure

```text
./
├── .git/
│   
├── .godot/
|
├── Assets/
|
├── Docs/
|
├── Game/
|
├── Source/
|
└── project.godot
```

### Docs

Here you will find useful documents detailing the works on how the systems built work, just like with this document.

### Assets

This directory will have in work assets and its temporary files, it is not meant to be used for coding but only for work of the artists.

### Game

Here there will be working builds with the game binary, libraries and data. The structure used is:
```text
Game/
├── Linux/
│   ├── Binary.x86_64
|   ├── Libs/
│   └── Data/
│
└── Windows/
    ├── Binary.exe
    ├── Libs/
    └── Data/
```

### Source

Here will be the working directory for programmers. The structure we're using is:

```text
Source/
├── assets/
|   └── .../
|
├── scenes/
│   ├── enemies/
|   ├── menus/
|   ├── rooms/
│   └── testing/
|
├── scripts/
│   ├── aquirer/
│   ├── enemies/
|   ├── menus/
|   ├── player/
│   └── utils/
|
├── tools/
│   └── ...
|
└── world_layout/
    └── ...
```
