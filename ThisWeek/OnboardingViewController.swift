//
//  OnboardingViewController.swift
//  ThisWeek
//
//  Created by Emanuel on 02/06/2020.
//  Copyright © 2020 Emanuel. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController , UIScrollViewDelegate{
    
    //MARK:- Functions
    
    @IBAction func done(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: ThisWeekViewController.Defaults.UserDefaultsOnBoardingDoneKey)
        performSegue(withIdentifier: ThisWeekViewController.Defaults.IDFromOnboardingToMain, sender: self)
    }
    
   @IBAction func pageChanged(_ sender: UIPageControl) {
        onboardingScrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    
    //MARK:- Outlets
    
    @IBOutlet weak var getStartedButton: UIButton!{
        didSet{
            getStartedButton.setTitle(ThisWeekViewController.Defaults.getStartedButtonText, for: .normal)
        }
    }
    
    @IBOutlet weak var onboardingScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK:- App Lifecycle
    
    override func viewDidLayoutSubviews() {
        scrollWidth = onboardingScrollView.frame.size.width
        scrollHeight = onboardingScrollView.frame.size.height
        drawAll()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()

        self.onboardingScrollView.delegate = self
        onboardingScrollView.isPagingEnabled = true
        onboardingScrollView.showsHorizontalScrollIndicator = false
        onboardingScrollView.showsVerticalScrollIndicator = false
    }
    
    //MARK:- Draw Functions
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    //data for the slides
    var titles = [ThisWeekViewController.Defaults.planLabelText,ThisWeekViewController.Defaults.setLabelText,ThisWeekViewController.Defaults.outlineLabelText]
    var descs = ["","",""]
    var imgs = ["onboarding_plan","onboarding_reminder","onboarding_calendar"]
    
    func drawAll() {
        let allSubviews = onboardingScrollView.subviews
        for index in allSubviews.indices{
            allSubviews[index].removeFromSuperview()
        }
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)
            let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
            imageView.frame = CGRect(x:0,y:0,width:min(scrollWidth/2,scrollHeight/2),height:min(scrollWidth/2,scrollHeight/2))
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x:scrollWidth/2,y: 1*scrollHeight/3)
            
            let txt1 = UILabel.init(frame: CGRect(x:0,y:imageView.frame.maxY + 0.2 * imageView.frame.height,width:scrollWidth,height: min(scrollWidth/8,scrollHeight/4)))
            txt1.textAlignment = .center
            txt1.font = UIFont.preferredFont(forTextStyle: .title1)
            txt1.adjustsFontForContentSizeCategory = true
            txt1.text = titles[index]

            slide.addSubview(imageView)
            slide.addSubview(txt1)
            onboardingScrollView.addSubview(slide)

        }
        onboardingScrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
        onboardingScrollView.contentSize.height = 1.0
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
    }

    
    //MARK:- UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }

    func setIndiactorForCurrentPage()  {
        let page = (onboardingScrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
}
