//
//  QSSearchRouter.swift
//  zhuishushenqi
//
//  Created caonongyun on 2017/4/10.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class QSSearchRouter: QSSearchWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = QSSearchViewController(nibName: nil, bundle: nil)
        let interactor = QSSearchInteractor()
        let router = QSSearchRouter()
        let presenter = QSSearchPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func presentDetails(_ novel:Book){
        let bookDetailVC = BookDetailViewController()
        let book:Book? = novel
        bookDetailVC.id = book?._id ?? ""
        viewController?.navigationController?.pushViewController(bookDetailVC, animated: true)
    }
    
}