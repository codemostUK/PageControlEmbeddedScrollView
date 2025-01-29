//
//  ViewController.swift
//  PageControlEmbeddedScrollView
//
//  Created by Tolga Seremet on 27.01.2025.
//

import UIKit

// MARK: - ViewController

class ViewController: UIViewController, AcordionHeaderViewDelegate {

    // MARK: - IBOutlets

    @IBOutlet var containerView: UIView!
    @IBOutlet var acordionHeaderHeightHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var pageViewController: PageViewController?

    var acordionHeaderMinHeight: CGFloat = 40.0
    var acordionHeaderMaxHeight: CGFloat = 150.0
    var acordionHeaderHeight: CGFloat = 150.0 {
        didSet {
            acordionHeaderHeightHeightConstraint.constant = acordionHeaderHeight
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Navigation

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPageViewController"  {
            if let pageViewController = segue.destination as? PageViewController {
                pageViewController.acordionHeaderViewDelegate = self
            }
        }
        segue.destination.hidesBottomBarWhenPushed = true
    }
}
