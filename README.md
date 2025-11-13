# *ROBERT*

![Static Badge](https://img.shields.io/badge/Zig-0.15.2-orange)
![Static Badge](https://img.shields.io/badge/Python-3.13-blue)

### The Robotic Execution & Research Terminal

An Open-Source Engine Made to Build, Test, and Live-Execute Finacial Algorithms! 

![Alt text](/assets/readme/diagrams/planned_structure.png?raw=true "Planned Structure")

## Instructions

To compile a custom auto:

```zsh
zig build-lib -dynamic -O ReleaseSafe -fPIC usr/autos/test_auto.zig \ -femit-bin=zig-out/bin/usr/autos/test_auto.dylib
```

where "test_auto" is the name of your auto src file.

## Contributions

if you are interested in this project, take a look at the source code and feel free to suggest ideas, fork and PR.

## License

This project is licensed under the terms of the GNU General Public Licens v3.0
