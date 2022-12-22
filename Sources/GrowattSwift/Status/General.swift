import Foundation

extension Status {

    struct General {
        
        let systemRunState: SystemStatus

        /** Work time total (s) */
        let workTimeTotal: TimeInterval

        let fault: OffGridInverterFault?

        let warning: OffGridInverterWarning?

        let faultValue: UInt16

        let warningValue: UInt16

        let deviceType: DeviceType

        let check: ChargePowerCheck?

        let productionLineMode: ProductionLineMode

        /** Constant Power OK Flag */
        let constantPowerOK: Bool

        init(data: [UInt16]) {
            self.systemRunState = data.get()

            self.workTimeTotal = TimeInterval(data.float(uint32At: 30, scale: 2))
            self.fault = OffGridInverterFault(rawValue: data[40])
            self.warning = OffGridInverterWarning(rawValue: data[41])
            self.faultValue = data[42]
            self.warningValue = data[43]
            self.deviceType = DeviceType(data[44])
            self.check = ChargePowerCheck(rawValue: data[45])
            self.productionLineMode = data.get()
            self.constantPowerOK = data.bool(at: 47)
        }
    }
}


extension Status.General: CustomStringConvertible {

    var description: String {
        """
        General
          System State: \(systemRunState)
          Work Time Total: \(workTimeTotal) s
          Fault: \(fault == nil ? "None" : "\(fault!) (\(faultValue)")
          Warning: \(warning == nil ? "None" : "\(warning!) (\(warningValue)")
          Device Type: \(deviceType)
          Checks: \(check == nil ? "No checks running" : "\(check!)")
          Production Line Mode: \(productionLineMode)
          Constant Power OK: \(constantPowerOK ? "Yes" : "No")
        """
    }
}

extension Status.General {

    enum SystemStatus: DecodableRegister, CustomStringConvertible {

        static let register = 0

        /** Raw value: 0 */
        case standby

        /** Raw value: 2 */
        case discharging

        /** Raw value: 3 */
        case fault

        /** Raw value: 4 */
        case flashing

        /** Raw value: 5 */
        case pvCharging

        /** Raw value: 6 */
        case acCharging

        /** Raw value: 7 */
        case combinedCharging

        /** Raw value: 8 */
        case combineChargeAndBypass

        /** Raw value: 9 */
        case pvChargingAndBypass

        /** Raw value: 10 */
        case acChargingAndBypass

        /** Raw value: 11 */
        case bypass

        /** Raw value: 12*/
        case pvChargingAndDischarge

        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0: self = .standby
            case 2: self = .discharging
            case 3: self = .fault
            case 4: self = .flashing
            case 5: self = .pvCharging
            case 6: self = .acCharging
            case 7: self = .combinedCharging
            case 8: self = .combineChargeAndBypass
            case 9: self = .pvChargingAndBypass
            case 10: self = .acChargingAndBypass
            case 11: self = .bypass
            case 12: self = .pvChargingAndDischarge
            default: self = .unknown(rawValue: rawValue)
            }
        }

        var description: String {
            switch self {
            case .standby: return "Standby"
            case .discharging: return "Discharging"
            case .fault: return "Fault"
            case .flashing: return "Flashing"
            case .pvCharging: return "PV Charging"
            case .acCharging: return "AC Charging"
            case .combinedCharging: return "Combined Charging"
            case .combineChargeAndBypass: return "Combined Charging and Bypass"
            case .pvChargingAndBypass: return "PV Charging and Bypass"
            case .acChargingAndBypass: return "AC Charging and Bypass"
            case .bypass: return "Bypass"
            case .pvChargingAndDischarge: return "PV Charging and Discharge"
            case .unknown(let rawValue): return "Unknown (\(rawValue))"
            }
        }
    }
}

extension Status.General {

    enum OffGridInverterFault: UInt16, CustomStringConvertible {
        case cpuAtoBCommunicationError = 2 // 0x00000002
        case batterySampleInconsistent = 3 // 0x00000004
        case buckOvercurrent = 4 // 0x00000008
        case bmsCommunicationFault = 5 // 0x00000010
        case batteryAbnormal = 6 // 0x00000020
        case batteryVoltageHigh = 8 // 0x00000080
        case overTemperature = 9 // 0x00000100
        case overload = 10 // 0x00000200
        case batteryReverseConnection = 17 // 0x00010000
        case busSoftStartFail = 18 // 0x00020000
        case dcDcAbnormal = 19 // 0x00040000
        case dcVoltageHigh = 20 // 0x00080000
        case ctDetectFailed = 21 // 0x00100000
        case cpuBtoACommunicationError = 22 // 0x00200000
        case busVoltageHigh = 23 // 0x00400000
        case movBreak = 25 // 0x01000000
        case outputShortCircuit = 26 // 0x02000000
        case lithiumBatteryOverload = 27 // 0x04000000
        case outputVoltageHigh = 28 // 0x08000000

