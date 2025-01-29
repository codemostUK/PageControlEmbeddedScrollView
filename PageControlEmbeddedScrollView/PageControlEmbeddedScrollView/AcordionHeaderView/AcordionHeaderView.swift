//
//  AcordionHeaderView.swift
//  PageControlEmbeddedScrollView
//
//  Created by Tolga Seremet on 29.01.2025.
//

import UIKit

/// A protocol defining the properties required for an accordion-style header in a view controller.
protocol AcordionHeaderView: UIViewController {

    /// The minimum allowable height for the accordion header.
    var acordionHeaderMinHeight: CGFloat { get }

    /// The maximum allowable height for the accordion header.
    var acordionHeaderMaxHeight: CGFloat { get }

    /// The current height of the accordion header, which adjusts dynamically based on user interaction.
    var acordionHeaderHeight: CGFloat { get set }

    /// A constraint reference used to programmatically adjust the header's height.
    ///
    /// This constraint is updated dynamically when the header expands or contracts.
    var acordionHeaderHeightHeightConstraint: NSLayoutConstraint! { get set }
}

protocol AcordionHeaderViewDelegate: AcordionHeaderView {

    /// Determines whether the accordion header view should scroll based on the given offset, scroll direction, and deceleration state.
    ///
    /// - Parameters:
    ///   - offsetY: The change in vertical content offset.
    ///   - scrollDirection: The direction in which the user is scrolling.
    ///   - isDecelerating: A Boolean indicating whether the scroll view is currently decelerating.
    ///   - targetOfsetYDelta: The predicted change in content offset after deceleration.
    /// - Returns: A Boolean value indicating whether scrolling should be allowed.
    func canIScroll(offsetY: CGFloat,
                    scrollDirection: UIAccessibilityScrollDirection,
                    isDecelerating: Bool,
                    targetOfsetYDelta: CGFloat) -> Bool
}

/// Extension for `AcordionHeaderViewDelegate` providing the scrolling behavior logic.
extension AcordionHeaderViewDelegate {

    /// Determines whether the accordion header view should scroll based on the given offset, scroll direction, and deceleration state.
    ///
    /// - Parameters:
    ///   - offsetY: The change in vertical content offset.
    ///   - scrollDirection: The direction in which the user is scrolling.
    ///   - isDecelerating: A Boolean indicating whether the scroll view is currently decelerating.
    ///   - targetOfsetYDelta: The predicted change in content offset after deceleration.
    /// - Returns: A Boolean value indicating whether scrolling should be allowed.
    func canIScroll(offsetY: CGFloat,
                    scrollDirection: UIAccessibilityScrollDirection,
                    isDecelerating: Bool,
                    targetOfsetYDelta: CGFloat) -> Bool {

        // Calculate the new potential height of the accordion header
        var acordionHeaderHeightToSet = acordionHeaderHeight - offsetY

        // Enforce minimum height restriction
        if acordionHeaderHeightToSet <= acordionHeaderMinHeight {
            acordionHeaderHeight = acordionHeaderMinHeight
            return true // Prevent further shrinking
        }

        // Enforce maximum height restriction
        else if acordionHeaderHeightToSet >= acordionHeaderMaxHeight {
            acordionHeaderHeight = acordionHeaderMaxHeight
            return true // Prevent further expansion
        }

        else {
            if !isDecelerating {
                // If scrolling is actively happening (not decelerating), adjust the header height dynamically
                acordionHeaderHeight = acordionHeaderHeightToSet
            }

            else if scrollDirection == .down {
                // When scrolling down, allow expansion with deceleration

                // Adjust the header height within bounds
                acordionHeaderHeightToSet = min(acordionHeaderHeight + targetOfsetYDelta, acordionHeaderMaxHeight)

                // If the predicted offset change is large (>2), force expand to max height
                if targetOfsetYDelta > 2 {
                    acordionHeaderHeightToSet = acordionHeaderMaxHeight
                }

                // Update the height constraint of the accordion header
                acordionHeaderHeightHeightConstraint.constant = acordionHeaderHeightToSet

                // Calculate animation duration based on the height change ratio
                let duration = 0.05 * (acordionHeaderHeightToSet - acordionHeaderHeight) / acordionHeaderHeight

                // Smoothly animate the height change
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                } completion: { finished in
                    // Once animation completes, finalize the new height
                    self.acordionHeaderHeight = acordionHeaderHeightToSet
                }
            }

            return false // Scrolling is not allowed in this case
        }
    }
}

/// A protocol defining the requirements for a scrollable client that interacts with an accordion-style header.
protocol AcordionHeaderViewClient {

    /// Stores the previous vertical scroll position of the content.
    ///
    /// Used to determine the scroll direction and calculate the offset changes.
    var previousContentOffsetY: CGFloat { get set }

    /// A Boolean indicating whether the scroll view is currently decelerating.
    ///
    /// Helps manage the smooth expansion/contraction of the accordion header when scrolling slows down.
    var decelerationInProgress: Bool { get set }

    /// The target content offset after the scroll view stops scrolling.
    ///
    /// This value is used to predict where the scrolling will settle after the user lifts their finger.
    var targetContentOffset: CGPoint { get set }

    /// A reference to the delegate responsible for handling the accordion header's scroll behavior.
    ///
    /// The delegate conforms to `AcordionHeaderViewDelegate`, allowing dynamic header resizing.
    var delegate: AcordionHeaderViewDelegate? { get set }
}
