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
    
    //MARK:- Outlets
    
    @IBOutlet weak var onboardingScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrollWidth: CGFloat! = 0.0
    var scrollHeight: CGFloat! = 0.0

    //data for the slides
    var titles = [ThisWeekViewController.Defaults.planLabelText,ThisWeekViewController.Defaults.setLabelText,ThisWeekViewController.Defaults.outlineLabelText]
    var descs = ["","",""]
    var imgs = ["onboarding_plan","onboarding_reminder","onboarding_calendar"]

    //get dynamic width and height of scrollview and save it
    override func viewDidLayoutSubviews() {
        scrollWidth = onboardingScrollView.frame.size.width
        scrollHeight = onboardingScrollView.frame.size.height
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        //to call viewDidLayoutSubviews() and get dynamic width and height of scrollview

        self.onboardingScrollView.delegate = self
        onboardingScrollView.isPagingEnabled = true
        onboardingScrollView.showsHorizontalScrollIndicator = false
        onboardingScrollView.showsVerticalScrollIndicator = false

        //crete the slides and add them
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)

        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)

            let slide = UIView(frame: frame)

            //subviews
            let imageView = UIImageView.init(image: UIImage.init(named: imgs[index]))
            imageView.frame = CGRect(x:0,y:0,width:300,height:300)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x:scrollWidth/2,y: scrollHeight/2 - 50)
          
            let txt1 = UILabel.init(frame: CGRect(x:32,y:imageView.frame.maxY+30,width:scrollWidth-64,height:30))
            txt1.textAlignment = .center
            txt1.font = UIFont.boldSystemFont(ofSize: 20.0)
            txt1.text = titles[index]

            let txt2 = UILabel.init(frame: CGRect(x:32,y:txt1.frame.maxY+10,width:scrollWidth-64,height:50))
            txt2.textAlignment = .center
            txt2.numberOfLines = 3
            txt2.font = UIFont.systemFont(ofSize: 18.0)
            txt2.text = descs[index]

            slide.addSubview(imageView)
            slide.addSubview(txt1)
            slide.addSubview(txt2)
            onboardingScrollView.addSubview(slide)

        }

        //set width of scrollview to accomodate all the slides
        onboardingScrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)

        //disable vertical scroll/bounce
        self.onboardingScrollView.contentSize.height = 1.0

        //initial state
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0

    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        onboardingScrollView!.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }

    func setIndiactorForCurrentPage()  {
        let page = (onboardingScrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
    
    
//    @IBOutlet weak var welcomeLabel: UILabel!{
//        didSet{
//            welcomeLabel.text = ThisWeekViewController.Defaults.welcomeLabelText
//        }
//    }
//
//    @IBOutlet weak var subTitleLabel: UILabel!{
//        didSet{
//            subTitleLabel.text = ThisWeekViewController.Defaults.subTitleLabelText
//        }
//    }
//
//    @IBOutlet weak var planLabel: UILabel!{
//        didSet{
//            planLabel.text = ThisWeekViewController.Defaults.planLabelText
//        }
//    }
//
//    @IBOutlet weak var setLabel: UILabel!{
//        didSet{
//            setLabel.text = ThisWeekViewController.Defaults.setLabelText
//        }
//    }
//
//    @IBOutlet weak var outlineLabel: UILabel!{
//        didSet{
//            outlineLabel.text = ThisWeekViewController.Defaults.outlineLabelText
//        }
//    }
    
    @IBOutlet weak var getStartedButton: UIButton!{
        didSet{
            getStartedButton.setTitle(ThisWeekViewController.Defaults.getStartedButtonText, for: .normal)
        }
    }
}
