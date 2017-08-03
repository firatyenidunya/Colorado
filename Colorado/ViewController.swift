//
//  ViewController.swift
//  Colorado
//
//  Created by Firat on 29/06/2017.
//  Copyright © 2017 Colorado. All rights reserved.
//

import Cocoa
import IOKit

@available(OSX 10.12.2, *)
class ViewController: NSObject {
  
    @IBOutlet weak var coloradoMenu: NSMenu!
    
    let coloradoPanel = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let mask : NSEventMask = [.mouseMoved, .leftMouseDown]

    var eventHandler : GlobalEventMonitor?
    
    override init() {
        super.init()
    }
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    var mouseLoc : CGPoint = .zero
    
    override func awakeFromNib() {
        
        coloradoPanel.menu?.font = NSFont(name: "Monaco", size: 12)
        coloradoPanel.menu = coloradoMenu
        coloradoPanel.title = "Colorado"
       
        eventHandler = GlobalEventMonitor(mask: self.mask, handler: { (mouseEvent: NSEvent?) in

            switch mouseEvent?.type.hashValue
            {
            case 0?:
                self.mouseLoc = NSEvent.mouseLocation()
                guard let color : NSColor = (self.getPixelColorAtMouseCursor()) else {
                    return
                }
                print(color.hexString)
                print(RGBColor.init(red: UInt16(color.redComponent), green: UInt16(color.greenComponent), blue: UInt16(color.blueComponent)))
                
                self.coloradoPanel.title = String(describing: color)

                break
            default:
                print("jeez")
            }
            
        })
        eventHandler?.start()
    }

    func getPixelColorAtMouseCursor() -> NSColor? {
        
        var displayForPoint = CGDirectDisplayID()
        var count = UInt32()
        
        let mouseLoc = NSEvent.mouseLocation()
        
        if CGGetDisplaysWithPoint(NSPointToCGPoint(mouseLoc), 1, &displayForPoint, &count) == CGError.failure {
            return nil
        }
        
        guard let image = CGDisplayCreateImage(displayForPoint, rect: CGRect(x: mouseLoc.x, y: mouseLoc.y, width: 1000, height: 1000)) else {
            return nil
        }
        
        let bitmap = NSBitmapImageRep(cgImage: image)
        
        return bitmap.colorAt(x: 0, y: 0)
    }
}
extension NSColor {
    
    var hexString: String {
        guard let rgbColor = usingColorSpaceName(NSCalibratedRGBColorSpace) else {
            return "FFFFFF"
        }
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
    
}
