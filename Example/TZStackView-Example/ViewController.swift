//
//  ViewController.swift
//  TZStackView-Example
//
//  Created by Tom van Zummeren on 20/06/15.
//  Copyright (c) 2015 Tom van Zummeren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    //--------------------------------------------------------------------------
    var tzStackView: TZStackView!
    
    let resetButton = UIButton.buttonWithType(.System) as! UIButton
    let instructionLabel = UILabel()
    
    var axisSegmentedControl:UISegmentedControl!
    var alignmentSegmentedControl:UISegmentedControl!
    var distributionSegmentedControl:UISegmentedControl!
    
    
    //MARK: - Lifecyle
    //--------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None;
        
        view.backgroundColor = UIColor.whiteColor()
        title = "TZStackView"
        
        tzStackView = TZStackView(arrangedSubviews: createViews())
        tzStackView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tzStackView.axis = .Vertical
        tzStackView.distribution = .Fill
        tzStackView.alignment = .Fill
        tzStackView.spacing = 15
        tzStackView.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(tzStackView)
        
        instructionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        instructionLabel.textColor = view.tintColor
        instructionLabel.font = UIFont.systemFontOfSize(15)
        instructionLabel.text = "Tap any of the boxes to set hidden=true"
        instructionLabel.numberOfLines = 0
        instructionLabel.setContentCompressionResistancePriority(900, forAxis: .Horizontal)
        view.addSubview(instructionLabel)
        
        resetButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        resetButton.setTitle("Reset", forState: .Normal)
        resetButton.addTarget(self, action: "reset", forControlEvents: .TouchUpInside)
        resetButton.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        resetButton.setContentHuggingPriority(1000, forAxis: .Horizontal)
        view.addSubview(resetButton)
        
        axisSegmentedControl = UISegmentedControl(items: ["Vertical", "Horizontal"])
        axisSegmentedControl.selectedSegmentIndex = 0
        axisSegmentedControl.addTarget(self, action: "axisChanged:", forControlEvents: .ValueChanged)
        axisSegmentedControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        axisSegmentedControl.setContentCompressionResistancePriority(900, forAxis: .Horizontal)
        view.addSubview(axisSegmentedControl)
        
        alignmentSegmentedControl = UISegmentedControl(items: ["Fill", "Center", "Leading", "Top", "Trailing", "Bottom", "FirstBaseline"])
        alignmentSegmentedControl.selectedSegmentIndex = 0
        alignmentSegmentedControl.addTarget(self, action: "alignmentChanged:", forControlEvents: .ValueChanged)
        alignmentSegmentedControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        alignmentSegmentedControl.setContentCompressionResistancePriority(1000, forAxis: .Horizontal)
        view.addSubview(alignmentSegmentedControl)
        
        distributionSegmentedControl = UISegmentedControl(items: ["Fill", "FillEqually", "FillProportionally", "EqualSpacing", "EqualCentering"])
        distributionSegmentedControl.selectedSegmentIndex = 0
        distributionSegmentedControl.addTarget(self, action: "distributionChanged:", forControlEvents: .ValueChanged)
        distributionSegmentedControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(distributionSegmentedControl)
        
        let views:[String: AnyObject] = [
            "instructionLabel": instructionLabel,
            "resetButton": resetButton,
            "axis": axisSegmentedControl,
            "align": alignmentSegmentedControl,
            "distrib": distributionSegmentedControl,
            "tzStackView": tzStackView
        ]
        let metrics:[String: AnyObject] = [
            "elementHeight": 30,
            "gap": 5,
        ]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-gap-[instructionLabel]-[resetButton]-gap-|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-gap-[axis]-gap-[distrib]-gap-|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-gap-[align]-gap-|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tzStackView]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-gap-[instructionLabel(elementHeight)]",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-gap-[resetButton(elementHeight)]",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[instructionLabel]-gap-[axis(elementHeight)]",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[instructionLabel]-gap-[distrib(elementHeight)]",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[axis]-gap-[align(elementHeight)]",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[align]-gap-[tzStackView]-|",
            options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
    }
    
    private func createViews() -> [UIView] {
        let redView = ExplicitIntrinsicContentSizeView(intrinsicContentSize: CGSize(width: 100, height: 100), name: "Red")
        let greenView = ExplicitIntrinsicContentSizeView(intrinsicContentSize: CGSize(width: 80, height: 80), name: "Green")
        let blueView = ExplicitIntrinsicContentSizeView(intrinsicContentSize: CGSize(width: 60, height: 60), name: "Blue")
        let purpleView = ExplicitIntrinsicContentSizeView(intrinsicContentSize: CGSize(width: 80, height: 80), name: "Purple")
        let yellowView = ExplicitIntrinsicContentSizeView(intrinsicContentSize: CGSize(width: 100, height: 100), name: "Yellow")
        
        redView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.75)
        greenView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.75)
        blueView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.75)
        purpleView.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.75)
        yellowView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.75)
        return [redView, greenView, blueView, purpleView, yellowView]
    }
    
    //MARK: - Button Actions
    //--------------------------------------------------------------------------
    func reset() {
        UIView.animateWithDuration(0.6, delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
            for view in self.tzStackView.arrangedSubviews {
                view.hidden = false
            }
            }, completion: nil)
        
    }
    
    //MARK: - Segmented Control Actions
    //--------------------------------------------------------------------------
    func axisChanged(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tzStackView.axis = .Vertical
        default:
            tzStackView.axis = .Horizontal
        }
    }
    
    func alignmentChanged(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tzStackView.alignment = .Fill
        case 1:
            tzStackView.alignment = .Center
        case 2:
            tzStackView.alignment = .Leading
        case 3:
            tzStackView.alignment = .Top
        case 4:
            tzStackView.alignment = .Trailing
        case 5:
            tzStackView.alignment = .Bottom
        default:
            tzStackView.alignment = .FirstBaseline
        }
        tzStackView.setNeedsUpdateConstraints()
    }
    
    func distributionChanged(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tzStackView.distribution = .Fill
        case 1:
            tzStackView.distribution = .FillEqually
        case 2:
            tzStackView.distribution = .FillProportionally
        case 3:
            tzStackView.distribution = .EqualSpacing
        default:
            tzStackView.distribution = .EqualCentering
        }
    }
}