# The Outlander PHEV control app builder

What it does:

It just builds the [phevctl](https://github.com/phev-remote/phevctl) application by [Jamie](https://github.com/papawattu) from the commandline, without further interaction or the use of docker.

## Usage

```
$> git submodule init
$> git submodule update
$> ./build.sh
```

## Caveats

I am still trying to figure out how to find the paho-mqtt3c-static library when enabling `MQTT_PAHO` via `ccmake .`.
Any clues?

Have fun,
Gerhard
