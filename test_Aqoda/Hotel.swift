//
//  hotel.swift
//  Aqoda
//
//  Created by pattarapol sawasdee on 5/9/2562 BE.
//  Copyright © 2562 pattarapol. All rights reserved.
//

import Foundation

class Hotel {

    var rooms: [[Room]] = []
    var guests: [String: Customer] = [:]
    var keyCard: [Int: String?] = [:]

    init(floor: Int, room: Int) {
        let newHotel = createHotel(floor, room)
        rooms = newHotel
        print("Hotel created with \(floor) floor(s), \(room) room(s) per floor.")
    }

    func createHotel(_ floor: Int, _ room: Int) -> [[Room]] {
        var newHotel: [[Room]] = []
        for x in 0...floor-1 {
            var listRoom: [Room] = []
            for y in 0...room-1 {
                let roomNumber = y + 1 > 10 ? "\(y + 1)" : "0\(y + 1)"
                let newRoom = Room.init(customer: nil, cardId: nil, name: "\(x + 1)\(roomNumber)")
                listRoom.append(newRoom)
            }
            newHotel.append(listRoom)
        }
        return newHotel
    }

    func getGuestInRoom(data: String) {
        guard let floor = Int(data.prefix(1).lowercased()),
            let roomNumber = Int(data.suffix(2).lowercased()),
            let output = rooms[floor-1][roomNumber-1].customer?.name else { return }
        print(output)
    }

    func book(room: String, name: String, age: Int) {
        guard let floor = Int(room.prefix(1).lowercased()),
            let roomNumber = Int(room.suffix(2).lowercased()) else { return }

        let roomData = rooms[floor-1][roomNumber-1]
        if roomData.isCheckin {
            print("Cannot book room \(room) for \(name), The room is currently booked by \(roomData.customer?.name ?? "").")
            return
        }
        checkIn(floor: floor,roomNumber: roomNumber, name: name, age: age)
        print("Room \(room) is booked by \(name) with keycard number \(rooms[floor-1][roomNumber-1].cardId ?? 0).")
    }

    func checkIn(floor: Int,roomNumber: Int, name: String, age: Int) {
        let newCustomer = Customer(name: name, age: age)
        var room = rooms[floor-1][roomNumber-1]
        room.customer = newCustomer
        room.cardId = getAvailableKeyCard(roomNumber: room.name)
        rooms[floor-1][roomNumber-1] = room
        if guests[name] != nil {
            guests[name]?.roomCount += 1
        } else {
            guests[name] = newCustomer
        }
    }

    func checkout(cardId: Int, name: String) {
        guard let card = getRoomFormCard(cardId: cardId),
            let floor = Int(card.prefix(1).lowercased()),
            let roomNumber = Int(card.suffix(2).lowercased()) else { return }

        var room = rooms[floor-1][roomNumber-1]
        guard room.customer?.name == name else {
            print("Only \(room.customer?.name ?? "") can checkout with keycard number \(cardId).")
            return
        }
        if var guest = guests[name] {
            guest.roomCount -= 1
        }
        if let cardId = room.cardId {
            returnKeyCard(id: cardId)
        }
        room.checkOut()
        print("Room \(room.name) is checkout.")
    }

    func getAvailableKeyCard(roomNumber: String) -> Int {
        var cardId = 1
        while true {
            if (keyCard[cardId] != nil) {
                cardId += 1
            }else {
                keyCard[cardId] = roomNumber
                return cardId
            }
        }
    }

    func returnKeyCard(id: Int) {
        keyCard[id] = nil
    }

    func getRoomFormCard(cardId: Int) -> String? {
        let card = keyCard[cardId]
        return card as? String
    }

    func checkoutGuestByFloor(floor: Int) {
        var outStr = "Room "
        for (index, room) in rooms[floor-1].enumerated() {
            guard room.isCheckin else { continue }

            let roomNumber = index + 1 > 10 ? "\(index + 1)" : "0\(index + 1)"
            outStr += "\(floor)\(roomNumber), "

            if let cardId = room.cardId {
                returnKeyCard(id: cardId)
            }
            rooms[floor-1][index].customer = nil
            rooms[floor-1][index].cardId = nil
        }
        if outStr.count > 0 {
            outStr.removeLast(2)
        }
        outStr += " are checkout."
        print(outStr)
    }

    func bookByFloor(floor: Int, name: String, age: Int) {
        var outStr = "Room "
        var outCard = ""
        for room in rooms[floor-1] {
            guard room.isCheckin else { continue }
            print("Cannot book floor \(floor) for \(name).")
            return
        }

        for (index, room) in rooms[floor-1].enumerated() {
            checkIn(floor: floor,roomNumber: index+1, name: name, age: age)
            outStr += "\(room.name), "
            if let cardId = rooms[floor-1][index].cardId {
                outCard += "\(cardId), "
            }
        }
        if outStr.count > 0 {
            outStr.removeLast(2)
        }
        if outCard.count > 0 {
            outCard.removeLast(2)
        }
        outStr += " are booked with keycard number "
        outStr += outCard
        print(outStr)
    }


}

extension Hotel {

    func listAvailableRooms() {
        var outStr = ""
        for floor in rooms {
            for room in floor {
                guard !room.isCheckin else { continue }
                outStr += "\(room.name), "
            }
        }
        if outStr.count > 0 {
            outStr.removeLast(2)
        }
        print(outStr)
    }

    func listGuest() {
        var outStr = ""
        for (name, data) in guests {
            if data.roomCount > 0 {
                outStr += "\(name), "
            }
        }
        if outStr.count > 0 {
            outStr.removeLast(2)
        }
        print(outStr)
    }

    func listGuestByAge(strO: String, age: Int) {
        var outStr = ""
        switch strO {
        case "<":
            for (name, data) in guests {
                if data.age < age {
                    outStr += "\(name), "
                }
            }
        case ">":
            for (name, data) in guests {
                if data.age > age {
                    outStr += "\(name), "
                }
            }
        case "=", "==":
            for (name, data) in guests {
                if data.age == age {
                    outStr += "\(name), "
                }
            }
        default:
            return
        }
        if outStr.count > 0 {
            outStr.removeLast(2)
        }
        print(outStr)
    }

    func listGuestByFloor(floor: Int) {
        var outStr = ""
        for room in rooms[floor-1] {
            guard room.isCheckin else { continue }
            outStr += "\(room.customer?.name ?? ""), "
        }
        if outStr.count > 0 {
            outStr.removeLast(2)
        }
        print(outStr)
    }

}
