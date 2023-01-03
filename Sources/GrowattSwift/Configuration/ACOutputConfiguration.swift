import Foundation

/** The configuration for the AC output of the inverter */
public struct ACOutputConfiguration {

    /** Indicates if the AC output is enabled. */
    public let isEnabled: Bool

    /** The configuration for the AC output. Decides which power source is used first. */
    public let priority: Priority

    /** The voltage setting for the AC output */
    public let voltageType: Voltage

    /** The frequency setting for the AC output */
    public let frequencyType: Frequency

    /** The type of inverter
     - Warning: The model is currently not decoded correctly
     */
    public let inverterModule: InverterModule

    /** The behaviour when an overload is detected */
    public let overloadRestart: OverloadRestart

    /**
     Internally decode the properties from received data.
     Assumes that all data starting from register 0 is passed to the initializer.
     */
    init(data: [UInt16]) {
        self.isEnabled = data.get(0) >> 8 > 0
        self.priority = data.get()
        self.voltageType = data.get()
        self.frequencyType = data.get()
        self.overloadRestart = data.get()
        self.inverterModule = .init(register28: data.get(28), register29: data.get(29))
    }

    func write(to data: inout [UInt16]) {
        data.write(isEnabled ? 0x0100 : 0x0000, at: 0)
        data.write(priority)
        data.write(voltageType)
        data.write(overloadRestart)
        let value = inverterModule.rawValue
        data.write(UInt16(value >> 16), at: 28)
        data.write(UInt16(value & 0xFFFF), at: 29)
    }
}

extension ACOutputConfiguration {

    // TODO: Check for values of SBU and SUB
    /** The configuration for the AC output */
    public enum Priority: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 1

        /**
         Solar energy provides power to the loads as first priority.

         SBU priority

         If solar energy is not sufficient to power all connected loads, battery will supply power to the loads at the same time.
         Utility provides power to the loads only when battery voltage drops to either low-level warning voltage or the setting point in program 12.

         SUB priority

         Solar energy provides power to the loads as first priority.
         If solar energy is not sufficient to power all connected loads, solar and utility will power loads at the same time.
         Battery provides power to the loads only when solar energy is not sufficient and there is no utility.
         */
        case battery

        /**
         Solar energy provides power to the loads as first priority.

         If solar energy is not sufficient to power all connected loads, battery energy will supply power the loads at the same time.
         Utility provides power to the loads only when any one condition happens:
         - Solar energy is not available
         - Battery voltage drops to either low-level warning voltage or the setting point in program 12.
         */
        case pv

        /**
         Utility will provide power to the loads as first priority (default).

         Solar and battery energy will provide power to the loads only when utility power is not available.
         */
        case utility

        /** An unknown value was received */
        case unknown(UInt16)


        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0:
                self = .battery
            case 1:
                self = .pv
            case 2:
                self = .utility
            default:
                self = .unknown(rawValue)
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .battery: return 0
            case .pv: return 1
            case .utility: return 2
            case.unknown(let value): return value
            }
        }


        public var description: String {
            switch self {
            case .battery: return "Battery"
            case .pv: return "PV"
            case .utility: return "Utility"
            case .unknown(let value): return "Unknown (\(value))"
            }
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(UInt16.self)
            self.init(value)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(rawValue)
        }
    }
}

extension ACOutputConfiguration {

    /** The voltage setting of the AC output */
    public enum Voltage: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 18

        case voltage208VAC
        case voltage230VAC
        case voltage240VAC

        /** An unknown value was received */
        case unknown(UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0:
                self = .voltage208VAC
            case 1:
                self = .voltage230VAC
            case 2:
                self = .voltage240VAC
            default:
                self = .unknown(rawValue)
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .voltage208VAC: return 0
            case .voltage230VAC: return 1
            case .voltage240VAC: return 2
            case .unknown(let value): return value
            }
        }

        public var description: String {
            switch self {
            case .voltage208VAC: return "208 V"
            case .voltage230VAC: return "230 V"
            case .voltage240VAC: return "240 V"
            case .unknown(let value): return "Unknown (\(value))"
            }
        }
    }
}

extension ACOutputConfiguration {

    /** The frequency setting of the AC output */
    public enum Frequency: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 19

        /** The frequency of the AC output is set to 50 Hz (Raw value: 0) */
        case frequency50Hz

        /** The frequency of the AC output is set to 60 Hz (Raw value: 1) */
        case frequency60Hz

        /** An unknown value was received */
        case unknown(UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0:
                self = .frequency50Hz
            case 1:
                self = .frequency60Hz
            default:
                self = .unknown(rawValue)
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .frequency50Hz: return 0
            case .frequency60Hz: return 1
            case .unknown(let value): return value
            }
        }

        public var description: String {
            switch self {
            case .frequency50Hz: return "50 Hz"
            case .frequency60Hz: return "60 Hz"
            case .unknown(let value): return "Unknown (\(value))"
            }
        }
    }
}

extension ACOutputConfiguration {

    /** The behaviour when an overload is detected */
    public enum OverloadRestart: DecodableRegister, CustomStringConvertible, Equatable {

        static let register: Int = 20

        /** Yes (restart one minute after overload, stop output after overload occurs three times)  (Raw value: 0) */
        case yes

        /** The inverter does not restart after overload (Raw value: 1) */
        case no

        /** The inverter switches to utility (Raw value: 2) */
        case switchToUtility
        /** An unknown case was decoded */
        case unknown(UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0:
                self = .yes
            case 1:
                self = .no
            case 2:
                self = .switchToUtility
            default:
                self = .unknown(rawValue)
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .yes: return 0
            case .no: return 1
            case .switchToUtility: return 2
            case .unknown(let value): return value
            }
        }

        public var description: String {
            switch self {
            case .no: return "No"
            case .yes: return "Yes"
            case .switchToUtility: return "Switch to Utility"
            case .unknown(let value): return "Unknown (\(value))"
            }
        }
    }
}


extension ACOutputConfiguration {

    /** The inverter module type
     - Warning: The model is currently not decoded correctly
     */
    public enum InverterModule: CustomStringConvertible, Equatable {
        /**
         Documentation is not clear:

         P‐battery type:
         0: Lead_Acid;
         1: Lithium;
         2: CustomLead_Acid;

         U‐user type:
         0: No vendor;
         1: Growatt;
         2: CPS;
         3: Haiti;

         M‐power rate:
         3: 3KW;
         5:5KW;

         S‐Aging;
         0: Normal Mode;
         1: Aging Mode;

         - Note: Can only be set in standby mode
         */
        case unknown(high: UInt16, low: UInt16)

        public init(register28: UInt16, register29: UInt16) {
            // TODO: Understand register 28 and 29
            self = .unknown(high: register28, low: register29)
        }

        public var rawValue: UInt32 {
            switch self {
            case .unknown(let high, let low): return UInt32(high) << 16 | UInt32(low)
            }
        }

        public var description: String {
            switch self {
            case .unknown(let high, let low): return "Unknown (high: \(high), low: \(low))"
            }
        }
    }
}

extension ACOutputConfiguration: CustomStringConvertible {

    public var description: String {
        """
        AC Output
          Enabled: \(isEnabled ? "Yes" : "No")
          Priority: \(priority)
          Voltage: \(voltageType)
          Frequency: \(frequencyType)
          Restart on Overload: \(overloadRestart)
          Inverter: \(inverterModule)
        """
    }
}

extension ACOutputConfiguration: Equatable {

}
