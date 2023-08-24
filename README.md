# Growatt-Swift

A small package to communicate with a Growatt Inverter (SPF 5000) over RS485 Modbus.
At the moment, it's only possible to read various configuration and status values (no write options).
It's tested to run on Linux.

## Usage

Simply create a client with the serial interface where the inverter is connected.

```swift
let client = try GrowattClient(path: "/dev/ttyUSB0")
// Read the device configuration
let config = try await client.readConfiguration()
// Read the current status
let status = try await client.readStatus()
```
