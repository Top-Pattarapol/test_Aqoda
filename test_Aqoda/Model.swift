//
//  model.swift
//  Aqoda
//
//  Created by pattarapol sawasdee on 5/9/2562 BE.
//  Copyright © 2562 pattarapol. All rights reserved.
//

import Foundation

struct Customer {
    let name: String
    let age: Int
    var roomCount: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
        self.roomCount = 1
    }
}

struct Room  {
    var isCheckin: Bool {
        get {
            return customer == nil ? false : true
        }
    }
    var customer: Customer?
    var cardId: Int?
    var name: String

    mutating func checkIn(customer: Customer, cardId: Int) {
        self.customer = customer
        self.cardId = cardId
    }

    mutating func checkOut() {
        self.customer = nil
        self.cardId = nil
    }

}
