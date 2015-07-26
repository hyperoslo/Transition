import UIKit

public class Transition: NSObject {

  private var presentingViewController = false

  public var transitionDuration: NSTimeInterval = 0.6
  public var animationDuration: NSTimeInterval = 0.3
  public var closure: ((controller: UIViewController, show: Bool) -> Void)

  public required init(closure: ((controller: UIViewController, show: Bool) -> Void)) {
    self.closure = closure
    super.init()
  }

  func transition(controller: UIViewController, show: Bool) {
    closure(controller: controller, show: show)
  }
}

extension Transition : UIViewControllerAnimatedTransitioning {

  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return transitionDuration
  }

  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView()
    let duration = transitionDuration(transitionContext)
    let screens : (from: UIViewController, to: UIViewController) = (
      transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!,
      transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
    let viewController = !presentingViewController
      ? screens.to as UIViewController
      : screens.from as UIViewController

    containerView.addSubview(viewController.view)

    UIView.animateWithDuration(animationDuration, animations: { [unowned self] in
      self.transition(viewController, show: self.presentingViewController)
      }, completion: { _ in
        transitionContext.completeTransition(true)
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