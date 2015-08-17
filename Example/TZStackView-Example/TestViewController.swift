/*******************************************************************************
* TestViewController.swift by Yoam Farges on 17/08/2015
*   Copyright (c) 2015 Tom van Zummeren. All rights reserved.
*******************************************************************************/

import UIKit

class TestViewController: UIViewController {
    var customView:TestView!
    
    override func loadView() {
        super.loadView()
        view = TestView()
        customView = view as! TestView
        customView.axisSegmentedControl.addTarget(self, action: "axisChanged:", forControlEvents: .ValueChanged)
        customView.alignmentSegmentedControl.addTarget(self, action: "alignmentChanged:", forControlEvents: .ValueChanged)
        customView.distributionSegmentedControl.addTarget(self, action: "distributionChanged:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None;
        title = "StackView"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.Plain, target: self, action: "reset")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "See TZStackView", style: UIBarButtonItemStyle.Plain, target: self, action: "showTZStackView")
    }

    
    //MARK: - Button actions
    //--------------------------------------------------------------------------
    func showTZStackView() {
        navigationController?.pushViewController(TZViewController(), animated: true)
    }
    
    func reset() {
        UIView.animateWithDuration(0.6, delay:0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .AllowUserInteraction, animations: {
            for view in self.customView.stackView.arrangedSubviews {
                view.hidden = false
            }
            }, completion: nil)
    }
    
    //MARK: - Segmented Control actions
    //--------------------------------------------------------------------------
    func axisChanged(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customView.stackView.axis = .Vertical
        default:
            customView.stackView.axis = .Horizontal
        }
    }
    
    func alignmentChanged(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customView.stackView.alignment = .Fill
        case 1:
            customView.stackView.alignment = .Center
        case 2:
            customView.stackView.alignment = .Leading
        case 3:
            customView.stackView.alignment = .Top
        case 4:
            customView.stackView.alignment = .Trailing
        case 5:
            customView.stackView.alignment = .Bottom
        default:
            customView.stackView.alignment = .FirstBaseline
        }
    }
    
    func distributionChanged(sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            customView.stackView.distribution = .Fill
        case 1:
            customView.stackView.distribution = .FillEqually
        case 2:
            customView.stackView.distribution = .FillProportionally
        case 3:
            customView.stackView.distribution = .EqualSpacing
        default:
            customView.stackView.distribution = .EqualCentering
        }
    }
}

