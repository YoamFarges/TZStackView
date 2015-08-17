/*******************************************************************************
* TestViewController.swift by Yoam Farges on 17/08/2015
*   Copyright (c) 2015 Tom van Zummeren. All rights reserved.
*******************************************************************************/

import UIKit

class TestViewController: UIViewController {
    
    var tzStackView: TZStackView!
    
    let resetButton = UIButton.buttonWithType(.System) as! UIButton
    
    let instructionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tzStackView = TZStackView(arrangedSubviews: createViews())
        tzStackView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tzStackView.axis = .Vertical
        tzStackView.distribution = .Fill
        tzStackView.alignment = .Center
        tzStackView.spacing = 15
        view.addSubview(tzStackView)
        
        instructionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        instructionLabel.textColor = UIColor.whiteColor()
        instructionLabel.font = UIFont.systemFontOfSize(15)
        instructionLabel.text = "Tap any of the boxes to set hidden=true"
        instructionLabel.numberOfLines = 0
        instructionLabel.setContentCompressionResistancePriority(900, forAxis: .Horizontal)
        view.addSubview(instructionLabel)
        
        resetButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        resetButton.setTitle("reset", forState: .Normal)
        resetButton.addTarget(self, action: "reset", forControlEvents: .TouchUpInside)
        resetButton.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        resetButton.setContentHuggingPriority(1000, forAxis: .Horizontal)
        view.addSubview(resetButton)
        
        let views:[String: AnyObject] = ["tzStackView": tzStackView, "resetButton": resetButton, "instructionLabel": instructionLabel]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[instructionLabel]-[resetButton]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[resetButton(44)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[instructionLabel(44)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[tzStackView]-15-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[instructionLabel]-15-[tzStackView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    func reset() {
        UIView.animateWithDuration(0.6, delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
            for view in self.tzStackView.arrangedSubviews {
                view.hidden = false
            }
            }, completion: nil)
    }
    
    private func createViews() -> [UIView] {
        let redView = AutoHideView()
        let greenView = AutoHideView()
        let blueView = AutoHideView()
        let purpleView = AutoHideView()
        let yellowView = AutoHideView()
        
        let rect100 = CGRectMake(0, 0, 100, 100)
        let rect75 = CGRectMake(0, 0, 75, 75)
        let rect50 = CGRectMake(0, 0, 50, 50)
        
        redView.frame = rect100
        greenView.frame = rect75
        blueView.frame = rect50
        purpleView.frame = rect75
        yellowView.frame = rect100
        
        redView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.75)
        greenView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.75)
        blueView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.75)
        purpleView.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.75)
        yellowView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.75)
        return [redView, greenView, blueView, purpleView, yellowView]
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