        var description: String {
            switch self {
            case .cpuAtoBCommunicationError:
                return "CPU A to B Communication"
            case .batterySampleInconsistent:
                return "Inconsistent Battery Sample"
            case .buckOvercurrent:
                return "Buck Converter Overcurrent"
            case .bmsCommunicationFault:
                return "BMS Communication Fault"
            case .batteryAbnormal:
                return "Battery Abnormal"
            case .batteryVoltageHigh:
                return "High Battery Voltage"
            case .overTemperature:
                return "Overtemperature"
            case .overload:
                return "Overload"
            case .batteryReverseConnection:
                return "Reverse Battery Connection"
            case .busSoftStartFail:
                return "Bus Soft Start Failed"
            case .dcDcAbnormal:
                return "DC Converter Abnormal"
            case .dcVoltageHigh:
                return "DC Voltage High"
            case .ctDetectFailed:
                return "CT Detect Failed"
            case .cpuBtoACommunicationError:
                return "CPU B to A Communication"
            case .busVoltageHigh:
                return "High Bus Voltage"
            case .movBreak:
                return "MOV Break"
            case .outputShortCircuit:
                return "Short Circuit At Output"
            case .lithiumBatteryOverload:
                return "Lithium Battery Overload"
            case .outputVoltageHigh:
                return "High Output Voltage"
            }
        }
    }
}

extension Status.General {

    enum OffGridInverterWarning: UInt16, CustomStringConvertible {
        case batteryVoltageLowWarning = 0 // 0x0001
        case overtemperatureWarning = 1 // 0x0002
        case overloadWarning = 2 // 0x0004
        case failedToReadEEPROM = 4 // 0x0008
        case firmwareVersionMismatch = 5 // 0x0010
        case failedToWriteEEPROM = 6 // 0x0020
        case bmsWarning = 7 // 0x0040
        case lithiumBatteryOverloadWarning = 8 // 0x0080
        case lithiumBatteryAgingWarning = 9 // 0x0100
        case fanLockWarning = 10 // 0x0200

        var description: String {
            switch self {
            case .batteryVoltageLowWarning:
                return "Low Battery Voltage"
            case .overtemperatureWarning:
                return "High Temperature"
            case .overloadWarning:
                return "Overload"
            case .failedToReadEEPROM:
                return "EEPROM Read Failed"
            case .firmwareVersionMismatch:
                return "Firmware Version Mismatch"
            case .failedToWriteEEPROM:
                return "EEPROM Write Failed"
            case .bmsWarning:
                return "BMS"
            case .lithiumBatteryOverloadWarning:
                return "Lithium Battery Overload"
            case .lithiumBatteryAgingWarning:
                return "Lithium Battery Aging"
            case .fanLockWarning:
                return "Fan Lock"
            }
        }
    }
}

extension Status.General {

    enum ChargePowerCheck: UInt16, CustomStringConvertible {
        /** PV1 charge power check */
        case pv1 = 1
        /** PV2 charge power check */
        case pv2 = 2
        /** AC charge Power check */
        case ac = 3

        var description: String {
            switch self {
            case .pv1: return "PV1 Charge Power Check"
            case .pv2: return "PV2 Charge Power Check"
            case .ac: return "AC Charge Power Check"
            }
        }
    }
}

extension Status.General {

    /** Production Line Mode */
    enum ProductionLineMode: DecodableRegister, CustomStringConvertible {

        static let register = 46

        /** Not at Production Line Mode (Raw value: 0) */
        case disabled

        /** Production Line Mode (Raw value: 1) */
        case enabled

        /** Production Line Clear Fault Mode (Raw value: 2) */
        case clearFaultMode

        case unknown(rawValue: UInt16)

        init(_ rawValue: UInt16) {
            switch rawValue {
            case 0: self = .disabled
            case 1: self = .enabled
            case 2: self = .clearFaultMode
            default: self = .unknown(rawValue: rawValue)
            }
        }

        var description: String {
            switch self {
            case .disabled: return "Disabled"
            case .enabled: return "Enabled"
            case .clearFaultMode: return "Clear Fault Mode"
            case .unknown(let rawValue): return "Unknown (\(rawValue))"
            }
        }
    }
}
