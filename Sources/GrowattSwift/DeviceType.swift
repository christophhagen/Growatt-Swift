import Foundation

public enum DeviceType {
    // Inverters

    /** Inverter */
    case inverter(Inverter)
    /** Data logger */
    case dataLogger(DataLogger)
    /** Confluence box 1 */
    case confluenceBox(UInt16)
    /** Front 1 tracker PV Storage */
    case pvStorage(UInt16)
    /** OffGrid SPF 3‐5K */
    case offGrid(UInt16)

    /** Unknown device */
    case unknown(UInt16)

    public enum Inverter: Equatable {
        /** 1 tracker and 1phase Grid connect PV inverter TL */
        case oneTrackerOnePhaseTL(UInt16)
        /** 2 tracker and 1phase Grid connect PV inverter TL */
        case twoTrackerOnePhaseTL(UInt16)
        /** 1 tracker and 1phase Grid connect PV inverter HF */
        case oneTrackerOnePhaseHF(UInt16)
        /** 2 tracker and 1phase Grid connect PV inverter HF */
        case twoTrackerOnePhaseHF(UInt16)
        /** 1 tracker and 1phase Grid connect PV inverter LF */
        case oneTrackerOnePhaseLF(UInt16)
        /** 2 tracker and 1phase Grid connect PV inverter LF */
        case twoTrackerOnePhaseLF(UInt16)
        /** 1 tracker and 3phase Grid connect PV inverter TL */
        case oneTrackerThreePhaseTL(UInt16)
        /** 2 tracker and 3phase Grid connect PV inverter TL */
        case twoTrackerThreePhaseTL(UInt16)
        /** 1 tracker and 3phase Grid connect PV inverter LF */
        case oneTrackerThreePhaseLF(UInt16)
        /** 2 tracker and 3phase Grid connect PV inverter LF */
        case twoTrackerThreePhaseLF(UInt16)

        init?(_ value: UInt16) {
            switch value {
            case 100..<200:
                self = .oneTrackerOnePhaseTL(value)
            case 200..<300:
                self = .twoTrackerOnePhaseTL(value)
            case 300..<400:
                self = .oneTrackerOnePhaseHF(value)
            case 400..<500:
                self = .twoTrackerOnePhaseHF(value)
            case 500..<600:
                self = .oneTrackerOnePhaseLF(value)
            case 600..<700:
                self = .twoTrackerOnePhaseLF(value)
            case 700..<800:
                self = .oneTrackerThreePhaseTL(value)
            case 800..<900:
                self = .twoTrackerThreePhaseTL(value)
            case 900..<1000:
                self = .oneTrackerThreePhaseLF(value)
            case 1000..<1100:
                self = .twoTrackerThreePhaseLF(value)
            default:
                return nil
            }
        }

        var rawValue: UInt16 {
            switch self {
            case .oneTrackerOnePhaseTL(let value): return value
            case .twoTrackerOnePhaseTL(let value): return value
            case .oneTrackerOnePhaseHF(let value): return value
            case .twoTrackerOnePhaseHF(let value): return value
            case .oneTrackerOnePhaseLF(let value): return value
            case .twoTrackerOnePhaseLF(let value): return value
            case .oneTrackerThreePhaseTL(let value): return value
            case .twoTrackerThreePhaseTL(let value): return value
            case .oneTrackerThreePhaseLF(let value): return value
            case .twoTrackerThreePhaseLF(let value): return value
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
            self = .confluenceBox(value)
        case 3100..<3200:
            self = .pvStorage(value)
        case 3400..<3500:
            self = .offGrid(value)
        default:
            self = .unknown(value)
        }
    }

    var rawValue: UInt16 {
        switch self {
        case .inverter(let value): return value.rawValue
        case .dataLogger(let value): return value.rawValue
        case .confluenceBox(let value): return value
        case .pvStorage(let value): return value
        case .offGrid(let value): return value
        case .unknown(let value): return value
        }
    }
}

extension DeviceType: Equatable {

}
