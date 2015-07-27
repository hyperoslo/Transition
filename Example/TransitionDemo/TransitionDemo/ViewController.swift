import UIKit
import Transition

class ViewController: UIViewController {

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      controller.view.transform = show
        ? CGAffineTransformIdentity
        : CGAffineTransformMakeScale(3, 3)

      controller.view.alpha = show ? 1 : 0
      controller.view.backgroundColor = UIColor.redColor()
    }
    
    return transition
  }()

  override func viewDidLoad() {
    modalPresentationStyle = .Custom

    title = "Transition Demo"
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
      style: .Plain,
      target: self,
      action: "presentController")
  }

  func presentController() {
    let controller = UIViewController()
    controller.view.backgroundColor = UIColor.greenColor()
    controller.transitioningDelegate = transition

    presentViewController(controller, animated: true, completion: nil)
  }
}
