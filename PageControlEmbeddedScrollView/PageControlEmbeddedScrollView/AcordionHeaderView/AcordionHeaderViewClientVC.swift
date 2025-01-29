//
//  AcordionHeaderViewClientVC.swift
//  PageControlEmbeddedScrollView
//
//  Created by Tolga Seremet on 29.01.2025.
//

import UIKit

/// A view controller responsible for managing scroll events in conjunction with an accordion-style header.
/// This class acts as a client of `AcordionHeaderViewDelegate`.
class AcordionHeaderViewClientVC: UIViewController, AcordionHeaderViewClient, UIScrollViewDelegate {

    /// Stores the last recorded vertical offset of the scroll view.
    var previousContentOffsetY: CGFloat = 0.0

    /// A Boolean indicating whether deceleration is currently in progress.
    var decelerationInProgress: Bool = false

    /// Stores the target content offset after a drag operation ends.
    var targetContentOffset: CGPoint = CGPoint.zero

    /// A weak reference to the delegate responsible for handling accordion header behavior.
    weak var delegate: (any AcordionHeaderViewDelegate)?

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}

    /// Called when the user lifts their finger after dragging, but before momentum-based scrolling (deceleration) occurs.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.targetContentOffset = targetContentOffset.pointee
    }

    /// Called when dragging ends. If deceleration is not occurring, update the previous content offset.
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            previousContentOffsetY = scrollView.contentOffset.y
        }
    }

    /// Called when the scroll view finishes decelerating.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        previousContentOffsetY = scrollView.contentOffset.y
    }

    /// Called continuously as the user scrolls. Determines whether the header can scroll or should remain fixed.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // Ensure we have a delegate before proceeding
        guard let pageContentViewControllerDelegate = delegate else { return }

        // Determine the scroll direction based on the current and previous offsets
        let scrollDirection: UIAccessibilityScrollDirection =
            scrollView.contentOffset.y > previousContentOffsetY ? .up : .down

        // If scrolling is in an invalid direction, update previous offset and exit
        if !((scrollDirection == .down && scrollView.contentOffset.y < 0) ||
             (scrollDirection == .up && scrollView.contentOffset.y > 0)) {
            previousContentOffsetY = scrollView.contentOffset.y
            return
        }

        // Calculate how much the content offset has changed
        let contentOffsetYDelta = scrollView.contentOffset.y - previousContentOffsetY

        // Check if the accordion header should scroll or remain fixed
        if !pageContentViewControllerDelegate.canIScroll(offsetY: contentOffsetYDelta,
                                                         scrollDirection: scrollDirection,
                                                         isDecelerating: scrollView.isDecelerating,
                                                         targetOfsetYDelta: targetContentOffset.y - scrollView.contentOffset.y) {
            // Prevent scrolling by resetting content offset to the previous value
            scrollView.setContentOffset(CGPoint(x: 0, y: previousContentOffsetY), animated: false)
        }
    }
}
