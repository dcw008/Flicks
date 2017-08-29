//
//  LayerContainerView.swift
//  Flicks
//
//  Created by Derrick Wong on 8/29/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

//custom ui view for the gradient layer
class LayerContainerView: UIView {

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor
        ]
    }

}
