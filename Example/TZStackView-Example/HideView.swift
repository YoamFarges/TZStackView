/*******************************************************************************
* HideView.swift by Yoam Farges on 17/08/2015
*   Copyright (c) 2015 Tom van Zummeren. All rights reserved.
*******************************************************************************/

import UIKit

class HideView: UIView {
    init() {
        super.init(frame: CGRectZero)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tap")
        addGestureRecognizer(gestureRecognizer)
        userInteractionEnabled = true
    }
    
    func tap() {
        UIView.animateWithDuration(0.6, delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
            self.hidden = true
            }, completion: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
