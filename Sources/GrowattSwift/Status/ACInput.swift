import Foundation

extension Status {

    struct ACInput {

        /** AC charge power (Watt) */
        let chargePower: Float

        /** AC charge apparent power (VA) */
        let apparentChargePower: Float

        /** Bus Voltage (Volt) */
        let busVoltage: Float

        /** AC input Volt (Volt) */
        let inputVoltage: Float

        /** AC input frequency (Hz) */
        let inputFrequency: Float

        /** AC input power (W) */
        let inputPower: Float

        /** AC input apparent power (VA) */
        let apparentInputPower: Float

        /** AC charge Energy today (kWh) */
        let chargeEnergyToday: Float

        /** AC charge Energy total (kWh) */
        let chargeEnergyTotal: Float

        /** AC Charge Battery Current (A) */
        let batteryChargeCurrent: Float

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
    }
}

extension Status.ACInput: CustomStringConvertible {

    var description: String {
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
