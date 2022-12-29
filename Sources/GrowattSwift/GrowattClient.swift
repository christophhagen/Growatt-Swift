import Foundation
import  SwiftLibModbus

/**
 A connection to a Growatt Inverter.
 - Note: The only device tested is the Growatt SPF 5000 ES.
 */
public struct GrowattClient {

    /**
     The path to the interface where the Growatt inverter is connected, e.g. `/dev/serial1`
     */
    public let devicePath: String

    /**
     The baudrate used for the connection.
     */
    public let baudRate: Int

    /** The Modbus device used for communication */
    public let device: ModbusDevice

    /**
     Create a new client to communicate with a Growatt device over Modbus.

     - Note: The only device tested is the Growatt SPF 5000 ES.
     - Parameter path: The path to the device, e.g. `/dev/serial1`
     - Parameter slaveId: The ID of the Growatt
     - Parameter baudRate: The baud rate to use
     - Parameter dataBits: The number of data bits
     - Parameter parity: The parity setting
     - Parameter reconnectDelay: Disconnect after a certain interval. Set to zero to disable.
     - Parameter disconnectDelay: The number of seconds to wait before disconnect on idle. Set to zero to disable.
     */
    public init(path: String, slaveId: Int = 1, baudRate: Int = 9600, dataBits: Int = 8, parity: ModbusParity = .none, stopBits: Int = 1, autoReconnectAfter reconnectDelay: TimeInterval = 0.0, disconnectWhenIdleAfter disconnectDelay: TimeInterval = 10.0) throws {
        self.devicePath = path
        self.baudRate = baudRate
        self.device = try ModbusDevice(
            device: path,
            slaveid: slaveId,
            baudRate: baudRate,
            dataBits: dataBits,
            parity: parity,
            stopBits: stopBits,
            autoReconnectAfter: reconnectDelay,
            disconnectWhenIdleAfter: disconnectDelay)
    }

    /**
     Read the current configuration asynchronously.
     - Returns: The configuration read from the device
     */
    public func readConfiguration() async throws -> Configuration {
        let data: [UInt16] = try await device.readHoldingRegisters(from: 0, count: 81)
        return Configuration(data: data)
    }

    /**
     Read the current status of the device.
     - Throws: `DataError`, if not enough bytes where received
     - Throws: `ContentError`, if any register values could not be decoded
     - Returns: The current status of the device
     */
    public func readStatus() async throws -> Status {
        let data: [UInt16] = try await device.readInputRegisters(from: 0, count: 83)
        return Status(data: data)
    }
}
