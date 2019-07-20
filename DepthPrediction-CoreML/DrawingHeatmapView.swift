//
//  DrawingHeatmapView.swift
//  DepthPrediction-CoreML
//
//  Created by Doyoung Gwak on 20/07/2019.
//  Copyright © 2019 Doyoung Gwak. All rights reserved.
//

import UIKit

class DrawingHeatmapView: UIView {
    
    var heatmap: Array<Array<Double>>? = nil {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        
        if let ctx = UIGraphicsGetCurrentContext() {
            
            ctx.clear(rect);
            
            guard let heatmap = self.heatmap else { return }
            
            let size = self.bounds.size
            let heatmap_w = heatmap.count
            let heatmap_h = heatmap.first?.count ?? 0
            let w = size.width / CGFloat(heatmap_w)
            let h = size.height / CGFloat(heatmap_h)
            
            for j in 0..<heatmap_h {
                for i in 0..<heatmap_w {
                    let value = heatmap[i][j]
                    var alpha: CGFloat = CGFloat(value)
                    if alpha > 1 {
                        alpha = 1
                    } else if alpha < 0 {
                        alpha = 0
                    }
                    
                    let rect: CGRect = CGRect(x: CGFloat(i) * w, y: CGFloat(j) * h, width: w, height: h)
                    
                    // color
                    //let hue: CGFloat = alpha * (240.0 / 360.0)
                    //let color: UIColor = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 0.94)
                    
                    // gray
                    let color: UIColor = UIColor(white: 1-alpha, alpha: 1)
                    
                    let bpath: UIBezierPath = UIBezierPath(rect: rect)
                    
                    color.set()
                    //bpath.stroke()
                    bpath.fill()
                }
            }
        }
    } // end of draw(rect:)

}
