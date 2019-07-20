//
//  HeatmapPostProcessor.swift
//  DepthPrediction-CoreML
//
//  Created by Doyoung Gwak on 20/07/2019.
//  Copyright © 2019 Doyoung Gwak. All rights reserved.
//

import CoreML

class HeatmapPostProcessor {
    func convertTo2DArray(from heatmaps: MLMultiArray) -> Array<Array<Double>> {
        guard heatmaps.shape.count >= 3 else {
            print("heatmap's shape is invalid. \(heatmaps.shape)")
            return []
        }
        let _/*keypoint_number*/ = heatmaps.shape[0].intValue
        let heatmap_w = heatmaps.shape[1].intValue
        let heatmap_h = heatmaps.shape[2].intValue
        
        var convertedHeatmap: Array<Array<Double>> = Array(repeating: Array(repeating: 0.0, count: heatmap_w), count: heatmap_h)
        
//        for k in 0..<keypoint_number {
        for i in 0..<heatmap_w {
            for j in 0..<heatmap_h {
                let index = i*(heatmap_h) + j
                let confidence = heatmaps[index].doubleValue
                guard confidence > 0 else { continue }
                convertedHeatmap[j][i] = confidence
            }
        }
//        }
        
//        convertedHeatmap = convertedHeatmap.map { row in
//            return row.map { element in
//                if element > 1.0 {
//                    return 1.0
//                } else if element < 0 {
//                    return 0.0
//                } else {
//                    return element
//                }
//            }
//        }
        
        return convertedHeatmap
    }
}
