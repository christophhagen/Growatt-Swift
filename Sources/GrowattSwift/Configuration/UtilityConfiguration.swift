import Foundation

/**
 The configuration of the utility connection of the inverter
 */
public struct UtilityConfiguration {

    /** The AC Input Mode */
    public let acInputMode: ACInputMode

    /**
     The time allowed for the inverter to power the load.

     The range represents the start and end hour (0-23).

     Use 4 digits to represent the time period, the upper two digits represent the time when inverter start to power the load, setting range from 00 to 23, and the lower two digits represent the time when inverter end to power the load, setting range from 00 to 23.
     (eg: 2320 represents the time allows inverter to power the load is from 23:00 to the next day 20:59, and the inverter AC output power is prohibited outside of this period)
     */
    public let outputInterval: Interval

    /**
     The time allowed for utility to charge the battery.

     The lower limit represents the time when utility will start to charge the battery, setting range from 00 to 23
     The upper limit represents the time when utility end to charge the battery, setting range from 00 to 23.
     (eg: 2320 represents the time allows utility to charge the battery is from 23:00 to the next day 20:59, and the utility charging is prohibited outside of this period)
     */
    public let chargeInterval: Interval

    init(data: [UInt16]) {
        let outputStartHour = data.integer(at: 3)
        let outputEndHour = data.integer(at: 4)
        self.outputInterval = .init(startHour: outputStartHour, endHour: outputEndHour)
        let chargeStartHour = data.integer(at: 5)
        let chargeEndHour = data.integer(at: 6)
        self.chargeInterval = .init(startHour: chargeStartHour, endHour: chargeEndHour)
        self.acInputMode = data.get()
    }

    func write(to data: inout [UInt16]) {
        data.write(outputInterval.startHour, at: 3)
        data.write(outputInterval.endHour, at: 4)
        data.write(chargeInterval.startHour, at: 5)
        data.write(chargeInterval.endHour, at: 6)
        data.write(acInputMode)
    }
}

extension UtilityConfiguration {

    public struct Interval: Codable, Equatable {

        public let startHour: Int

        public let endHour: Int

        public init(startHour: Int, endHour: Int) {
            self.startHour = startHour
            self.endHour = endHour
        }
    }
}


extension UtilityConfiguration {

    public enum ACInputMode: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 8

        /** APL: 90 - 280 VAC (Raw value: 0) */
        case apl

        /** UPS: 170 - 280 VAC (Raw value: 1) */
        case ups

        /** Unknown Input Mode */
        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0: self = .apl
            case 1: self = .ups
            default: self = .unknown(rawValue: rawValue)
            }
        }

        public var description: String {
            switch self {
            case .apl: return "APL (90-280 V)"
            case .ups: return "UPS (170-280 V)"
            case .unknown(let rawValue): return "Unknown (\(rawValue))"
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .apl: return 0
            case .ups: return 1
            case .unknown(let value): return value
            }
        }
    }
}

extension UtilityConfiguration: CustomStringConvertible {

    public var description: String {
        """
        Utility
          AC Input Mode: \(acInputMode)
          Output interval: \(outputInterval.startHour):00 - \(outputInterval.endHour):00
          Charge interval: \(chargeInterval.startHour):00 - \(chargeInterval.endHour):00
        """
    }
}

extension UtilityConfiguration: Equatable {
    
}
