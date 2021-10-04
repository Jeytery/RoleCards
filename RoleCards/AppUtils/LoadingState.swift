//
//  LoadingState.swift
//  RoleCards
//
//  Created by Jeytery on 01.10.2021.
//

import UIKit

class LoadingState {
    
    private lazy var transparentView: UIView = {
        let v = UIView()
        v.frame = UIScreen.main.bounds
        v.backgroundColor = .black
        v.alpha = 0.6
        return v
    }()
    
    private var loadingView = LoadingView(frame: UIScreen.main.bounds)
    
    fileprivate var window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    
    fileprivate static let shared = LoadingState()
}


//MARK: - public
extension LoadingState {
    static func start() {
        DispatchQueue.main.async {
            LoadingState.shared.window?.addSubview(LoadingState.shared.loadingView)
            LoadingState.shared.loadingView.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                LoadingState.shared.loadingView.alpha = 0.6
            })
            LoadingState.shared.loadingView.showSpinner()
        }
    }
    
    static func stop() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                LoadingState.shared.loadingView.alpha = 0
            }, completion: {
                _ in
                LoadingState.shared.transparentView.removeFromSuperview()
            })
        }
    }
}

//MARK: - LoadingView
fileprivate class LoadingView: UIView {
    
    private var spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(style: .white)
        return s
    }()
 
    override init(frame: CGRect = .zero) { super.init(frame: frame) }
    
    override func willMove(toSuperview newSuperview: UIView?) { configureUI() }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configureUI() {
        backgroundColor = .black
        alpha = 0.6
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func showSpinner() {
        spinner.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            [spinner] in
            spinner.alpha = 1
        })
    }
}
