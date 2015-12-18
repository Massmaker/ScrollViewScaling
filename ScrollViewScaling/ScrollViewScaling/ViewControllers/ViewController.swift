//
//  ViewController.swift
//  ScrollViewScaling
//
//  Created by CloudCraft on 12/16/15.
//  Copyright © 2015 CloudCraft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollingView:UIScrollView!
    @IBOutlet weak var doubleTapRecognizer:UITapGestureRecognizer!
    var testView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
   
        scrollingView.contentSize = CGSizeMake(scrollingView.bounds.size.width, scrollingView.bounds.size.height)
        //scrollingView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10) // adds 10 points to all sizes for scrolling area
        print("start offset: \(scrollingView.contentOffset)")
        let grayView = UIView(frame:CGRectMake(0.0,0.0,scrollingView.bounds.size.width , scrollingView.bounds.size.height))
       
        grayView.opaque = true
        grayView.backgroundColor = UIColor.grayColor()
        grayView.layer.borderColor = UIColor.yellowColor().CGColor
        grayView.layer.borderWidth = 1.0
        testView = grayView
        scrollingView.addSubview(grayView)
        
        print("gray view frame: \(grayView.frame)")
     
        print("newOffset:  \(scrollingView.contentOffset)")
        print("new frame: \(grayView.frame)")
        
        let timeout:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 1.0))

        dispatch_after(timeout, dispatch_get_main_queue()){
        
        self.scrollingView.flashScrollIndicators()
        }
    }

    //MARK: -
    func centerView(viewToCenter:UIView?, inScrollView scrollView:UIScrollView, animationDuration:NSTimeInterval = 0.0)
    {
        guard let view = viewToCenter else
        {
            return
        }
        
        var viewFrame = view.frame
        let scrollBounds = scrollView.bounds.size
        if viewFrame.size.width < scrollBounds.width
        {
            viewFrame.origin.x = floor((scrollBounds.width - viewFrame.size.width) / 2.0)
        }
        if viewFrame.size.height < scrollBounds.height
        {
            viewFrame.origin.y = (scrollBounds.height - viewFrame.size.height ) / 2.0
        }
        
        guard animationDuration > 0 else
        {
            view.frame = viewFrame
            return
        }
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            view.frame = viewFrame
        }
        
        print("\n centerView ->\n frame: \(viewFrame)")
    }
    
    func updateSizeMeshIndicators()
    {
        
    }
    
    //MARK: - UITapGestureRecognizr
    @IBAction func doubleTapAction(recognizer:UITapGestureRecognizer)
    {
        // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
        var newZoomScale:CGFloat = scrollingView.zoomScale / 1.5
        newZoomScale = max(newZoomScale, scrollingView.minimumZoomScale);
        scrollingView.setZoomScale(newZoomScale, animated: true)
        if newZoomScale == scrollingView.minimumZoomScale
        {
            let timeout:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5))
            
            dispatch_after(timeout, dispatch_get_main_queue(), { () -> Void in

                if !CGSizeEqualToSize(self.scrollingView.bounds.size, self.scrollingView.contentSize)
                {
                    print(" ----  Starting centering scroll view  animated  ---- ")
                    self.centerView(self.testView, inScrollView: self.scrollingView, animationDuration: 0.4)
                }
            })
        }
    }
    
    
    //MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return testView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        print("\n scrollViewDidEndZooming ->")
        
        guard let viewPresentInScrollView = view else
        {
            return
        }
        //centerView(viewPresentInScrollView, inScrollView: scrollView)
        
        //update scroll view contentSize for proper dragging
        let size = viewPresentInScrollView.bounds.size
        let currentScale = scrollView.zoomScale
        //print(" current testView size: \(size), \n scale: \(scrollView.zoomScale),\n offset: \(scrollView.contentOffset)")
        let visibleWidth = CGFloat(round(Double(size.width * currentScale)))
        let visibleHeight = CGFloat(round(Double(size.height * currentScale)))
        
        if visibleWidth > scrollView.bounds.size.width || visibleHeight > scrollView.bounds.size.height
        {
            scrollView.contentSize = CGSizeMake(visibleWidth, visibleHeight)
        }
        else
        {
            scrollView.contentSize = scrollView.bounds.size
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("\n did end decelerating ->")
        print("end offset: \(scrollView.contentOffset)")
        print("end view frame: \(testView!.frame)")
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate
        {
            print("\n did end dragging ->")
            print("end offset: \(scrollView.contentOffset)")
            print("end view frame: \(testView!.frame)")
        }
    }
}

