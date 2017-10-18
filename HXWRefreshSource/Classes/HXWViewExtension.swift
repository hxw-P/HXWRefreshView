//
//  HXWViewExtension.swift
//  51DESK
//
//  Created by 51desk on 2017/8/30.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

public extension UIView {
    
    var x : CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var oldFrame = frame
            oldFrame.origin.x = newValue
            frame = oldFrame
        }
    }
    
    var y : CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var oldFrame = frame
            oldFrame.origin.y = newValue
            frame = oldFrame
        }
    }
    
    var width : CGFloat {
        get {
            return frame.size.width
        }
        set(newValue) {
            var oldFrame = frame
            oldFrame.size.width = newValue
            frame = oldFrame
        }
    }
    
    var height : CGFloat {
        get {
            return frame.size.height
        }
        set(newValue) {
            var oldFrame = frame
            oldFrame.size.height = newValue
            frame = oldFrame
        }
    }
    
    var top : CGFloat {
        get {
            return y
        }
    }
    
    var left : CGFloat {
        get {
            return x
        }
    }
    
    var bottom : CGFloat {
        get {
            return (frame.size.height + y)
        }
    }
    
    var right : CGFloat {
        get {
            return (frame.size.width + x)
        }
    }
    
}
