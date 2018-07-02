//
//  CarouselPagerView.swift
//  Image Carousel
//
//  Created by Roberto Rumbaut on 8/8/16.
//  Copyright © 2016 Roberto Rumbaut. All rights reserved.
//

import UIKit

protocol ImageCarouselViewDelegate {
    func scrolledToPage(_ page: Int)
    
    func clickonpage(_ page: Int)
}

@IBDesignable
class ImageCarouselView: UIView {
    
    var delegate: ImageCarouselViewDelegate?
    var timer:Timer!
    var coresalwidth = CGFloat()

    
    @IBInspectable var showPageControl: Bool = false {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var pageControlMaxItems: Int = 10 {
        didSet {
            setupView()
        }
    }
    var pageLabel = UILabel()
    
    var carouselScrollView: UIScrollView!
    var textarray = NSMutableArray()
    var imageurlarry = NSMutableArray()
        {
        didSet {
            setupView()
        }
    }
    
    var images = [UIImage]() {
        didSet {
            setupView()
        }
    }
    
    var pageControl = UIPageControl()
    
    var currentPage: Int! {
        return Int(round(carouselScrollView.contentOffset.x / self.bounds.width))
    }
    
    @IBInspectable var pageColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var currentPageColor: UIColor? {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        for view in subviews {
            view.removeFromSuperview()
        }
         carouselScrollView = UIScrollView(frame: bounds)
        carouselScrollView.showsHorizontalScrollIndicator = false
        
        addImages()
        
        if showPageControl {
            addPageControl()
            carouselScrollView.delegate = self
        }
    }
    
    func update()
    {
        if timer != nil
        {
            timer.invalidate()
            timer  = nil
        }

        
        if(currentPage == imageurlarry.count-1)
        {
            coresalwidth = 0
            carouselScrollView.contentOffset.x = 0
 
        }
        else
        {
            coresalwidth = (carouselScrollView.contentSize.width / CGFloat(imageurlarry.count)) + coresalwidth
           carouselScrollView.scrollRectToVisible(CGRect.init(x: coresalwidth, y: carouselScrollView.contentOffset.y, width: bounds.width, height: carouselScrollView.contentSize.height), animated: true)
            
        }
        
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
        
      }
    func addImages() {
        carouselScrollView.isPagingEnabled = true
        carouselScrollView.contentSize = CGSize(width: bounds.width * CGFloat(imageurlarry.count), height: bounds.height)
        
        for i in 0..<imageurlarry.count {
            let imageView = UIImageView(frame: CGRect(x: bounds.width * CGFloat(i), y: 0, width: bounds.width, height: bounds.height))
             let url = imageurlarry.object(at: i) as! URL
             imageView.sd_setImage(with: url, placeholderImage: nil, options: .lowPriority, completed: nil)
            // imageView.setImageWith(url)
           //  imageView.image = images[i]
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.isUserInteractionEnabled = true
            let label = UILabel.init(frame: CGRect.init(x: ((bounds.width * CGFloat(i))+5), y: bounds.height-40, width: 200, height: 50))
            label.text = textarray.object(at: i) as? String
            label.font = UIFont(name: "Ubuntu", size: CGFloat(16))
            label.textColor = UIColor.white
            //imageView.addSubview(label)
            let layerview = UIView(frame: CGRect.init(x: bounds.width * CGFloat(i), y: bounds.height-35, width: bounds.width, height: 35))
            layerview.backgroundColor = UIColor.black
            layerview.alpha = 0.4
            let button = UIButton(frame: CGRect(x: bounds.width * CGFloat(i), y: 0, width: bounds.width, height: bounds.height))
            button.addTarget(self, action: #selector(clickoncoresal), for: .touchUpInside)
            
            
            carouselScrollView.addSubview(imageView)
            carouselScrollView.addSubview(layerview)
            carouselScrollView.addSubview(label)
            carouselScrollView.addSubview(button)
            print("Added")
        }
        
        self.addSubview(carouselScrollView)
         self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
       
    
    }
    
    
    func taptocoresal()
    {
        
    }
    
    func addPageControl() {
        if imageurlarry.count <= pageControlMaxItems {
            pageControl.numberOfPages = imageurlarry.count
            pageControl.sizeToFit()
            pageControl.currentPage = 0
            pageControl.center = CGPoint(x: self.center.x, y: bounds.height - pageControl.bounds.height/2 - 8)
            
            if let pageColor = self.pageColor {
                pageControl.pageIndicatorTintColor = pageColor
            }
            if let currentPageColor = self.currentPageColor {
                pageControl.currentPageIndicatorTintColor = currentPageColor
            }
            
            self.addSubview(pageControl)
        } else {
            pageLabel.text = "1 / \(imageurlarry.count)"
            pageLabel.font = UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightLight)
            pageLabel.frame.size = CGSize(width: 40, height: 20)
            pageLabel.textAlignment = .center
            pageLabel.layer.cornerRadius = 10
            pageLabel.layer.masksToBounds = true
            pageLabel.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3)
            pageLabel.textColor = UIColor.white
            pageLabel.center = CGPoint(x: self.center.x, y: bounds.height - pageLabel.bounds.height/2 - 8)
            
            self.addSubview(pageLabel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupView()
    }
    
}

extension ImageCarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.pageControl.currentPage = self.currentPage
        self.pageLabel.text = "\(self.currentPage+1) / \(imageurlarry.count)"
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.scrolledToPage(self.currentPage)
    }
    
     func clickoncoresal(_ scrollView: UIScrollView)
     {
         self.delegate?.clickonpage(self.currentPage)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clickoncoresal"), object: self.currentPage)
 
     }
    
}
