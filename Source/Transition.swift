import UIKit

open class Transition: NSObject {

  fileprivate var presentingViewController = false

  open var transitionDuration: TimeInterval = 0.6
  open var animationDuration: TimeInterval = 0.3
  open var delay: TimeInterval = 0
  open var spring: (damping: CGFloat, velocity: CGFloat) = (1, 1)
  var closure: ((_ controller: UIViewController, _ show: Bool) -> Void)

  public required init(closure: @escaping ((_ controller: UIViewController, _ show: Bool) -> Void)) {
    self.closure = closure
    super.init()
  }

  func transition(_ controller: UIViewController, show: Bool) {
    closure(controller, show)
  }
}

extension Transition : UIViewControllerAnimatedTransitioning {

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return transitionDuration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let screens : (from: UIViewController, to: UIViewController) = (
      transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!,
      transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!)
    let presentedViewController = !presentingViewController
      ? screens.from as UIViewController
      : screens.to as UIViewController
    let viewController = !presentingViewController
      ? screens.to as UIViewController
      : screens.from as UIViewController

    for controller in [viewController, presentedViewController] {
      if let subview = controller.view { containerView.addSubview(subview) }
    }

    transition(presentedViewController, show: !presentingViewController)

    UIView.animate(withDuration: animationDuration, delay: delay, usingSpringWithDamping: spring.damping, initialSpringVelocity: spring.velocity, options: .beginFromCurrentState, animations: {
      self.transition(presentedViewController, show: self.presentingViewController)
      }, completion: { finished in
        transitionContext.completeTransition(finished)
        UIApplication.shared.keyWindow!.addSubview(screens.to.view)
    })
  }
}

extension Transition : UIViewControllerTransitioningDelegate {

  public func animationController(forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      presentingViewController = true
      return self
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    presentingViewController = false
    return self
  }
}
