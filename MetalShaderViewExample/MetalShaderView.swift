//
//  MetalShaderView.swift
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

import MetalKit

class MetalShaderView: MTKView {

    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private var positionBuffer: MTLBuffer?
    private var colorBuffer: MTLBuffer?
    private var timer: Float = 0
    private var timerIncrement: Float = 0.025
    private let scale: Float = Float(UIScreen.main.scale)
    private var touchPoint: CGPoint = .zero
    let vertexShaderName: String
    let fragmentShaderName: String

    // vertices for a quad (2 triangles)
    private let positionArray: [SIMD4<Float>] = [
        SIMD4<Float>(-1.0, -1.0, 0.0, 1),
        SIMD4<Float>(1.0, -1.0, 0.0, 1),
        SIMD4<Float>(-1.0, 1.0, 0.0, 1),
        SIMD4<Float>(-1.0, 1.0, 0.0, 1),
        SIMD4<Float>(1.0, -1.0, 0.0, 1),
        SIMD4<Float>(1.0, 1.0, 0.0, 1)
    ]

    // black
    private let colorArray: [SIMD3<Float>] = [
        SIMD3<Float>(0, 0, 0),
        SIMD3<Float>(0, 0, 0),
        SIMD3<Float>(0, 0, 0),
        SIMD3<Float>(0, 0, 0),
        SIMD3<Float>(0, 0, 0),
        SIMD3<Float>(0, 0, 0)
    ]


    init?(vertexShaderName: String,
          fragmentShaderName: String) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue(),
              let library = device.makeDefaultLibrary() else {
                fatalError("Failed to set up shader view")
                return nil
        }
        // creating MTLRenderPipelineState is expensive
        guard let plState = try? PipelineStateFactory.createPipelineState(
                                    device: device,
                                    library: library,
                                    vertexShaderName: vertexShaderName,
                                    fragmentShaderName: fragmentShaderName) else {
            return nil
        }
        self.commandQueue = commandQueue
        self.pipelineState = plState
        let positionLength = MemoryLayout<SIMD4<Float>>.stride * positionArray.count
        positionBuffer = device.makeBuffer(bytes: positionArray,
                                           length: positionLength,
                                           options: [])
        let colorLength = MemoryLayout<SIMD3<Float>>.stride * colorArray.count
        colorBuffer = device.makeBuffer(bytes: colorArray,
                                        length: colorLength,
                                        options: [])
        self.vertexShaderName = vertexShaderName
        self.fragmentShaderName = fragmentShaderName
        super.init(frame: .zero, device: device)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let drawable = currentDrawable,
              let descriptor = currentRenderPassDescriptor,
              let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
                return
        }
        timer += timerIncrement
        if timer >= Float.greatestFiniteMagnitude - timerIncrement { // prevent overflow
            timer = 0
        }
        commandEncoder.setVertexBytes(&timer,
                                      length: MemoryLayout<Float>.stride,
                                      index: 2)
        var resolution = SIMD2<Float>(Float(bounds.size.width) * scale, Float(bounds.size.height) * scale)
        commandEncoder.setVertexBytes(&resolution,
                                      length: MemoryLayout<SIMD2<Float>>.stride,
                                      index: 3)
        var touchCoord = SIMD2<Float>(Float(touchPoint.x) * scale, Float(touchPoint.y) * scale)
        commandEncoder.setVertexBytes(&touchCoord,
                                      length: MemoryLayout<SIMD2<Float>>.stride,
                                      index: 4)
        commandEncoder.setRenderPipelineState(pipelineState)
        commandEncoder.setVertexBuffer(positionBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBuffer(colorBuffer, offset: 0, index: 1)
        commandEncoder.drawPrimitives(type: .triangle,
                                      vertexStart: 0,
                                      vertexCount: 6)
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

}

extension MetalShaderView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            touchPoint = touch.location(in: self)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            touchPoint = touch.location(in: self)
        }
    }

}

fileprivate struct PipelineStateFactory {

    static func createPipelineState(device: MTLDevice,
                                    library: MTLLibrary,
                                    vertexShaderName: String,
                                    fragmentShaderName: String) throws -> MTLRenderPipelineState {
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        let vertexFunction = library.makeFunction(name: vertexShaderName)
        let fragmentFunction = library.makeFunction(name: fragmentShaderName)
        pipelineStateDescriptor.vertexFunction = vertexFunction
        pipelineStateDescriptor.fragmentFunction = fragmentFunction
        return try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }
}

