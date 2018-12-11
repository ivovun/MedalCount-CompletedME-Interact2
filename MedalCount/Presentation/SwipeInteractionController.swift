//
//  SwipeInteractionController.swift
//  MedalCount
//
//  Created by vladimirfilippov on 09/12/2018.
//  Copyright © 2018 Ron Kliffer. All rights reserved.
//

import UIKit

protocol HasSwipeInterractionControllerProperty {
  var swipeInteractionController: SwipeInteractionController? {get  set}
}


class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
  
  var interactionInProgress = false //as the name suggests, indicates whether an interaction is already happening.
  
  private var shouldCompleteTransition = false //will be used internally to control the transition
  private weak var viewController: UIViewController! //is a reference to the view controller to which this interaction controller is attached.
  
  init(viewController: UIViewController) {
    super.init()
    self.viewController = viewController
    prepareGestureRecignizer(in: viewController.view)
  }
  
  
  private func prepareGestureRecignizer(in view: UIView) {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
    
    view.addGestureRecognizer(gesture)
    
  }
  
  @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    
    //1
    
    let translation  = gestureRecognizer.translation(in: gestureRecognizer.view!.superview) //local variables to track the progress of the swipe. You fetch the translation in the view and calculate the progress. A swipe of 200 or more points will be considered enough to complete the transition.
    var progress = translation.x / 200
    progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
    
    
    switch gestureRecognizer.state {
      
    //2
    case .began: //When the gesture starts, you set interactionInProgress to true and trigger the dismissal of the view controller.
      interactionInProgress = true
      viewController.dismiss(animated: true, completion: nil)
      
    //3
    case .changed:
      shouldCompleteTransition = progress > 0.5
      update(progress)
      
    //4
    case .cancelled:
      interactionInProgress = false
      cancel()
      
    //5
    case .ended:
      interactionInProgress = false
      if shouldCompleteTransition {
        finish()
      } else {
        cancel()
      }
      
    default:
      break
    }
    
    
  }
}
