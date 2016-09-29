import UIKit
import Transition

class ViewController: UIViewController {

  lazy var transition: Transition = {
    let transition = Transition() { controller, show in
      controller.view.transform = show
        ? CGAffineTransform.identity
        : CGAffineTransform(scaleX: 3, y: 3)

      controller.view.alpha = show ? 1 : 0
      controller.view.backgroundColor = UIColor.red
    }
    
    return transition
  }()

  override func viewDidLoad() {
    modalPresentationStyle = .custom

    title = "Transition Demo"
    view.backgroundColor = UIColor.white
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Transition",
      style: .plain,
      target: self,
      action: #selector(ViewController.presentController))
  }

  func presentController() {
    let controller = UIViewController()
    controller.view.backgroundColor = UIColor.green
    controller.transitioningDelegate = transition

    present(controller, animated: true, completion: nil)
  }
}
