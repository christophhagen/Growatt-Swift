import Foundation

/**
 The configuration of the battery
 */
public struct BatteryConfiguration {

    /**
     The configuration for the source for battery charging
     */
    public let chargeSource: ChargeSource


    /**
     The maximum charge current (in Ampere)

     Range: 10.0 - 130.0 A
     */
    public let maximumChargeCurrent: Float

    /**
     The bulk charge voltage (in Volt)

     Range: 50.0 - 58.0 V
     */
    public let bulkChargeVoltage: Float

    /**
     The floating charge voltage (in Volt)

     Range: 50.0 - 56.0 V
     */
    public let floatChargeVoltage: Float

    /**
     The low voltage threshold for the battery to switch to utility (in Volts)

     Range: 44.4 to 51.4 V
     */
    public let batteryLowVoltageToSwitchToUtility: Float

    /**
     The floating charge current (in Ampere)

     Range: 0.0 to 80.0 A
     */
    public let floatingChargeCurrent: Float

    public let batteryType: BatteryType

    public let agingMode: AgingMode

    /**
     Internally decode the properties from received data.
     Assumes that all data starting from register 0 is passed to the initializer.
     */
    init(data: [UInt16]) {
        self.chargeSource = data.get()
        self.batteryType = data.get()
        self.agingMode = data.get()

        self.maximumChargeCurrent = data.float(at: 34, scale: 10)
        self.bulkChargeVoltage = data.float(at: 35, scale: 10)
        self.floatChargeVoltage = data.float(at: 36, scale: 10)
        self.batteryLowVoltageToSwitchToUtility = data.float(at: 37, scale: 10)
        self.floatingChargeCurrent = data.float(at: 38, scale: 10)
    }

    func write(to data: inout [UInt16]) {
        data.write(chargeSource)
        data.write(batteryType)
        data.write(agingMode)

        data.write(maximumChargeCurrent, at: 34, scale: 10)
        data.write(bulkChargeVoltage, at: 35, scale: 10)
        data.write(floatChargeVoltage, at: 36, scale: 10)
        data.write(batteryLowVoltageToSwitchToUtility, at: 37, scale: 10)
        data.write(floatingChargeCurrent, at: 38, scale: 10)
    }
}

extension BatteryConfiguration {

    /**
     The configuration for the source for battery charging
     */
    public enum ChargeSource: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 2

        /** Raw value: 0 */
        case pvFirst

        /** Raw value: 1 */
        case pvAndUtility

        /** Raw value: 2 */
        case pvOnly

        /** Unknown charge source */
        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0: self = .pvFirst
            case 1: self = .pvAndUtility
            case 2: self = .pvOnly
            default: self = .unknown(rawValue: rawValue)
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .pvFirst: return 0
            case .pvAndUtility: return 1
            case .pvOnly: return 2
            case .unknown(let value): return value
            }
        }

        public var description: String {
            switch self {
            case .pvFirst: return "PV First"
            case .pvAndUtility: return "PV and Utility"
            case .pvOnly: return "Only PV"
            case .unknown(rawValue: let rawValue):
                return "Unknown (\(rawValue))"
            }
        }
    }
}

extension BatteryConfiguration {

    /**
     The battery type.
     - Note: Can only be set in standby mode.
     */
    public enum BatteryType: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 39

        /** Raw value: 0 */
        case leadAcid

        /** Raw value: 1 */
        case lithium

        /** Raw value: 2 */
        case customLeadAcid

        /** Unknown battery type */
        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0: self = .leadAcid
            case 1: self = .lithium
            case 2: self = .customLeadAcid
            default: self = .unknown(rawValue: rawValue)
            }
        }

        public var description: String {
            switch self {
            case .leadAcid: return "Lead Acid"
            case .lithium: return "Lithium"
            case .customLeadAcid: return "Lead Acid (Custom)"
            case .unknown(rawValue: let rawValue):
                return "Unknown (\(rawValue))"
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .leadAcid: return 0
            case .lithium: return 1
            case .customLeadAcid: return 2
            case .unknown(let value): return value
            }
        }
    }
}

extension BatteryConfiguration {

    /**
     The aging mode.
     - Note: Can only be set in standby mode.
     */
    public enum AgingMode: DecodableRegister, CustomStringConvertible, Equatable {

        static let register = 40

        /** Raw value: 0 */
        case normal

        /** Raw value: 1 */
        case aging

        /** Unknown aging mode */
        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0: self = .normal
            case 1: self = .aging
            default: self = .unknown(rawValue: rawValue)
            }
        }

        public var description: String {
            switch self {
            case .normal: return "Normal"
            case .aging: return "Aging"
            case .unknown(rawValue: let rawValue):
                return "Unknown (\(rawValue))"
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .normal: return 0
            case .aging: return 1
            case .unknown(let value): return value
            }
        }
    }
}

extension BatteryConfiguration: CustomStringConvertible {

    public var description: String {
        """
        Battery
          Charge Source: \(chargeSource)
          Battery Type: \(batteryType)
          Aging Mode: \(agingMode)
          Maximum Charge Current: \(maximumChargeCurrent) A
          Floating Charge Current: \(floatingChargeCurrent) A
          Bulk Charge Voltage: \(bulkChargeVoltage) V
          Float Charge Voltage: \(floatChargeVoltage) V
          Switch to Utility Voltage: \(batteryLowVoltageToSwitchToUtility) V
        """
    }
}

extension BatteryConfiguration: Equatable {

}
