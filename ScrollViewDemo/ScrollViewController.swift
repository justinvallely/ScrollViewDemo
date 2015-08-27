//
//  ViewController.swift
//  ScrollViewController
//
//  Created by Justin Vallely on 8/21/15.
//  Copyright (c) 2015 Inspirato. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var imageViewLeft: UIImageView! = UIImageView(image: UIImage(named: "slide1@3x.png"))
    var imageViewMiddle: UIImageView! = UIImageView(image: UIImage(named: "slide2@3x.png"))
    var imageViewRight: UIImageView! = UIImageView(image: UIImage(named: "slide3@3x.png"))

    var imageCollection: [UIImageView!] = []
    var currentImage: Int = 0

    //var imageOne = UIImageView(image: UIImage(named: "slide1@3x.png"))
    //var imageTwo = UIImageView(image: UIImage(named: "slide2@3x.png"))
    //var imageThree = UIImageView(image: UIImage(named: "slide3@3x.png"))

    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollection.append(imageViewLeft)
        imageCollection.append(imageViewMiddle)
        imageCollection.append(imageViewRight)

        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        //scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width/2, y: scrollView.bounds.size.height/2)
        scrollView.pagingEnabled = true

        let scrollViewWidth:CGFloat = scrollView.frame.width
        let scrollViewHeight:CGFloat = scrollView.frame.height
        var totalWidth: CGFloat = 0

        for image in 0..<imageCollection.count {
            imageCollection[image].frame = CGRectMake(scrollViewWidth * CGFloat(image), 0, scrollViewWidth, scrollViewHeight)
            scrollView.addSubview(imageCollection[image])
            totalWidth += imageCollection[image].bounds.size.width
        }

        scrollView.contentSize = CGSizeMake(totalWidth, imageViewMiddle.bounds.size.height)

        view.addSubview(scrollView)

        scrollView.delegate = self
        
        setZoomScale()
        setupGestureRecognizer()
    }

    // This will be unnecessary shortly
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        var pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        currentImage = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1)
        println("current image: \(currentImage)")
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageViewMiddle
    }
    
    // Set minimum zoom to Aspect Fit
    func setZoomScale() {
        let imageViewSize = imageCollection[currentImage].bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 0
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
/*
    // Called after every zoom action to center the image
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageCollection[currentImage].frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
*/
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {

        println("double tap recognized")
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

