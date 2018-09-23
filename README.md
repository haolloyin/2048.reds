## 2048.reds

`2048.reds` is inspired by [2048.cpp](https://github.com/plibither8/2048.cpp), a terminal version of the game "2048" written in Red/System(a C-level language, but simpler and easier :).


### Sceenshots



### Download and play

- macOS, 
- Windows,
- Linux, 


## Requirements

- `Red` toolchain binary [here](https://www.red-lang.org/p/download.html)

- Linux and MacOS is fine to run on their terminal, but Windows needs to run on a working terminal (like Cygwin, Windows Subsystem for Linux or Git bash, etc).


### Compile

First you need to download the `Red` toolchain binary [here](https://www.red-lang.org/p/download.html), you could compile `2048` game to any OS you like.

> BTW, you can **cross-compile** to a different platform target than the current one.

- Linux:
```shell
red -target Linux -compile 2048.reds
```

- Windows(MS-DOS):
```shell
red -target MSDOS -compile 2048.reds
```

- macOS
```shell
red -target Darwin -compile 2048.reds
```

### Resources about `Red/System`

- [Red/System Language Specification](https://static.red-lang.org/red-system-specs-light.html)
- [Official website](https://www.red-lang.org/)
- [GitHub](https://github.com/red/red)


