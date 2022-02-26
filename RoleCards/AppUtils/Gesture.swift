//
//  CardGesture.swift
//  RoleCards
//
//  Created by Jeytery on 11.02.2022.
//

import UIKit

class Gesture {
    @objc func getGesture(_ sender: UIPanGestureRecognizer) {
        let view = sender.view!
        switch sender.state {
        case .began:
            gestureDidStart(sender, view: view)
            break
        case .changed:
            gestureDidChange(sender, view: view)
            break
        case .ended:
            gestureDidEnd(sender, view: view)
            break
        case .cancelled:
            gestureDidCanceled(sender, view: view)
            break
        default:
            break
        }
    }
    
    func gestureDidCanceled(_ sender: UIPanGestureRecognizer, view: UIView) {}
    
    func gestureDidChange(_ sender: UIPanGestureRecognizer, view: UIView) {}
    func gestureDidStart (_ sender: UIPanGestureRecognizer, view: UIView) {}
    func gestureDidEnd   (_ sender: UIPanGestureRecognizer, view: UIView) {}
}

