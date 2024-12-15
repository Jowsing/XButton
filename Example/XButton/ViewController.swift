//
//  ViewController.swift
//  XButton
//
//  Created by jowsing on 12/08/2024.
//  Copyright (c) 2024 jowsing. All rights reserved.
//

import UIKit
import XButton
import SnapKit

let Image = UIImage(systemName: "heart.fill")?.withTintColor(.systemPink)
let Title = "Heart"
let ImageSize = CGSize(width: 40, height: 36)

class ViewController: UIViewController {
        
    struct ButtonStyle {
        let type: String
        let image: UIImage?
        let title: String?
        let axis: XButton.Axis
        let reverse: Bool
        let imageSize: CGSize?
        let badgeValue: String?
        
        init(image: UIImage? = nil, title: String? = nil, axis: XButton.Axis = .horizontal, reverse: Bool = false, imageSize: CGSize? = nil, badgeValue: String? = nil, type: String) {
            self.image = image
            self.title = title
            self.axis = axis
            self.reverse = reverse
            self.imageSize = imageSize
            self.badgeValue = badgeValue
            self.type = type
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let styles: [ButtonStyle] = [
            .init(image: Image, title: nil, axis: .horizontal, reverse: false, imageSize: nil, badgeValue: "99+", type: "Image Only"),
            .init(image: Image, title: nil, axis: .horizontal, reverse: false, imageSize: ImageSize, badgeValue: nil, type: "Image Only (Size Fixed)"),
            .init(image: nil, title: Title, axis: .horizontal, reverse: false, imageSize: nil, badgeValue: "99+", type: "Title Only"),
            .init(image: Image, title: Title, axis: .horizontal, reverse: false, imageSize: nil, badgeValue: "99+", type: "Image And Title (horizontal)"),
            .init(image: Image, title: Title, axis: .horizontal, reverse: true, imageSize: nil, badgeValue: nil, type: "Title And Image (horizontal)"),
            .init(image: Image, title: Title, axis: .vertical, reverse: false, imageSize: ImageSize, badgeValue: "😂", type: "Image And Title (vertical)"),
            .init(image: Image, title: Title, axis: .vertical, reverse: true, imageSize: nil, badgeValue: nil, type: "Image And Title (vertical)"),
        ]
        for i in 0..<styles.count {
            let style = styles[i]
            let btn = XButton()
            btn.spacing = 5
            btn.tag = i + 2024
            btn.axis = style.axis
            btn.isReverse = style.reverse
            btn.fixedImageSize = style.imageSize
            btn.setImage(style.image, for: .normal)
            btn.setTitle(style.title, for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.setTitleColor(.black.withAlphaComponent(0.6), for: .highlighted)
            btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            btn.badgeValue = style.badgeValue
            if style.badgeValue == "😂" {
                btn.badgeColor = .systemGreen
            }
            view.addSubview(btn)
            
            let label = UILabel()
            label.text = style.type + ":"
            label.textColor = .gray
            label.font = .systemFont(ofSize: 13)
            view.addSubview(label)
            
            label.snp.makeConstraints { make in
                if i == 0 {
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                } else {
                    make.top.equalTo(view.viewWithTag(i + 2023)!.snp.bottom).offset(50)
                }
                make.centerX.equalToSuperview()
            }
            
            btn.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

