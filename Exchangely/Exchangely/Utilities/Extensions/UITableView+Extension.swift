//
//  UITableView+Extension.swift
//  Exchangely
//
//  Created by Suciu Radu on 10.08.2022.
//

import UIKit

extension UITableView {

    /// Set table header view & add Auto layout.
    func setHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        self.tableHeaderView = headerView

        // Then setup AutoLayout.
        headerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = tableHeaderView else { return }

        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let header = tableHeaderView
        tableHeaderView = header
    }

    /// Recalculates the layout by calling `beginUpdates()` and `endUpdates()` without scrolling the tableView.
    func reloadDataAnimatedKeepingOffset() {
        let offset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        contentOffset = offset
    }

    /// Layouts the view, sets its frame and assigns it to `tableHeaderView`.
    ///
    /// You may still want to set the priority of the constant constraints to 999 (ex. -padding@999- in case of VFL) to get rid of the initial layout warnings.
    ///
    /// - warning: Don't forget to set the `preferredMaxLayoutWidth` for multiline UILabels.
    ///
    /// - Parameter header: The UIView you want to set as header.
    func setAndLayoutTableHeaderView(_ header: UIView) {
        tableHeaderView = prepareHeaderFooterView(header)
    }

    /// Layouts the view, sets its frame and assigns it to `tableFooterView`.
    ///
    /// You may still want to set the priority of the constant constraints to 999 (ex. -padding@999- in case of VFL) to get rid of the initial layout warnings.
    ///
    /// - warning: Don't forget to set the `preferredMaxLayoutWidth` for multiline UILabels.
    ///
    /// - Parameter footer: The UIView you want to set as footer.
    func setAndLayoutTableFooterView(_ footer: UIView) {
        tableFooterView = prepareHeaderFooterView(footer)
    }

    private func prepareHeaderFooterView(_ view: UIView) -> UIView {
        view.setNeedsLayout()
        view.layoutIfNeeded()
        view.frame.size.height = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        return view
    }

    /// Layouts the header view if it exists, and re-assigns it to `tableHeaderView`.
    func updateTableHeaderViewHeight() {
        if let view = tableHeaderView {
            tableHeaderView = prepareHeaderFooterView(view)
        }
    }

    /// Layouts the footer view if it exists, and re-assigns it to `tableFooterView`.
    func updateTableFooterViewHeight() {
        if let view = tableFooterView {
            tableFooterView = prepareHeaderFooterView(view)
        }
    }

    /// Increase the size of the footer view to fill the remaining space between cells and the bottom of the tableVIew
    func adjustFooterHeightToFillRemainingSpace() {
        if let tableFooterView = self.tableFooterView {
            let minHeight = tableFooterView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            let currentFooterHeight = tableFooterView.frame.height

            let fitHeight = self.frame.height - self.adjustedContentInset.top - self.contentSize.height + currentFooterHeight
            let nextHeight = max(fitHeight, minHeight)

            if round(nextHeight) != round(currentFooterHeight) {
                var frame = tableFooterView.frame
                frame.size.height = nextHeight
                tableFooterView.frame = frame
                self.tableFooterView = tableFooterView
            }
        }
    }
}
