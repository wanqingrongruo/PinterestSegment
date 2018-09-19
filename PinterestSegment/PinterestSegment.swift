//
//  PinterestSegment.swift
//  Demo
//
//  Created by Tbxark on 06/12/2016.
//  Copyright © 2016 Tbxark. All rights reserved.
//

import UIKit

public struct PinterestSegmentStyle {

    public var indicatorColor = UIColor(white: 0.95, alpha: 1)
    public var titleMargin: CGFloat = 16
    public var titlePendingHorizontal: CGFloat = 0
    public var titlePendingVertical: CGFloat = 14
    public var titleFont = UIFont.boldSystemFont(ofSize: 14)
    public var normalTitleColor = UIColor.lightGray
    public var selectedTitleColor = UIColor.darkGray
    public var indicatorHeight: CGFloat = 3
    public var paddingOfTitleWithIndicator: CGFloat = 3
    public init() {}
}


@IBDesignable public class PinterestSegment: UIControl {

    public var style: PinterestSegmentStyle {
        didSet {
            reloadData()
        }
    }
    @IBInspectable public var titles:[String] {
        didSet {
            guard oldValue != titles else { return }
            reloadData()
            setSelectIndex(index: 0, animated: true)
        }
    }
    public var defaultIndex: Int {
        didSet {
            reloadData()
        }
    }
    public var valueChange: ((_ selectedIndex: Int, _ lastIndex: Int, _ title: String) -> Void)?
    private var titleLabels: [UILabel] = []
    public private(set) var selectIndex = 0

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.bounces = true
        view.isPagingEnabled = false
        view.scrollsToTop = false
        view.isScrollEnabled = true
        view.contentInset = UIEdgeInsets.zero
        view.contentOffset = CGPoint.zero
        view.scrollsToTop = false
        return view
    }()

    private var indicator: UIView = {
        let ind = UIView()
        ind.layer.masksToBounds = true
        return ind
    }()

    //MARK:- life cycle
    public convenience init(frame: CGRect, titles: [String], defaultIndex: Int = 0) {
        self.init(frame: frame, segmentStyle: PinterestSegmentStyle(), titles:  titles, defaultIndex: defaultIndex)
    }

    public init(frame: CGRect, segmentStyle: PinterestSegmentStyle, titles: [String], defaultIndex: Int) {
        self.style = segmentStyle
        self.titles = titles
        self.defaultIndex = defaultIndex
        super.init(frame: frame)
        shareInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        self.style = PinterestSegmentStyle()
        self.titles = []
        self.defaultIndex = 0
        super.init(coder: aDecoder)
        shareInit()
    }

    private func shareInit() {
        addSubview(UIView()) // fix automaticallyAdjustsScrollViewInsets bug
        addSubview(scrollView)
        reloadData()
    }

    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let x = gesture.location(in: self).x + scrollView.contentOffset.x
        for (i, label) in titleLabels.enumerated() {
            if x >= label.frame.minX && x <= label.frame.maxX {
                setSelectIndex(index: i, animated: true)
                break
            }
        }

    }

    public func setSelectIndex(index: Int,animated: Bool = true) {
        guard index != selectIndex, index >= 0 , index < titleLabels.count else { return }

        let currentLabel = titleLabels[index]
        let offSetX = min(max(0, currentLabel.center.x - bounds.width / 2),
                          max(0, scrollView.contentSize.width - bounds.width))
        scrollView.setContentOffset(CGPoint(x:offSetX, y: 0), animated: true)

        if animated {

            UIView.animate(withDuration: 0.2, animations: {
                var rect = self.indicator.frame
                rect.origin.x = currentLabel.frame.origin.x
                rect.size.width = currentLabel.frame.size.width
                self.setIndicatorFrame(rect)
            })

        } else {
            var rect = indicator.frame
            rect.origin.x = currentLabel.frame.origin.x
            rect.size.width = currentLabel.frame.size.width
            setIndicatorFrame(rect)
        }

        let lastLabel = titleLabels[selectIndex]
        lastLabel.textColor = style.normalTitleColor
        currentLabel.textColor = style.selectedTitleColor

        valueChange?(index, selectIndex, titles[index])
        selectIndex = index
        sendActions(for: UIControlEvents.valueChanged)
    }


    private func setIndicatorFrame(_ frame: CGRect) {
        indicator.frame = frame
    }

    private func clearData() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        if let gescs = gestureRecognizers {
            for gesc in gescs {
                removeGestureRecognizer(gesc)
            }
        }
        titleLabels.removeAll()
    }

    private func reloadData() {
        clearData()

        guard titles.count > 0  else {
            return
        }
        // Set titles
        let font  = style.titleFont
        var titleX: CGFloat = 0.0
        let titleH = font.lineHeight
        let titleY: CGFloat = ( bounds.height - font.lineHeight)/2

        scrollView.frame = bounds

        let toToSize: (String) -> CGFloat = { text in
            return (text as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).width
        }

        for (index, title) in titles.enumerated() {

            let titleW = toToSize(title) + style.titlePendingHorizontal * 2
            titleX = (titleLabels.last?.frame.maxX ?? 0 ) + style.titleMargin
            let rect = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)

            let backLabel = UILabel(frame: CGRect.zero)
            backLabel.tag = index
            backLabel.text = title
            backLabel.textColor = style.normalTitleColor
            backLabel.font = style.titleFont
            backLabel.textAlignment = .center
            backLabel.frame = rect

            if index == defaultIndex {
                backLabel.textColor = style.selectedTitleColor
            }

            titleLabels.append(backLabel)
            scrollView.addSubview(backLabel)

            if index == titles.count - 1 {
                scrollView.contentSize.width = rect.maxX + style.titleMargin
            }
        }

        // Set Cover
        indicator.backgroundColor = style.indicatorColor
        scrollView.addSubview(indicator)

        let coverX = titleLabels[0].frame.origin.x
        let coverY = titleLabels[0].frame.origin.y + titleLabels[0].frame.size.height + style.paddingOfTitleWithIndicator
        let coverW = titleLabels[0].frame.size.width

        let indRect = CGRect(x: coverX, y: coverY, width: coverW, height: style.indicatorHeight)
        setIndicatorFrame(indRect)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PinterestSegment.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
        setSelectIndex(index: defaultIndex)

    }
}


