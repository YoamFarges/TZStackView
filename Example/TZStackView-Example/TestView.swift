//
//  TestView.swift
//  TZStackView-Example
//
//  Created by Yoam Farges on 17/08/2015.
//  Copyright (c) 2015 Tom van Zummeren. All rights reserved.
//

import UIKit

class TestView: UIView {
    let stackView: StackView
    let axisSegmentedControl:UISegmentedControl
    let alignmentSegmentedControl:UISegmentedControl
    let distributionSegmentedControl:UISegmentedControl
    
    override init(frame: CGRect) {
        let redView = HideView()
        let greenView = HideView()
        let blueView = HideView()
        let purpleView = HideView()
        let yellowView = HideView()
        
        let rect100 = CGRectMake(0, 0, 100, 100)
        let rect75 = CGRectMake(0, 0, 75, 75)
        let rect50 = CGRectMake(0, 0, 50, 50)
        
        redView.frame = rect100
        greenView.frame = rect75
        blueView.frame = rect50
        purpleView.frame = rect75
        yellowView.frame = rect100
        
        stackView = StackView(arrangedSubviews: [redView, greenView, blueView, purpleView, yellowView])
        stackView.axis = .Vertical
        stackView.distribution = .Fill
        stackView.alignment = .Fill
        stackView.spacing = 15
        
        axisSegmentedControl = UISegmentedControl(items: ["Vertical", "Horizontal"])
        axisSegmentedControl.selectedSegmentIndex = 0
        alignmentSegmentedControl = UISegmentedControl(items: ["Fill", "Center", "Leading", "Top", "Trailing", "Bottom", "FirstBaseline"])
        alignmentSegmentedControl.selectedSegmentIndex = 0
        distributionSegmentedControl = UISegmentedControl(items: ["Fill", "FillEqually", "FillProportionally", "EqualSpacing", "EqualCentering"])
        distributionSegmentedControl.selectedSegmentIndex = 0
        
        super.init(frame: frame)
        
        addSubview(stackView)
        addSubview(axisSegmentedControl)
        addSubview(alignmentSegmentedControl)
        addSubview(distributionSegmentedControl)
        
        redView.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.75)
        greenView.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.75)
        blueView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.75)
        purpleView.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.75)
        yellowView.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.75)
        stackView.backgroundColor = UIColor.lightGrayColor()
        backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let gap:CGFloat = 5
        let width = bounds.size.width - gap * 2
        
        var xPos:CGFloat = gap
        var yPos:CGFloat = gap
        
        //Axis
        var rect:CGRect = axisSegmentedControl.frame
        rect.origin.x = xPos
        rect.origin.y = yPos
        rect.size.width = width  * 30 / 100 - gap
        axisSegmentedControl.frame = rect
        xPos += rect.origin.x + rect.width + gap
        
        //Distribution
        rect = distributionSegmentedControl.frame
        rect.origin.x = xPos
        rect.origin.y = yPos
        rect.size.width = width * 70 / 100 - gap
        distributionSegmentedControl.frame = rect
        xPos = gap
        yPos += gap + rect.height
        
        //Alignment
        rect = alignmentSegmentedControl.frame
        rect.origin.x = xPos
        rect.origin.y = yPos
        rect.size.width = width
        alignmentSegmentedControl.frame = rect
        yPos += gap + rect.height
        
        //StackView
        rect = stackView.frame
        rect.origin.x = 0
        rect.origin.y = yPos
        rect.size.height = bounds.size.height - yPos
        rect.size.width = bounds.size.width
        stackView.frame = rect
    }
}
