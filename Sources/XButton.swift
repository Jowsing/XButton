//
//  XButton.swift
//  Pods
//
//  Created by jowsing on 2024/12/8.
//

import UIKit
import XLabel

public class XButton: UIButton {
    
    public enum Axis: Int {
        case horizontal
        case vertical
    }
    
    public var contentInsets = UIEdgeInsets.zero
    
    public var axis = Axis.horizontal
    
    public var isReverse = false
    
    public var spacing: CGFloat = 0
    
    public var fixedImageSize: CGSize?
    
    public var badgeValue: String? {
        didSet {
            self.badgeLabel.text = badgeValue
            self.layoutBadgeValue()
        }
    }
    
    public var badgeFont: UIFont? {
        didSet {
            self.badgeLabel.font = badgeFont
            self.layoutBadgeValue()
        }
    }
    
    public var badgeColor: UIColor? {
        didSet {
            self.badgeLabel.backgroundColor = badgeColor
        }
    }
        
    private var imageSize = CGSize.zero
    
    private var titleSize = CGSize.zero
    
    private var contentSize = CGSize.zero {
        didSet {
            guard contentSize != oldValue else { return }
            self.invalidateIntrinsicContentSize()
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    private var contentOffset = CGPoint.zero

    public override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    private lazy var badgeLabel = {
        let label = XLabel()
        label.backgroundColor = .red
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textInserts = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        label.hideOnTextEmpty = true
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = false
        self.addSubview(label)
        return label
    }()
    
    public func with(axis: Axis) -> Self {
        self.axis = axis
        return self
    }
    
    public func with(spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.resizeContents()
        self.layoutImageView()
        self.layoutTitleLabel()
        self.layoutBadgeValue()
    }
    
    private func resizeContents() {
        self.titleSize = titleLabel?.intrinsicContentSize ?? .zero
        self.imageSize = fixedImageSize ?? imageView?.image?.size ?? .zero
        
        var size = CGSize.zero
        switch axis {
        case .horizontal:
            size.width = titleSize.width + imageSize.width
            if titleSize.width != .zero && imageSize.width != .zero {
                size.width += spacing
            }
            size.height = max(titleSize.height, imageSize.height)
        case .vertical:
            size.width = max(titleSize.width, imageSize.width)
            size.height = titleSize.height + imageSize.height
            if titleSize.height != .zero && imageSize.height != .zero {
                size.height += spacing
            }
        }
        size.width += contentInsets.left + contentInsets.right
        size.height += contentInsets.top + contentInsets.bottom
        
        self.contentSize = size
        self.contentOffset = bounds.size == .zero ? .zero : CGPoint(x: (bounds.width - contentSize.width) * 0.5, y: (bounds.height - contentSize.height) * 0.5)
    }
    
    private func layoutImageView() {
        var imageFrame = CGRect(origin: .zero, size: imageSize)
        switch axis {
        case .horizontal:
            if imageSize != .zero {
                if isReverse {
                    imageFrame.origin.x = titleSize.width == 0 ? 0 : titleSize.width + spacing
                }
                imageFrame.origin.y = (contentSize.height - imageSize.height) * 0.5
                imageFrame.origin.x += contentInsets.left
            }
        case .vertical:
            if imageSize != .zero {
                if isReverse {
                    imageFrame.origin.y = titleSize.height == 0 ? 0 : titleSize.height + spacing
                }
                imageFrame.origin.x = (contentSize.width - imageSize.width) * 0.5
                imageFrame.origin.y += contentInsets.top
            }
        }
        imageFrame.origin.x += contentOffset.x
        imageFrame.origin.y += contentOffset.y
        if imageView?.frame != imageFrame {
            imageView?.frame = imageFrame
        }
    }
    
    private func layoutTitleLabel() {
        var titleFrame = CGRect(origin: .zero, size: titleSize)
        switch axis {
        case .horizontal:
            if titleSize != .zero {
                if !isReverse {
                    titleFrame.origin.x = imageSize.width == 0 ? 0 : imageSize.width + spacing
                }
                titleFrame.origin.y = (contentSize.height - titleSize.height) * 0.5
                titleFrame.origin.x += contentInsets.left
            }
        case .vertical:
            if titleSize != .zero {
                if !isReverse {
                    titleFrame.origin.y = imageSize.height == 0 ? 0 : imageSize.height + spacing
                }
                titleFrame.origin.x = (contentSize.width - titleSize.width) * 0.5
                titleFrame.origin.y += contentInsets.top
            }
        }
        titleFrame.origin.x += contentOffset.x
        titleFrame.origin.y += contentOffset.y
        if titleLabel?.frame != titleFrame {
            titleLabel?.frame = titleFrame
        }
    }
    
    private func layoutBadgeValue() {
        if badgeLabel.isHidden {
            return
        }
        // 内容部分右上角位置
        var topRight = CGPoint(x: contentOffset.x + contentSize.width, y: contentOffset.y)
        
        if let titleRect = titleLabel?.frame,
           let imageRect = imageView?.frame,
           !(titleRect.width == .zero && imageRect.size == .zero)
        {
            let baseRect: CGRect
            if titleRect.width == .zero {
                baseRect = imageRect
            } else if imageRect.size == .zero {
                baseRect = titleRect
            } else {
                switch axis {
                case .horizontal:
                    baseRect = isReverse ? imageRect : titleRect
                case .vertical:
                    baseRect = isReverse ? titleRect : imageRect
                }
            }
            topRight.x = baseRect.maxX
            topRight.y = baseRect.minY
        }
        
        let badgeSize = badgeLabel.intrinsicContentSize
        badgeLabel.layer.cornerRadius = badgeSize.height * 0.5
        let badgeRect = CGRect(x: topRight.x - 5, y: topRight.y - badgeSize.height + 7, width: badgeSize.width, height: badgeSize.height)
        if badgeLabel.frame != badgeRect {
            badgeLabel.frame = badgeRect
        }
    }
    
}
