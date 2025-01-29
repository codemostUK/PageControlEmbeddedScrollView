//
//  PageContentViewController.swift
//  PageControlEmbeddedScrollView
//
//  Created by Tolga Seremet on 27.01.2025.
//

import UIKit

// MARK: - PageContentViewController

class PageContentViewController: AcordionHeaderViewClientVC {
    
    // MARK: - Static Properties
    
    static var colors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemMint]
    
    // MARK: - IBOutlets
    
    @IBOutlet var indexLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var stackView: UIStackView!
    
    // MARK: - Properties
    
    var index: Int = -1
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fillRows()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        scrollView.alwaysBounceVertical = true
        indexLabel.text = String("\(index)")
        view.backgroundColor = PageContentViewController.colors[index % PageContentViewController.colors.count]
        contentView.backgroundColor = .black
        contentViewHeightConstraint.constant = 100 + CGFloat(index) * 400
    }
    
    // MARK: - Content Population
    
    private func fillRows() {
        for i in 0 ... index * 4 {
            let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.size.width, height: 98)))
            label.textAlignment = .center
            label.text = String("\(i)")
            label.textColor = .white
            
            let constraint = NSLayoutConstraint(item: label,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 98)
            label.addConstraint(constraint)
            
            stackView.insertArrangedSubview(label, at: i * 2)
            
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.size.width, height: 2)))
            view.backgroundColor = .gray
            
            let constraint2 = NSLayoutConstraint(item: view,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 2)
            view.addConstraint(constraint2)
            stackView.insertArrangedSubview(view, at: i * 2 + 1)
        }
    }
}
