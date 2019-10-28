//
//  Dragable.swift
//  MatchO
//
//  Created by Naveen Magatala on 10/27/19.
//  Copyright © 2019 Naveen Magatala. All rights reserved.
//

import UIKit

protocol Dragable { }

extension Dragable where Self: UIView {
    
    private func updateFrame(in view: UIView, updatedFrame: CGRect, translation: CGPoint) {
        let newX = updatedFrame.minX + translation.x
        let newY = updatedFrame.minY + translation.y
        let newFrame = CGRect(x: newX,
                              y: newY,
                              width: updatedFrame.width,
                              height: updatedFrame.height)
        
        guard view.safeAreaLayoutGuide.layoutFrame.contains(newFrame) else { return }
        
        frame = CGRect(x: newX,
                       y: newY,
                       width: updatedFrame.width,
                       height: updatedFrame.height)
    }
    
    func drag(with pan: UIPanGestureRecognizer,
              in view: UIView,
              updatedFrame: inout CGRect) {
        let translation = pan.translation(in: view)
        switch pan.state {
        case .changed:
            updateFrame(in: view, updatedFrame: updatedFrame, translation: translation)
        case .ended:
            updatedFrame = frame
        default:
            break
        }
    }
    
    func dragOnce(with pan: UIPanGestureRecognizer,
                  in view: UIView,
                  updatedFrame: CGRect) {
        let translation = pan.translation(in: view)
        switch pan.state {
        case .changed:
            updateFrame(in: view, updatedFrame: updatedFrame, translation: translation)
        default:
            break
        }
    }
}

extension UIView: Dragable { }
