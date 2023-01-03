import Foundation

/**
 The configuration of the inverter.
 */
public struct Configuration {

    /** The configuration of the utility connection of the inverter */
    public let utility: UtilityConfiguration

    /** The configuration of the AC output */
    public let acOutput: ACOutputConfiguration

    /** The configuration of the battery */
    public let battery: BatteryConfiguration

    public let device: DeviceConfiguration

    /** Indicates if the device is in standby mode. */
    public let standby: Bool

    /** PV Input Mode */
    public let pvInputMode: PVInputMode

    /**
     Decode the device configuration from received modbus data.

     To read the values using [SwiftLibModbus](https://github.com/jollyjinx/SwiftLibModbus):
     ```swift
     let client = try ModbusDevice(device: "/dev/...", baudRate: 9600)
     let data: [UInt16] = try await client.readRegisters(from: 0, count: 81, type: .holding)
     let config = try Configuration(data: data)
     ```
     - Parameter data: The 81 values starting at register 0.
     - Throws: `ParseError` `DataError`
     */
    init(data: [UInt16]) {
        self.utility = .init(data: data)
        self.acOutput = .init(data: data)
        self.battery = .init(data: data)
        self.device = .init(data: data)
        self.standby = data.get(0) & 0xFF > 0
        self.pvInputMode = data.get()
    }

    func write(to data: inout [UInt16]) {
        utility.write(to: &data)
        acOutput.write(to: &data)
        battery.write(to: &data)
        device.write(to: &data)
        let value = data[0] | (standby ? 1 : 0)
        data.write(value, at: 0)
        data.write(pvInputMode)
    }
}


extension Configuration {

    public enum PVInputMode: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 7

        /** Raw value: 0 */
        case independent

        /** Raw value: 1 */
        case parallel

        /** Unknown PV Input Mode */
        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0: self = .independent
            case 1: self = .parallel
            default: self = .unknown(rawValue: rawValue)
            }
        }

        public var description: String {
            switch self {
            case .independent: return "Independent"
            case .parallel: return "Parallel"
            case .unknown(let rawValue): return "Unknown (\(rawValue))"
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .independent: return 0
            case .parallel: return 1
            case .unknown(let value): return value
            }
        }
    }
}

extension Configuration: CustomStringConvertible {

    public var description: String {
        """
        Configuration
          Standby: \(standby ? "Yes" : "No")
          PV Input Mode: \(pvInputMode)
        \(utility)
        \(acOutput)
        \(battery)
        \(device)
        """
    }
}

extension Configuration: Codable {

    enum CodingKeys: Int, CodingKey {
        case utility = 1
        case acOutput = 2
        case battery = 3
        case device = 4
        case standby = 5
        case pvInputMode = 6
    }

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

extension Configuration: Equatable {

}
