import Foundation

public struct ACOutputStatus {

    public struct BuckConverter: Equatable {

        /** Buck converter current (Ampere) */
        public let current: Float

        /** Buck converter temperature (°C) */
        public let temperature: Float
    }

    public let buck1: BuckConverter

    public let buck2: BuckConverter

    /** Output active power (Watt) */
    public let activePower: Float

    /** Output apparent power (VA) */
    public let apparentPower: Float

    /** AC output Volt (Volt) */
    public let outputVoltage: Float

    /** AC output frequency (Hz) */
    public let outputFrequency: Float

    /** Inverter Temperature (°C) */
    public let inverterTemperature: Float

    /** Load percentage (%) */
    public let loadPercentage: Float

    /** Output Current (A) */
    public let outputCurrent: Float

    /** Inverter Current (A) */
    public let inverterCurrent: Float

    /** AC discharge Energy today (kWh) */
    public let dischargeEnergyToday: Float

    /** AC discharge Energy total (kWh) */
    public let dischargeEnergyTotal: Float

    /** AC discharge power (W) */
    public let dischargePower: Float

    /** AC discharge apparent power (VA) */
    public let apparentDischargePower: Float

    /** Fan speed of Inverter (%) */
    public let fanSpeedOfInverter: Int

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

    func write(to data: inout [UInt16]) {
        data.write(buck1.current, at: 7, scale: 10)
        data.write(buck1.temperature, at: 32, scale: 10)
        data.write(buck2.current, at: 8, scale: 10)
        data.write(buck2.temperature, at: 33, scale: 10)
        data.write(activePower, asUint32At: 9, scale: 10)
        data.write(apparentPower, asUint32At: 11, scale: 10)
        data.write(outputVoltage, at: 22, scale: 10)
        data.write(outputFrequency, at: 23, scale: 100)
        data.write(inverterTemperature, at: 25, scale: 10)
        data.write(loadPercentage, at: 27, scale: 10)
        data.write(outputCurrent, at: 34, scale: 10)
        data.write(inverterCurrent, at: 35, scale: 10)
        data.write(dischargeEnergyToday, asUint32At: 64, scale: 10)
        data.write(dischargeEnergyTotal, asUint32At: 66, scale: 10)
        data.write(dischargePower, at: 69, scale: 10)
        data.write(apparentDischargePower, asUint32At: 71, scale: 10)
        data.write(fanSpeedOfInverter, at: 82)
    }
}

extension ACOutputStatus: CustomStringConvertible {

    public var description: String {
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

extension ACOutputStatus: Equatable {

}
