import Foundation

public struct DeviceConfiguration {

    public let firmwareVersion: String

    public let firmwareControlVersion: String

    public let lcdLanguage: Language

    public let overTemperatureRestart: Bool

    public let buzzerIsEnabled: Bool

    public let serialNumber: String

    public let communicationAddress: Int

    public let firmwareStart: FirmwareStart

    public let deviceType: DeviceType

    public let systemTime: Date?

    public let manufacturerInfo: String

    public let firmwareBuildNumber: String

    /**
     Sys Weekly

     Range: 0-6
     */
    public let sysWeekly: Int

    /**
     Modbus Version

     Eg: 207 is V2.07
     */
    public let modbusVersion: Int

    /**
     Rate Watt: Rate active power

     Unit: Watt
     */
    public let ratedActivePower: Float

    /**
     Rate VA: Rate apparent power

     Unit: VA
     */
    public let ratedApparentPower: Float

    /** The ODM Info code */
    public let factoryCode: Int

    init(data: [UInt16]) {
        self.firmwareVersion = data.string(in: 9...11)
        self.firmwareControlVersion = data.string(in: 12...14)
        self.lcdLanguage = data.get()
        self.overTemperatureRestart = data.bool(at: 21)
        self.buzzerIsEnabled = data.bool(at: 22)
        self.serialNumber = data.string(in: 23...27)
        self.communicationAddress = data.integer(at: 30)
        self.firmwareStart = data.get()
        self.deviceType = DeviceType(data[43])
        self.systemTime = data.date(in: 45...50)
        self.manufacturerInfo = data.string(in: 59...66)
        self.firmwareBuildNumber = data.string(in: 67...70)
        self.sysWeekly = data.integer(at: 72)
        self.modbusVersion = data.integer(at: 73)
        self.factoryCode = data.integer(at: 80)

        self.ratedActivePower = data.float(uint32At: 76, scale: 10)
        self.ratedApparentPower = data.float(uint32At: 78, scale: 10)
    }

    func write(to data: inout [UInt16]) {
        data.write(firmwareVersion, in: 9...11)
        data.write(firmwareControlVersion, in: 12...14)
        data.write(lcdLanguage)
        data.write(overTemperatureRestart, at: 21)
        data.write(buzzerIsEnabled, at: 22)
        data.write(serialNumber, in: 23...27)
        data.write(communicationAddress, at: 30)
        data.write(firmwareStart)
        data.write(deviceType.rawValue, at: 43)
        if let systemTime {
            data.write(systemTime, in: 45...50)
        }
        data.write(manufacturerInfo, in: 59...66)
        data.write(firmwareBuildNumber, in: 67...70)
        data.write(sysWeekly, at: 72)
        data.write(modbusVersion, at: 73)
    }
}

extension DeviceConfiguration {

    public enum Language: CustomStringConvertible, DecodableRegister {

        static let register = 15

        case english
        case unknown(rawValue: UInt16)

        public var description: String {
            switch self {
            case .english: return "English"
            case .unknown(let value): return "Unknown (\(value))"
            }
        }

        init(_ value: UInt16) {
            switch value {
            case 0:
                self = .english
            default:
                self = .unknown(rawValue: value)
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .english: return 0
            case .unknown(let value): return value
            }
        }

    }
}

extension DeviceConfiguration {

    public enum FirmwareStart: DecodableRegister, CustomStringConvertible {

        static let register = 31

        /** Raw value: 1 */
        case own

        /** Raw value: 256 */
        case controlBoard

        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 1: self = .own
            case 256: self = .controlBoard
            default: self = .unknown(rawValue: rawValue)
            }
        }
        public var description: String {
            switch self {
            case .own: return "Own Flash"
            case .controlBoard: return "Control Board"
            case .unknown(rawValue: let rawValue):
                return "Unknown (\(rawValue))"
            }
        }

        public var rawValue: UInt16 {
            switch self {
            case .own: return 1
            case .controlBoard: return 256
            case .unknown(let value): return value
            }
        }
    }
}

extension DeviceConfiguration: CustomStringConvertible {

    public var description: String {
        """
        Device
          Device type: \(deviceType)
          Rated Active Power: \(ratedActivePower) W
          Rated Apparent Power: \(ratedApparentPower) VA
          Serial number: \(serialNumber)
          Manufacturer info: \(manufacturerInfo)
          Factory code: \(factoryCode)
          Firmware: \(firmwareVersion), \(firmwareControlVersion)
          Firmware build version: \(firmwareBuildNumber)
          Firmware start: \(firmwareStart)
          System time: \(systemTime != nil ? df.string(from: systemTime!) : "")
          Language: \(lcdLanguage)
          Overtemperature Restart: \(overTemperatureRestart ? "Yes" : "No")
          Buzzer: \(buzzerIsEnabled ? "Yes" : "No")
          Bus Address: \(communicationAddress)
          Modbus version: \(modbusVersion)
        """
    }
}

private var df: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    return df
}()
