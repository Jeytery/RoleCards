//
//  ServiceSession.swift
//  RoleCards
//
//  Created by Jeytery on 29.04.2021.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import Foundation

class ServiceSession {

    private let interval: TimeInterval
    private var timer: Timer!
    private let task: () -> Void

    init(interval: TimeInterval = 5, task: @escaping () -> Void) {
        self.task = task
        self.interval = interval
    }
}

//MARK: - public
extension ServiceSession {
    func start() {
        DispatchQueue
            .global(qos: .background)
            .async
        {
            [weak self] in
            self?.timer = Timer(
                timeInterval: self?.interval ?? 1,
                repeats: true)
            {
                _ in
                self?.task()
            }
            guard let timer = self?.timer else { return }
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: .default)
            runLoop.run()
        }
    }

    func stop() {
        timer.invalidate()
    }
}
