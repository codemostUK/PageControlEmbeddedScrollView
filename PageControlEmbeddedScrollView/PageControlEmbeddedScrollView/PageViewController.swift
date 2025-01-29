//
//  PageViewController.swift
//  PageControlEmbeddedScrollView
//
//  Created by Tolga Seremet on 27.01.2025.
//

import UIKit

// MARK: - PageViewController

final class PageViewController: UIPageViewController {
    
    // MARK: - Static Properties
    
    static let numberOfPages = 7
    
    // MARK: - Properties
    
    var pages: [UIViewController] = []
    weak var acordionHeaderViewDelegate: AcordionHeaderViewDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        preparePages()
        self.setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    
    // MARK: - Page Management
    
    private func preparePages() {
        for index in 0..<PageViewController.numberOfPages {
            guard let pageContentViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController
            else { return }
            
            pageContentViewController.index = index
            pageContentViewController.delegate = self.acordionHeaderViewDelegate
            pages.append(pageContentViewController)
        }
    }
}

// MARK: - UIPageViewControllerDelegate & UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else { return nil }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else { return nil }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {}
}