extension PinterestSegment {

    public var titleFont: UIFont {
        get {
            return style.titleFont
        }
        set {
            style.titleFont = newValue
        }
    }

    @IBInspectable public var indicatorColor: UIColor {
        get {
            return style.indicatorColor
        }
        set {
            style.indicatorColor = newValue
        }
    }

    @IBInspectable public var titleMargin: CGFloat {
        get {
            return style.titleMargin
        }
        set {
            style.titleMargin = newValue
        }
    }

    @IBInspectable public var titlePendingHorizontal: CGFloat {
        get {
            return style.titlePendingHorizontal
        }
        set {
            style.titlePendingHorizontal = newValue
        }
    }

    @IBInspectable public var titlePendingVertical: CGFloat  {
        get {
            return style.titlePendingVertical
        }
        set {
            style.titlePendingVertical = newValue
        }
    }


    @IBInspectable public var normalTitleColor: UIColor {
        get {
            return style.normalTitleColor
        }
        set {
            style.normalTitleColor = newValue
        }
    }

    @IBInspectable public var selectedTitleColor: UIColor {
        get {
            return style.selectedTitleColor
        }
        set {
            style.selectedTitleColor = newValue
        }
    }

    @IBInspectable public var indicatorHeight: CGFloat {
        get {
            return style.indicatorHeight
        }
        set {
            style.indicatorHeight = newValue
        }
    }

    @IBInspectable public var paddingOfTitleWithIndicator: CGFloat {
        get {
            return style.paddingOfTitleWithIndicator
        }
        set {
            style.paddingOfTitleWithIndicator = newValue
        }
    }
}

