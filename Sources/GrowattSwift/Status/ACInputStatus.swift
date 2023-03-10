import Foundation

public struct ACInputStatus {

    /** AC charge power (Watt) */
    public let chargePower: Float

    /** AC charge apparent power (VA) */
    public let apparentChargePower: Float

    /** Bus Voltage (Volt) */
    public let busVoltage: Float

    /** AC input Volt (Volt) */
    public let inputVoltage: Float

    /** AC input frequency (Hz) */
    public let inputFrequency: Float

    /** AC input power (W) */
    public let inputPower: Float

    /** AC input apparent power (VA) */
    public let apparentInputPower: Float

    /** AC charge Energy today (kWh) */
    public let chargeEnergyToday: Float

    /** AC charge Energy total (kWh) */
    public let chargeEnergyTotal: Float

    /** AC Charge Battery Current (A) */
    public let batteryChargeCurrent: Float

    init(data: [UInt16]) {
        self.chargePower = data.float(uint32At: 13, scale: 10)
        self.apparentChargePower = data.float(uint32At: 15, scale: 10)
        self.busVoltage = data.float(at: 19, scale: 10)
        self.inputVoltage = data.float(at: 20, scale: 10)
        self.inputFrequency = data.float(at: 21, scale: 100)
        self.inputPower = data.float(uint32At: 36, scale: 10)
        self.apparentInputPower = data.float(uint32At: 38, scale: 10)
        self.chargeEnergyToday = data.float(uint32At: 56, scale: 10)
        self.chargeEnergyTotal = data.float(uint32At: 58, scale: 10)
        self.batteryChargeCurrent = data.float(uint32At: 68, scale: 10)
    }

    func write(to data: inout [UInt16]) {
        data.write(chargePower, asUint32At: 13, scale: 10)
        data.write(apparentChargePower, asUint32At: 15, scale: 10)
        data.write(busVoltage, at: 19, scale: 10)
        data.write(inputVoltage, at: 20, scale: 10)
        data.write(inputFrequency, at: 21, scale: 100)
        data.write(inputPower, at: 36, scale: 10)
        data.write(apparentInputPower, asUint32At: 38, scale: 10)
        data.write(chargeEnergyToday, asUint32At: 56, scale: 10)
        data.write(chargeEnergyTotal, asUint32At: 58, scale: 10)
        data.write(batteryChargeCurrent, asUint32At: 68, scale: 10)
    }
}

extension ACInputStatus: CustomStringConvertible {

    public var description: String {
        """
        AC Input
          Charge Power: \(chargePower) W
          Apparent Charge Power: \(apparentChargePower) VA
          Bus Voltage: \(busVoltage) V
          Input Voltage: \(inputVoltage) V
          Input Frequency: \(inputFrequency) Hz
          Input Power: \(inputPower) W
          Apparent Input Power: \(apparentInputPower) VA
          Charge Energy Today: \(chargeEnergyToday) kWh
          Charge Energy Total: \(chargeEnergyTotal) kWh
          Battery Charge Current: \(batteryChargeCurrent) A
        """
    }
}

extension ACInputStatus: Equatable {

}
