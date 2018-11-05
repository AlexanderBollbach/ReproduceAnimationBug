
import UIKit

protocol ViewFrameUpdatorDelegate: class {
    func frameUpdated()
}

class RealTimeViewUpdator {
    
    weak var delegate: ViewFrameUpdatorDelegate?
    
    init(delegate: ViewFrameUpdatorDelegate) { self.delegate = delegate }
    
    @objc func update() { delegate?.frameUpdated() }
}


class AnimatingFramedView: UIView {
    
    var isPaused = false
    
    private var timer: Timer?
    private lazy var viewFrameUpdater = RealTimeViewUpdator(delegate: self)
    
    var tick = 0
    
    let imageView = UIImageView()
    
    init(defaultFrameRate: Int) {
        super.init(frame: .zero)
        imageView.pinTo(superView: self)
        set(framerate: defaultFrameRate)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func set(framerate: Int) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1 / Double(framerate),
            target: viewFrameUpdater,
            selector: #selector(RealTimeViewUpdator.update),
            userInfo: nil,
            repeats: true
        )
        timer?.tolerance = 0.001
    }
    
    func newFrame() {
        nextTick()
        
        if isPaused { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let image = self?.frameProvider() else { return }
            
            DispatchQueue.main.async {
                print("update \(Date())")
                self?.imageView.image = image
            }
        }
    }
    
    private func nextTick() {
        tick = tick + 1 >= 100 ? 0 : tick + 1
    }
    
    func frameProvider() -> UIImage? { fatalError("override me") }
}

extension AnimatingFramedView: ViewFrameUpdatorDelegate {
    func frameUpdated() { newFrame() }
}


