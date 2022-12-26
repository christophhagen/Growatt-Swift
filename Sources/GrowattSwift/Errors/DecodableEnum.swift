import Foundation

protocol DecodableEnum {

    init(_ rawValue: UInt16)

    var rawValue: UInt16 { get }
}

protocol DecodableRegister: DecodableEnum {

    static var register: Int { get }

}
