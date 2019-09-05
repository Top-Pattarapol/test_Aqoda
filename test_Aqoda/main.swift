import Foundation

enum CommandKey: String {
    case createHotel = "create_hotel"
    case listAvailableRooms = "list_available_rooms"
    case listGuest = "list_guest"
    case listGuestByAge = "list_guest_by_age"
    case getGuestInRoom = "get_guest_in_room"
    case book = "book"
    case checkout = "checkout"
    case listGuestByFloor = "list_guest_by_floor"
    case checkoutGuestByFloor = "checkout_guest_by_floor"
    case bookByFloor = "book_by_floor"
}

enum CommonError: Error {
    case runtimeError(String)
}

var hotel: Hotel?

while true {
    if let response = readLine(),
        let responseArr: [String] = response.components(separatedBy: " "),
        let commandKey = CommandKey.init(rawValue: responseArr[0]) {
        switch commandKey {
        case .createHotel:
            guard let floor = Int(responseArr[1]), let room = Int(responseArr[2]) else { throw CommonError.runtimeError("can't convert data") }
            hotel = Hotel(floor: floor, room: room)
        case .listAvailableRooms:
            hotel?.listAvailableRooms()
        case .listGuest:
            hotel?.listGuest()
        case .listGuestByAge:
            guard let age = Int(responseArr[2]) else { throw CommonError.runtimeError("can't convert data") }
            hotel?.listGuestByAge(strO: responseArr[1], age: age)
        case .getGuestInRoom:
            hotel?.getGuestInRoom(data: responseArr[1])
        case .book:
            guard let age = Int(responseArr[3]) else { throw CommonError.runtimeError("can't convert data") }
            hotel?.book(room: responseArr[1], name: responseArr[2], age: age)
        case .checkout:
            guard let cardId = Int(responseArr[1]) else { throw CommonError.runtimeError("can't convert data") }
            hotel?.checkout(cardId: cardId, name: responseArr[2])
        case .listGuestByFloor:
            guard let floor = Int(responseArr[1]) else { throw CommonError.runtimeError("can't convert data") }
            hotel?.listGuestByFloor(floor: floor)
        case .checkoutGuestByFloor:
            guard let floor = Int(responseArr[1]) else { throw CommonError.runtimeError("can't convert data") }
            hotel?.checkoutGuestByFloor(floor: floor)
        case .bookByFloor:
            guard let floor = Int(responseArr[1]) ,let age = Int(responseArr[3]) else { throw CommonError.runtimeError("can't convert data") }
            hotel?.bookByFloor(floor: floor, name: responseArr[2], age: age)
        }
    } else {
        print("not found command")
    }
}


