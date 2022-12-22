import Foundation

extension Status {

    struct Battery {

        /** Battery volt (M3) (Volt) */
        let voltage: Float

        /** Battery SOC (%) */
        let stateOfCharge: Int

        /** Output DC Voltage (Volt) */
        let dcOutputVoltage: Float

        /** DC‐DC Temperature (°C) */
        let dcConverterTemperature: Float

        /** Battery‐port volt (DSP) (Volt) */
        let portVoltage: Float

        /** Battery‐bus volt (DSP) (Volt) */
        let busVoltage: Float

        /** Battery discharge Energy today (kWh) */
        let dischargeEnergyToday: Float

        /** Battery discharge Energy total (kWh) */
        let dischargeEnergyTotal: Float

        /** Battery discharge power (Watt) */
        let dischargePower: Float

        /** Battery discharge apparent power (VA) */
        let apparentDischargePower: Float

        /** Battery power (Watt)

         Positive: Battery Discharge Power
         Negative: Battery Charge Power
         */
        let power: Float

        /** Battery Over Charge Flag */
        let overcharge: Bool

        init(data: [UInt16]) {
            self.overcharge = data.bool(at: 80)
            self.voltage = data.float(at: 17, scale: 100)
            self.stateOfCharge = data.integer(at: 18)
            self.dcOutputVoltage = data.float(at: 24, scale: 10)
            self.dcConverterTemperature = data.float(at: 26, scale: 10)
            self.portVoltage = data.float(at: 28, scale: 100)
            self.busVoltage = data.float(at: 29, scale: 100)
            self.dischargeEnergyToday = data.float(uint32At: 60, scale: 10)
            self.dischargeEnergyTotal = data.float(uint32At: 62, scale: 10)
            self.dischargePower = data.float(uint32At: 73, scale: 10)
            self.apparentDischargePower = data.float(uint32At: 75, scale: 10)
            self.power = data.float(int32At: 77, scale: 10)
        }
    }
}

extension Status.Battery: CustomStringConvertible {

    var description: String {
        """
        Battery
          Overcharge: \(overcharge ? "Yes" : "No")
          Voltage: \(voltage) V
          State of Charge: \(stateOfCharge) %
          DC OutputVoltage: \(dcOutputVoltage) V
          DC Converter Temperature: \(dcConverterTemperature) °C
          Port Voltage: \(portVoltage) V
          Bus Voltage: \(busVoltage) V
          Discharge Energy Today: \(dischargeEnergyToday) kWh
          Discharge Energy Total: \(dischargeEnergyTotal) kWh
          Discharge Power: \(dischargePower) W
          Apparent Discharge Power: \(apparentDischargePower) VA
          Power: \(power) W
        """
    }
}
