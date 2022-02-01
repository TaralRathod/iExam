//
//  UIViewController.Extension.swift
//  iExam
//
//  Created by Taral Rathod on 23/01/22.
//

import Foundation
import UIKit

struct Navigator {
    
    // MARK: - DisplayVCType enum

    enum DisplayVCType {
        case push
        case present
    }
    
    // MARK: - Properties
    
    private var viewController: UIViewController
    static private let mainSBName = Constants.mainStroyboard

    // MARK: - Init

    init(vc: UIViewController) {
        self.viewController = vc
    }
    
    // MARK: - Public Methods
    
    public func instantiateVC<T>(withDestinationViewControllerType vcType: T.Type,
                                            andStoryboardName sbName: String = mainSBName) -> T? where T: UIViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: sbName, bundle: nil)
        let destinationVC = storyBoard.instantiateViewController(withIdentifier: String(describing: vcType.self))

        return destinationVC as? T
    }
    
    public func goTo(viewController destinationVC: UIViewController,
                     withDisplayVCType type: DisplayVCType = .present,
                     andModalPresentationStyle style: UIModalPresentationStyle = .fullScreen,
                     andModalTransitionStyle transition: UIModalTransitionStyle = .flipHorizontal) {
        switch type {
        case .push:
            viewController.navigationController?.pushViewController(destinationVC, animated: true)
        case .present:
            destinationVC.modalTransitionStyle = transition
            destinationVC.modalPresentationStyle = style
            viewController.present(destinationVC, animated: true, completion: nil)
        }
    }
}
