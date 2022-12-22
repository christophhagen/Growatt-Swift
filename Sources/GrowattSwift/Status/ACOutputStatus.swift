import Foundation

extension Status {

    struct ACOutput {

        struct BuckConverter {

            /** Buck converter current (Ampere) */
            let current: Float

            /** Buck converter temperature (°C) */
            let temperature: Float
        }

        let buck1: BuckConverter

        let buck2: BuckConverter

        /** Output active power (Watt) */
        let activePower: Float

        /** Output apparent power (VA) */
        let apparentPower: Float

        /** AC output Volt (Volt) */
        let outputVoltage: Float

        /** AC output frequency (Hz) */
        let outputFrequency: Float

        /** Inverter Temperature (°C) */
        let inverterTemperature: Float

        /** Load percentage (%) */
        let loadPercentage: Float

        /** Output Current (A) */
        let outputCurrent: Float

        /** Inverter Current (A) */
        let inverterCurrent: Float

        /** AC discharge Energy today (kWh) */
        let dischargeEnergyToday: Float

        /** AC discharge Energy total (kWh) */
        let dischargeEnergyTotal: Float

        /** AC discharge power (W) */
        let dischargePower: Float

        /** AC discharge apparent power (VA) */
        let apparentDischargePower: Float

        /** Fan speed of Inverter (%) */
        let fanSpeedOfInverter: Int

        init(data: [UInt16]) {
            self.buck1 = .init(
                current: data.float(at: 7, scale: 10),
                temperature: data.float(at: 32, scale: 10))
            self.buck2 = .init(
                current: data.float(at: 8, scale: 10),
                temperature: data.float(at: 33, scale: 10))
            self.activePower = data.float(uint32At: 9, scale: 10)
            self.apparentPower = data.float(uint32At: 11, scale: 10)
            self.outputVoltage = data.float(at: 22, scale: 10)
            self.outputFrequency = data.float(at: 23, scale: 100)
            self.inverterTemperature = data.float(at: 25, scale: 10)
            self.loadPercentage = data.float(at: 27, scale: 10)
            self.outputCurrent = data.float(at: 34, scale: 10)
            self.inverterCurrent = data.float(at: 35, scale: 10)
            self.dischargeEnergyToday = data.float(uint32At: 64, scale: 10)
            self.dischargeEnergyTotal = data.float(uint32At: 66, scale: 10)
            self.dischargePower = data.float(at: 69, scale: 10)
            self.apparentDischargePower = data.float(uint32At: 71, scale: 10)
            self.fanSpeedOfInverter = data.integer(at: 82)
        }
    }
}

extension Status.ACOutput: CustomStringConvertible {

    var description: String {
        """
        AC Output
          Buck Converter 1
            Current: \(buck1.current) A
            Temperature: \(buck1.temperature) °C
          Buck Converter 2
            Current: \(buck2.current) A
            Temperature: \(buck2.temperature) °C
          Active Power: \(activePower) W
          Apparent Power: \(apparentPower) VA
          Current: \(outputCurrent) A
          Voltage: \(outputVoltage) V
          Frequency: \(outputFrequency) Hz
          Inverter Temperature: \(inverterTemperature) °C
          Load: \(loadPercentage) %
          Energy Discharge Today: \(dischargeEnergyToday) kWh
          Energy Discharge Total: \(dischargeEnergyTotal) kWh
          Discharge Power: \(dischargePower) W
          Apparent Discharge Power: \(apparentDischargePower) VA
          Inverter Fan Speed: \(fanSpeedOfInverter) %
        """
    }

}
