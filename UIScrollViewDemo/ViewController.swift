//
//  ViewController.swift
//  UIScrollViewDemo
//
//  Created by Simon Gladman on 28/09/2014.
//  Copyright (c) 2014 Simon Gladman. All rights reserved.
//
// With help from: 
//
//  http://www.raywenderlich.com/76436/use-uiscrollview-scroll-zoom-content-swift
//  http://www.rockhoppertech.com/blog/swift-dragging-a-uiview-with-snap/

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate
{

    let scrollView = UIScrollView(frame: CGRectZero)
    let backgroundControl = BackgroundControl(frame: CGRect(x: 0, y: 0, width: 5000, height: 5000))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundControl)

        scrollView.contentSize = backgroundControl.frame.size;
        scrollView.minimumZoomScale = 0.3
        scrollView.maximumZoomScale = 2
        scrollView.zoomScale = 1
        
        scrollView.bouncesZoom = false
        scrollView.bounces = false
 
        scrollView.delegate = self

        // long press adds new node....
        let longPress = UILongPressGestureRecognizer(target: self, action: "longHoldHandler:")
        scrollView.addGestureRecognizer(longPress)

        scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: view.frame.height - topLayoutGuide.length)
    }

    func longHoldHandler(recognizer: UILongPressGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            let gestureLocation = recognizer.locationInView(backgroundControl)
            
            if backgroundControl.hitTest(gestureLocation, withEvent: nil) is BackgroundControl
            {
                let originX = Int( gestureLocation.x - 75 )
                let originY = Int( gestureLocation.y - 75 )
                
                let node = Node(frame: CGRect(x: originX, y: originY, width: 150, height: 150))

                node.addTarget(self, action: "disableScrolling", forControlEvents: .TouchDown)
                node.addTarget(self, action: "enableScrolling", forControlEvents: .TouchUpInside)
                
                backgroundControl.addSubview(node)
            }
        }
    }
    
    func disableScrolling()
    {
        scrollView.scrollEnabled = false
    }

    func enableScrolling()
    {
        scrollView.scrollEnabled = true
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView!
    {
        return backgroundControl
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: size.width, height: size.height - topLayoutGuide.length)
    }
    
}

