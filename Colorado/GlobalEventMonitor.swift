//
//  GlobalEventMonitor.swift
//  Colorado
//
//  Created by Firat on 30/06/2017.
//  Copyright © 2017 Colorado. All rights reserved.
//

import Foundation
import Cocoa

public class GlobalEventMonitor {
    
    private var monitor: AnyObject?
    private let mask: NSEventMask
    private let handler: (NSEvent?) -> ()
    
    var eventHandler : GlobalEventMonitor?

    public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
