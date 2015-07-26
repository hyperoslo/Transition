import UIKit
import Transition

class ViewController: UIViewController {

  override func viewDidLoad() {
    let transition = Transition() { controller, show in
      controller.view.transform = show
        ? CGAffineTransformIdentity
        : CGAffineTransformMakeScale(3, 3)

      controller.view.alpha = show ? 1 : 0
    }

    transitioningDelegate = transition
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
    presentViewController(controller, animated: true, completion: nil)
  }
}
