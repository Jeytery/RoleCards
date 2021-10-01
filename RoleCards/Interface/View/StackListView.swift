//
//  StackListView.swift
//  3bit_app
//
//  Created by Jeytery on 13.08.2021.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class StackListView: UIView {
    
    private(set) var views = Array<UIView>()
    
    private(set) var stackView = UIStackView()
    
    private let scrollView = UIScrollView()
    
    init(axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)
        configureUI(axis: axis)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

//MARK: - internal functions
extension StackListView {
    private func configureUI(axis: NSLayoutConstraint.Axis) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        stackView.distribution = .equalSpacing
        if axis == .vertical {
            addSubview(scrollView)
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            scrollView.addSubview(stackView)
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            stackView.axis = axis
        }
        else {
            addSubview(scrollView)
            scrollView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            scrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            
            scrollView.addSubview(stackView)
            stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            stackView.axis = axis
        }
        stackView.spacing = 10
    }
 
    private func setViewSize(_ view: UIView, size: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if stackView.axis == .vertical {
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        else {
            view.widthAnchor.constraint(equalToConstant: size).isActive = true
        }
    }
}

//MARK: - public functions
extension StackListView {
    func addView(_ view: UIView, size: CGFloat) {
        stackView.addArrangedSubview(view)
        views.append(view)
        setViewSize(view, size: size)
    }
    
    func addViews(_ views: Array<UIView>, size: CGFloat) {
        for view in views { addView(view, size: size) }
    }
}
