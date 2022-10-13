# Cross compile

## Requirements

- Linux aarch64 machine (ubuntu20.04LTS-arm64)
- Docker
- Python3
- zip

<br>

## Build

- target workspace : ws/
- export package name (default) : output_<`arch`>_<`unixtime`>

```build
cd cross_compile/
./Xcolcon_build --workspace ws
```

Built zip file is `ws/output_aarch64_<unixtime>.zip`.

<br>

## Note

On debian, you have to solve dependencies manualy. (You cannot use rosdep2)

You can check installed package on [Dockerfile](./../build/Dockerfile). Please rewrite it accordingly.

<br>

# Do It Yourself !

Do not ask questions about resolving dependencies!!!
