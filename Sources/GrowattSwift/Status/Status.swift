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

    func write(to data: inout [UInt16]) {
        general.write(to: &data)
        pv.write(to: &data)
        acInput.write(to: &data)
        acOutput.write(to: &data)
        battery.write(to: &data)
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

extension Status: Codable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        var data = [UInt16](repeating: 0, count: 81)
        write(to: &data)
        try container.encode(data)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let data = try container.decode([UInt16].self)
        self.init(data: data)
    }
}
