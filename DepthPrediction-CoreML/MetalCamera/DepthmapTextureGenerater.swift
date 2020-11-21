//
//  AlphaBlend.swift → DepthmapTextureGenerater.swift
//  MetalCamera → DepthPrediction-CoreML
//
//  Created by Eric on 2020/06/16.
//  Updated by Doyoung Gwak on 2020/11/21.
//

import MetalKit
import Accelerate
import CoreML

class DepthmapTextureGenerater: NSObject {
    
    private var pipelineState: MTLRenderPipelineState!
    private var render_target_vertex: MTLBuffer!
    private var render_target_uniform: MTLBuffer!
    
    private func setupPiplineState(_ colorPixelFormat: MTLPixelFormat = .bgra8Unorm, width: Int, height: Int) {
        do {
            let rpd = try sharedMetalRenderingDevice.generateRenderPipelineDescriptor("vertex_render_target",
                                                                                      "depthmap_render_target",
                                                                                      colorPixelFormat)
            pipelineState = try sharedMetalRenderingDevice.device.makeRenderPipelineState(descriptor: rpd)

            render_target_vertex = sharedMetalRenderingDevice.makeRenderVertexBuffer(size: CGSize(width: width, height: height))
            render_target_uniform = sharedMetalRenderingDevice.makeRenderUniformBuffer(CGSize(width: width, height: height))
        } catch {
            debugPrint(error)
        }
    }
    
    func texture(_ depthMap: MLMultiArray, _ row: Int, _ col: Int) -> Texture? {
        if pipelineState == nil {
            setupPiplineState(width: col, height: row)
        }

        let outputTexture = Texture(col, row, textureKey: "depthprediction")

        let renderPassDescriptor = MTLRenderPassDescriptor()
        let attachment = renderPassDescriptor.colorAttachments[0]
        attachment?.clearColor = .red
        attachment?.texture = outputTexture.texture
        attachment?.loadAction = .clear
        attachment?.storeAction = .store

        let commandBuffer = sharedMetalRenderingDevice.commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)

        commandEncoder?.setRenderPipelineState(pipelineState)

        commandEncoder?.setVertexBuffer(render_target_vertex, offset: 0, index: 0)
        commandEncoder?.setVertexBuffer(render_target_uniform, offset: 0, index: 1)
        
        // convert Double to Float
        let length = depthMap.count
        let doublePtr =  depthMap.dataPointer.bindMemory(to: Double.self, capacity: length)
        let doubleBuffer = UnsafeBufferPointer(start: doublePtr, count: length)
        var inputArray = Array(doubleBuffer)
        var resultArray = [Float](repeating: 0, count: length)
        let n = vDSP_Length(min(inputArray.count, resultArray.count))
        var resultPointer: UnsafeMutableBufferPointer<Float>?
        inputArray.withUnsafeMutableBufferPointer { (inputPointer) -> Void in
            resultArray.withUnsafeMutableBufferPointer { (outputPointer) -> Void in
                vDSP_vdpsp(inputPointer.baseAddress!, 1,
                           outputPointer.baseAddress!, 1, n)
                resultPointer = outputPointer
            }
        }
        
        // normalize to 0.0~1.0
        var maxValue: Float = 0.0
        vDSP_maxv(resultPointer!.baseAddress!, 1, &maxValue, n)
        var minValue: Float = 1.0
        vDSP_minv(resultPointer!.baseAddress!, 1, &minValue, n)
        var subtracOperanderArray = Array(repeating: minValue, count: Int(n))
        let floorValue = maxValue - minValue
        let multiplyOperanderValue = (floorValue == 0.0) ? 0.0 : 1 / (maxValue - minValue)
        var multiplyOperanderArray = Array(repeating: multiplyOperanderValue, count: Int(n))
        subtracOperanderArray.withUnsafeMutableBufferPointer { (subtracOperanderPointer) -> Void in
            multiplyOperanderArray.withUnsafeMutableBufferPointer { (multiplyOperanderPointer) -> Void in
                vDSP_vsbm(resultPointer!.baseAddress!, 1,
                          subtracOperanderPointer.baseAddress!, 1,
                          multiplyOperanderPointer.baseAddress!, 1,
                          resultPointer!.baseAddress!, 1, n)
            }
        }

        let segmentationBuffer = sharedMetalRenderingDevice.device.makeBuffer(bytes: resultPointer!.baseAddress!,
                                                                              length: resultArray.count * MemoryLayout<Float>.size, // Double가 맞나?, mlmodel output에 나온대로 Double로 변경함
                                                                              options: [])!
        commandEncoder?.setFragmentBuffer(segmentationBuffer, offset: 0, index: 0)

        let uniformBuffer = sharedMetalRenderingDevice.device.makeBuffer(bytes: [Int32(col), Int32(row)] as [Int32],
                                                                         length: 3 * MemoryLayout<Int32>.size,
                                                                         options: [])!
        commandEncoder?.setFragmentBuffer(uniformBuffer, offset: 0, index: 1)

        commandEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        commandEncoder?.endEncoding()
        commandBuffer?.commit()

        return outputTexture
    }
}

extension MTLClearColor {
    static var red: Self {
        return MTLClearColorMake(1, 0, 0, 1) // r, g, b, a
    }
}
