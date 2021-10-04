//
//  Observable.swift
//  3bit_app
//
//  Created by Jeytery on 02.09.2021.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import Foundation

class Observable<T> {
    
    class Subscriber {
        let id: String
        let action: (T) -> Void
        init(id: String, action: @escaping (T) -> Void) {
            self.id = id
            self.action = action
        }
    }
    
    var value: T? {
        didSet {
            for subsriber in subscribers { subsriber.action(value!) }
        }
    }
    
    private var subscribers = Array<Subscriber>()
    
    init(_ value: T? = nil) { self.value = value }
    
    private func isIdExist(_ id: String) -> Bool {
        for sub in subscribers {
            if sub.id == id { return true}
        }
        return false
    }
}

extension Observable {
    func subscribe(onUpdate handler: @escaping (T) -> Void) {
        let sub = Subscriber(id: String(subscribers.count + 1), action: handler)
        subscribers.append(sub)
    }
    
    func subscribe(id: String, onUpdate handler: @escaping (T) -> Void) {
        if isIdExist(id) { return }
        let sub = Subscriber(id: id, action: handler)
        subscribers.append(sub)
    }
}
