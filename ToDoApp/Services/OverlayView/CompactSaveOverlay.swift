//
//  CompactSaveOverlay.swift
//  ToDoApp
//
//  Created by Павел on 25.03.2025.
//

import UIKit

class CompactSaveOverlay: UIView {
    
    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Sizes.blurViewCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сохранение..."
        label.font = UIFont.systemFont(ofSize: Sizes.saveOverlayTitleLabel, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.alpha = 0
        self.isUserInteractionEnabled = false
        
        addSubview(container)
        container.addSubview(blurView)
        container.addSubview(activityIndicator)
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: Sizes.saveOverlayContainerWidth),
            container.heightAnchor.constraint(equalToConstant: Sizes.saveOverlayContainerHeight),
            
            blurView.topAnchor.constraint(equalTo: container.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            activityIndicator.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.saveOverlayConstant),
            activityIndicator.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: activityIndicator.trailingAnchor, constant: Constants.saveOverlayConstant),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.saveOverlayConstant),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
    
    func show(in view: UIView, with duration: TimeInterval = 2.0) {
        view.addSubview(self)
        frame = view.bounds
        activityIndicator.startAnimating()
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut) {
                self.alpha = 1
                self.transform = .identity
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

