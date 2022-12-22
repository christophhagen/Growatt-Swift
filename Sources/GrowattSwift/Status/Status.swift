import Foundation

public struct Status {

    let general: General

    let pv: PV

    let acInput: ACInput

    let acOutput: ACOutput

    let battery: Battery

    /**
     Decode the current device status from modbus data.

     To read the values using [SwiftLibModbus](https://github.com/jollyjinx/SwiftLibModbus):
     ```swift
     let client = try ModbusDevice(device: "/dev/...", baudRate: 9600)
     let statusData: [UInt16] = try await client.readRegisters(from: 0, count: 83, type: .input)
     let status = try Status(data: statusData)
     ```
     - Parameter data: The 83 values starting at register 0.
     - Throws: `ParseError` `DataError`
     */
    init(data: [UInt16]) {
        self.general = .init(data: data)
        self.pv = .init(data: data)
        self.acInput = .init(data: data)
        self.acOutput = .init(data: data)
        self.battery = .init(data: data)
    }
}

extension Status: CustomStringConvertible {

    public var description: String {
        """
        \(general)
        \(pv)
        \(acInput)
        \(acOutput)
        \(battery)
        """
    }
}
