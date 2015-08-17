//  StackView.swift
//  TZStackView created from Tom van Zummeren on 10/06/15.
//  StackView is a fork made by Yoam Farges on 17/08/15.
//  MIT Licence (see LICENCE file)
//  Copyright (c) 2015 Tom van Zummeren

import UIKit

struct AnimationDidStopQueueEntry: Equatable {
    let view: UIView
    let hidden: Bool
}

func ==(lhs: AnimationDidStopQueueEntry, rhs: AnimationDidStopQueueEntry) -> Bool {
    return lhs.view === rhs.view
}

public class StackView: UIView {
    
    //MARK: - Public properties
    //--------------------------------------------------------------------------
    public var distribution: StackViewDistribution = .Fill {
        didSet {
            setNeedsLayout()
        }
    }

    public var axis: UILayoutConstraintAxis = .Horizontal {
        didSet {
            setNeedsLayout()
        }
    }
    public var alignment: StackViewAlignment = .Fill {
        didSet {
            setNeedsLayout()
        }
    }
    public var spacing: CGFloat = 0
    public var layoutMarginsRelativeArrangement = false

    //MARK: - Private properties
    //--------------------------------------------------------------------------
    private var kvoContext = UInt8()
    private var registeredKvoSubviews = [UIView]()
    private var animatingToHiddenViews = [UIView]()
    private var animationDidStopQueueEntries = [AnimationDidStopQueueEntry]()

    private(set) var arrangedSubviews: [UIView] = [] {
        didSet {
            setNeedsUpdateConstraints()
            registerHiddenListeners(oldValue)
        }
    }
    
    //MARK: - Init
    //--------------------------------------------------------------------------
    public init(arrangedSubviews: [UIView] = []) {
        super.init(frame: CGRectZero)
        for arrangedSubview in arrangedSubviews {
            arrangedSubview.setTranslatesAutoresizingMaskIntoConstraints(false)
            addSubview(arrangedSubview)
        }

        // Closure to invoke didSet()
        { self.arrangedSubviews = arrangedSubviews }()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // This removes `hidden` value KVO observers using didSet()
        { self.arrangedSubviews = [] }()
    }
    
    //MARK: - Arranged subview array handling
    //--------------------------------------------------------------------------
    public func addArrangedSubview(view: UIView) {
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(view)
        arrangedSubviews.append(view)
    }
    
    public func removeArrangedSubview(view: UIView) {
        if let index = find(arrangedSubviews, view) {
            arrangedSubviews.removeAtIndex(index)
        }
    }
    
    public func insertArrangedSubview(view: UIView, atIndex stackIndex: Int) {
        arrangedSubviews.insert(view, atIndex: stackIndex)
    }
    
    //MARK: - KVO register / deregister handling
    //--------------------------------------------------------------------------
    private func registerHiddenListeners(previousArrangedSubviews: [UIView]) {
        previousArrangedSubviews.map {self.removeHiddenListener($0)}
        arrangedSubviews.map {self.addHiddenListener($0)}
    }
    
    private func addHiddenListener(view: UIView) {
        view.addObserver(self, forKeyPath: "hidden", options: .Old | .New, context: &kvoContext)
        registeredKvoSubviews.append(view)
    }
    
    private func removeHiddenListener(view: UIView) {
        if let index = find(registeredKvoSubviews, view) {
            view.removeObserver(self, forKeyPath: "hidden", context: &kvoContext)
            registeredKvoSubviews.removeAtIndex(index)
        }
    }

    //MARK: Hidden property animation
    //--------------------------------------------------------------------------
    override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if let view = object as? UIView where keyPath == "hidden" {
            let hidden = view.hidden
            let previousValue = change["old"] as! Bool
            if hidden == previousValue {
                return
            }

            if hidden {
                animatingToHiddenViews.append(view)
            }
            // Perform the animation
            setNeedsUpdateConstraints()
            setNeedsLayout()
            layoutIfNeeded()
            
            removeHiddenListener(view)
            view.hidden = false

            if let _ = view.layer.animationKeys() {
                UIView.setAnimationDelegate(self)
                animationDidStopQueueEntries.insert(AnimationDidStopQueueEntry(view: view, hidden: hidden), atIndex: 0)
                UIView.setAnimationDidStopSelector("hiddenAnimationStopped")
            } else {
                didFinishSettingHiddenValue(view, hidden: hidden)
            }
        }
    }
    
    private func didFinishSettingHiddenValue(arrangedSubview: UIView, hidden: Bool) {
        arrangedSubview.hidden = hidden
        if let index = find(animatingToHiddenViews, arrangedSubview) {
            animatingToHiddenViews.removeAtIndex(index)
        }
        addHiddenListener(arrangedSubview)
    }

    func hiddenAnimationStopped() {
        var queueEntriesToRemove = [AnimationDidStopQueueEntry]()
        for entry in animationDidStopQueueEntries {
            let view = entry.view
            if view.layer.animationKeys() == nil {
                didFinishSettingHiddenValue(view, hidden: entry.hidden)
                queueEntriesToRemove.append(entry)
            }
        }
        for entry in queueEntriesToRemove {
            if let index = find(animationDidStopQueueEntries, entry) {
                animationDidStopQueueEntries.removeAtIndex(index)
            }
        }
    }
    
    private func isHidden(view: UIView) -> Bool {
        if view.hidden {
            return true
        }
        return find(animatingToHiddenViews, view) != nil
    }
    
    //MARK: Layout
    //--------------------------------------------------------------------------
    public override func layoutSubviews() {
        super.layoutSubviews()
        var xPos:CGFloat = 0
        var yPos:CGFloat = 0
        let size = bounds.size
        
        let visibleArrangedSubviews:[UIView] = arrangedSubviews.filter{!self.isHidden($0)}
        for view in visibleArrangedSubviews {
            var frame = view.frame
            
            frame.origin.x = xPos
            frame.origin.y = yPos
            view.frame = frame
            
            if axis == .Vertical {
                yPos += frame.height + spacing
            } else {
                xPos += frame.width + spacing
            }
        }
    }
}
