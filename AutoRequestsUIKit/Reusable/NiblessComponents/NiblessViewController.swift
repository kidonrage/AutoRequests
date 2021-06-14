//
//  NiblessViewController.swift
//  AutoRequestsUIKit
//
//  Created by Vlad Eliseev on 14.06.2021.
//

import UIKit

open class NiblessViewController: UIViewController {

    // MARK: - Initializers
    public init() {
      super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable,
      message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection."
    )
    public required init?(coder aDecoder: NSCoder) {
      fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }

}
