import UIKit

func render(
    project: Project,
    tick: Int
    ) -> CGImage?
{
    
    let context = CGContext(data: nil,
                            width: 100,
                            height: 100,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * 100,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let rect = CGRect(
        x: 0,
        y: 0,
        width: 100,
        height: 100
    )
    let re = RenderingEnvironment(
        context: context,
        rect: rect
    )
    
    renderLayers(project.layers, re: re, tick: tick)
    
    return context.makeImage()
}


func renderLayers(
    _ layers: [Layer],
    re: RenderingEnvironment,
    tick: Int
    )
{
    re.context.clear(re.rect)
    
    for layer in layers {
        renderLayer(layer, re: re, tick: tick)
    }
}

func renderLayer(_ layer: Layer, re: RenderingEnvironment, tick: Int) {
    
    let props = pulse(props: layer.props)
    
    render(props, re: re)
}

var tick = 0

func pulse(props: RenderableProps) -> RenderableProps {
    
    tick += 1
    
    var props = props
    
    let amount = 0.5
    let speed = 10.0
    
    if amount < 0.05 {
        return props
    }
    
    let amountNormed = (Double(tick) * 0.01)
    
    let value = abs(
        sin(amountNormed * (1 + speed))
            .toRange(low: 1, high: 10)
    )
    
    props.strokeWidth = value
    
    return props
}



func render(_ props: RenderableProps, re: RenderingEnvironment) {
    
    for path in props.paths.all {
        render(path: path,
               color: UIColor.red.cgColor,
               lineWidth: props.strokeWidth,
               re: re)
    }
}

func render(path: Path, color: CGColor, lineWidth: Double, re: RenderingEnvironment) {
    
    re.context.setLineWidth(CGFloat(lineWidth))
    re.context.setStrokeColor(color)
    re.context.setLineCap(.round)
    re.context.setLineJoin(.bevel)
    
    for point in path.points.enumerated() {
        
        let transformedPoint = point.element//transform.applyTransformToPoint(point.element)
        
        if point.offset == 0 {
            re.context.move(to: transformedPoint.getCGPoint(from: re.rect))
        } else {
            re.context.addLine(to: transformedPoint.getCGPoint(from: re.rect))
        }
    }
    
    re.context.strokePath()
}




