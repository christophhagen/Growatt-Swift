import Foundation

protocol DecodableEnum {

    init(_ rawValue: UInt16)
}

protocol DecodableRegister: DecodableEnum {

    static var register: Int { get }

}
