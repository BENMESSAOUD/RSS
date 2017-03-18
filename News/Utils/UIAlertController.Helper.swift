//
//  UIAlertController.Helper.swift
//  DudeChat
//
//  Created by Mahmoud ben messaoud on 01/12/2016.
//  Copyright © 2016 Pixit Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController{
    public func addCancelActionWithTitle(_ title:String){
        let cancelAction = UIAlertAction(title: title, style: .cancel, handler: { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        self.addAction(cancelAction)
    }
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else
            if let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion);
        }
    }
}
