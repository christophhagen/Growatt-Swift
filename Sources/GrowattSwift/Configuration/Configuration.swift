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
}


extension Configuration {

    public enum PVInputMode: DecodableRegister, CustomStringConvertible {

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
