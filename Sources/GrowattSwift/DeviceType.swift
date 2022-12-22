import Foundation

public enum DeviceType {
    // Inverters

    /** Inverter */
    case inverter(Inverter)
    /** Data logger */
    case dataLogger(DataLogger)
    /** Confluence box 1 */
    case confluenceBox
    /** Front 1 tracker PV Storage */
    case pvStorage
    /** OffGrid SPF 3‐5K */
    case offGrid

    /** Unknown device */
    case unknown(UInt16)

    public enum Inverter {
        /** 1 tracker and 1phase Grid connect PV inverter TL */
        case oneTrackerOnePhaseTL
        /** 2 tracker and 1phase Grid connect PV inverter TL */
        case twoTrackerOnePhaseTL
        /** 1 tracker and 1phase Grid connect PV inverter HF */
        case oneTrackerOnePhaseHF
        /** 2 tracker and 1phase Grid connect PV inverter HF */
        case twoTrackerOnePhaseHF
        /** 1 tracker and 1phase Grid connect PV inverter LF */
        case oneTrackerOnePhaseLF
        /** 2 tracker and 1phase Grid connect PV inverter LF */
        case twoTrackerOnePhaseLF
        /** 1 tracker and 3phase Grid connect PV inverter TL */
        case oneTrackerThreePhaseTL
        /** 2 tracker and 3phase Grid connect PV inverter TL */
        case twoTrackerThreePhaseTL
        /** 1 tracker and 3phase Grid connect PV inverter LF */
        case oneTrackerThreePhaseLF
        /** 2 tracker and 3phase Grid connect PV inverter LF */
        case twoTrackerThreePhaseLF

        init?(_ value: UInt16) {
            switch value {
            case 100..<200:
                self = .oneTrackerOnePhaseTL
            case 200..<300:
                self = .twoTrackerOnePhaseTL
            case 300..<400:
                self = .oneTrackerOnePhaseHF
            case 400..<500:
                self = .twoTrackerOnePhaseHF
            case 500..<600:
                self = .oneTrackerOnePhaseLF
            case 600..<700:
                self = .twoTrackerOnePhaseLF
            case 700..<800:
                self = .oneTrackerThreePhaseTL
            case 800..<900:
                self = .twoTrackerThreePhaseTL
            case 900..<1000:
                self = .oneTrackerThreePhaseLF
            case 1000..<1100:
                self = .twoTrackerThreePhaseLF
            default:
                return nil
            }
        }
    }

    public enum DataLogger: UInt16 {
        case rfShine = 10001
        case webShinePano = 10002
        case webShineWebBox = 10003
        case wlWifiModule = 10004
    }

    init(_ value: UInt16) {
        switch value {
        case 100..<1100:
            guard let type = Inverter(value) else {
                self = .unknown(value)
                return
            }
            self = .inverter(type)
        case 10001...10004:
            guard let type = DataLogger(rawValue: value) else {
                self = .unknown(value)
                return
            }
            self = .dataLogger(type)
        case 11001:
            self = .confluenceBox
        case 3100..<3200:
            self = .pvStorage
        case 3400..<3500:
            self = .offGrid
        default:
            self = .unknown(value)
        }
    }
}

