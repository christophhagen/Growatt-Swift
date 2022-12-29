import Foundation

extension Status {

    struct PV {

        struct PVInstance {

            /** voltage (Volt) */
            let voltage: Float

            /** charge power (Watt) */
            let chargePower: Float

            /** Energy today (kWh) */
            let energyToday: Float

            /** PV 1 Energy total (kWh) */
            let energyTotal: Float
        }

        let pv1: PVInstance

        let pv2: PVInstance

        /** Fan speed of MPPT Charger (%) */
        let fanSpeedOfMpptCharger: Int

        init(data: [UInt16]) {
            self.fanSpeedOfMpptCharger = data.integer(at: 81)
            self.pv1 = .init(
                voltage: data.float(at: 1, scale: 10),
                chargePower: data.float(uint32At: 3, scale: 10),
                energyToday: data.float(uint32At: 48, scale: 10),
                energyTotal: data.float(uint32At: 50, scale: 10))
            self.pv2 = .init(
                voltage: data.float(at: 2, scale: 10),
                chargePower: data.float(uint32At: 5, scale: 10),
                energyToday: data.float(uint32At: 52, scale: 10),
                energyTotal: data.float(uint32At: 54, scale: 10))
        }

        func write(to data: inout [UInt16]) {
            data.write(fanSpeedOfMpptCharger, at: 81)
            data.write(pv1.voltage, at: 1, scale: 10)
            data.write(pv1.chargePower, asUint32At: 3, scale: 10)
            data.write(pv1.energyToday, asUint32At: 48, scale: 10)
            data.write(pv1.energyTotal, asUint32At: 50, scale: 10)
            data.write(pv2.voltage, at: 2, scale: 10)
            data.write(pv2.chargePower, asUint32At: 5, scale: 10)
            data.write(pv2.energyToday, asUint32At: 52, scale: 10)
            data.write(pv2.energyTotal, asUint32At: 54, scale: 10)
        }
    }
}

extension Status.PV: CustomStringConvertible {

    var description: String {
        """
        PV
          MPPT Fan Speed: \(fanSpeedOfMpptCharger) %
          PV 1
            Voltage: \(pv1.voltage) V
            Charge Power: \(pv1.chargePower) W
            Energy Today: \(pv1.energyToday) kWh
            Energy Total: \(pv1.energyTotal) kWh"
          PV 2
            Voltage: \(pv2.voltage) V
            Charge Power: \(pv2.chargePower) W
            Energy Today: \(pv2.energyToday) kWh
            Energy Total: \(pv2.energyTotal) kWh"
        """
    }
}
