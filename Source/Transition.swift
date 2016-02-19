import UIKit

public class Transition: NSObject {

  private var presentingViewController = false

  public var transitionDuration: NSTimeInterval = 0.6
  public var animationDuration: NSTimeInterval = 0.3
  public var delay: NSTimeInterval = 0
  public var spring: (damping: CGFloat, velocity: CGFloat) = (1, 1)
  var closure: ((controller: UIViewController, show: Bool) -> Void)

  public required init(closure: ((controller: UIViewController, show: Bool) -> Void)) {
    self.closure = closure
    super.init()
  }

  func transition(controller: UIViewController, show: Bool) {
    closure(controller: controller, show: show)
  }
}

extension Transition : UIViewControllerAnimatedTransitioning {

  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return transitionDuration
  }

  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView()!
    let screens : (from: UIViewController, to: UIViewController) = (
      transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,
      transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
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

    UIView.animateWithDuration(animationDuration, delay: delay, usingSpringWithDamping: spring.damping, initialSpringVelocity: spring.velocity, options: .BeginFromCurrentState, animations: {
      self.transition(presentedViewController, show: self.presentingViewController)
      }, completion: { finished in
        transitionContext.completeTransition(finished)
        UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
    })
  }
}

extension Transition : UIViewControllerTransitioningDelegate {

  public func animationControllerForPresentedController(presented: UIViewController,
    presentingController presenting: UIViewController,
    sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      presentingViewController = true
      return self
  }

  public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    presentingViewController = false
    return self
  }
}
