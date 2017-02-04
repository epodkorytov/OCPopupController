import Foundation



open class OCPopupView:UIControl, UIGestureRecognizerDelegate {
    fileprivate let ground      : UIControl = {
        let ground = UIControl()
            ground.translatesAutoresizingMaskIntoConstraints = false
        return ground
    }()
    
    open let owner : UIWindow = UIApplication.shared.keyWindow!
    
    fileprivate let popupView : UIView? = nil
    
    //
    open var style: OCPopupViewStyle = OCPopupViewStyleDefault() {
        didSet {
            configureStyle()
        }
    }
    //
    struct Static
    {
        static var instance: OCPopupView?
    }
    
    open class var sharedInstance: OCPopupView
    {
        if Static.instance == nil
        {
            Static.instance = OCPopupView()
        }
        
        return Static.instance!
    }
    
    //MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonElements()
        setupConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCommonElements()
        setupConstraints()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func dispose()
    {
        OCPopupView.Static.instance = nil
        print("Disposed Singleton instance, token set by 0")
    }
    
    //
    fileprivate func setupCommonElements() {
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0.0
        addSubview(ground)
        
        owner.addSubview(self)
        
        configureStyle()
    }
    
    fileprivate func configureStyle() {
        ground.backgroundColor = style.backgroundColor
    }
    
    // MARK: Constraints
    fileprivate func setupConstraints() {
        
        [.left, .right, .top, .bottom].forEach(
            { owner.addConstraint(NSLayoutConstraint( item: self,
                                                      attribute: $0,
                                                      relatedBy: .equal,
                                                      toItem: owner,
                                                      attribute: $0,
                                                      multiplier: 1.0,
                                                      constant: 0))
        })
        
        [.left, .right, .top, .bottom].forEach(
            {
                self.addConstraint(NSLayoutConstraint( item: ground,
                                                      attribute: $0,
                                                      relatedBy: .equal,
                                                      toItem: self,
                                                      attribute: $0,
                                                      multiplier: 1.0,
                                                      constant: 0))
        })
    }
    
    // MARK: Show
    open func show(hideOnTouch: Bool? = true)
    {
        if hideOnTouch != nil && hideOnTouch! {
            let groundTouch  = UITapGestureRecognizer(target: self, action: #selector(OCPopupView.didGroundTouch(sender:)))
                groundTouch.numberOfTapsRequired = 1
                groundTouch.delegate = self
            
            ground.addGestureRecognizer(groundTouch)
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1.0
        }) { (finished) in
            
            super.updateConstraints()
            self.layoutIfNeeded()
        }
        
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: Hide
    func hide(delay:TimeInterval? = 0, _ completion: @escaping((() -> Void)))
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay!)
        {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.alpha = 0.0
            }) { (finished) in
                self.removeFromSuperview()
                completion()
                self.dispose()
            }
        }
        
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    //
    
    // MARK: gestureRecognizer Delegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if popupView?.superview != nil
        {
            if touch.view!.isDescendant(of: popupView!)
            {
                //allow touch only for ground
                return false
            }
        }
        return true
    }
    
    func didGroundTouch(sender: UITapGestureRecognizer? = nil) {
        hide {}
    }
}
