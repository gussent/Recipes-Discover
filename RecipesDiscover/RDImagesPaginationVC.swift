//
//  RDImagesPaginationVC.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDImagesPaginationVC: UIViewController, UIScrollViewDelegate
{

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!

    var imageUrlStrings: [String]?

    var numPages: Int { return imageUrlStrings?.count ?? 0 }
    var pages = [UIView?]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rdMainBackgroundDarker
        
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        
        pageControl.numberOfPages = 0
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        pages = [UIView?](repeating: nil, count: numPages)
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
        
        _ = setupInitialPages
    }

    lazy var setupInitialPages: Void =
    {
        adjustScrollView()
        loadPage(0)
        loadPage(1)
        loadPage(2)
    }()
    
    fileprivate func adjustScrollView()
    {
        let width  = scrollView.frame.width * CGFloat(numPages)
        let height = scrollView.frame.height - topLayoutGuide.length
        
        scrollView.contentSize = CGSize(width: width, height: height)
    }

    // MARK: - Page Loading
    
    fileprivate func loadPage(_ page: Int)
    {
        guard page < numPages && page != -1 && pages[page] == nil, let url = imageUrlStrings?[page] else { return }
        
        let imageView = RDAsyncImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.downloadImage(url)
    
        var frame = scrollView.frame
        
        frame.origin.x = frame.width * CGFloat(page)
        frame.origin.y = -self.topLayoutGuide.length
        frame.size.height += self.topLayoutGuide.length
        
        let canvasView = UIView(frame: frame)
        scrollView.addSubview(canvasView)
        canvasView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
        [
            (imageView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor)),
            (imageView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor)),
            (imageView.topAnchor.constraint(equalTo: canvasView.topAnchor)),
            (imageView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor))
        ])
        
        pages[page] = canvasView
    }
    
    fileprivate func loadCurrentPages(page: Int)
    {
        guard (page > 0 && page + 1 < numPages) else { return }
        
        let currentPage = pages[page]
        
        pages.forEach { if $0 != currentPage {$0?.removeFromSuperview()}}
        pages = [UIView?](repeating: nil, count: numPages)

        loadPage(Int(page) - 1)
        loadPage(Int(page) + 1)
        loadPage(Int(page) - 2)
        loadPage(Int(page) + 2)
    }
    
    fileprivate func gotoPage(page: Int, animated: Bool)
    {
        loadCurrentPages(page: page)
        
        var bounds = scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
        bounds.origin.y = 0
        scrollView.scrollRectToVisible(bounds, animated: animated)
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        scrollView.isUserInteractionEnabled = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        scrollView.isUserInteractionEnabled = true
        // Switch the indicator when more than 50% of the previous/next page is visible.
        let pageWidth = scrollView.frame.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
        
        loadCurrentPages(page: pageControl.currentPage)
    }

    // MARK: - Actions
    
    @IBAction func gotoPage(_ sender: UIPageControl)
    {
        gotoPage(page: sender.currentPage, animated: true)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
