//
//  ViewController.swift
//  MatchO
//
//  Created by Naveen Magatala on 10/27/19.
//  Copyright © 2019 Naveen Magatala. All rights reserved.
//

import UIKit
import SnapKit
import SAConfettiView

class ViewController: UIViewController {
    
    var miniViewFrame = CGRect.zero
    
    lazy var confettiView: SAConfettiView = {
        let view = SAConfettiView(frame: self.view.bounds)
        view.type = .confetti
        view.intensity = 1
        return view
    }()
    
    lazy var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var resetButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "reset"), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(resetTapped),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var miniView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    
    lazy var greatJobLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.alpha = 0
        label.font = UIFont(name: "Baskerville-BoldItalic", size: 60)
        label.text = "Yayy!!"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    override func viewDidLayoutSubviews() {
        guard miniViewFrame == .zero else { return }
        if confettiView.superview == nil {
            view.insertSubview(confettiView, at: 0)
        }
        miniViewFrame = miniView.frame
    }
    
    private func bindView() {
        view.backgroundColor = .systemPink
        
        view.addSubview(greatJobLabel)
        greatJobLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(50)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(resetButton)
        resetButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin).inset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        view.addSubview(miniView)
        miniView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottomMargin).inset(50)
            make.height.width.equalTo(50)
            make.centerX.equalToSuperview()
        }
        let miniViewPanGesture = UIPanGestureRecognizer(target: self,
                                                        action: #selector(miniViewTapped(pan:)))
        miniView.addGestureRecognizer(miniViewPanGesture)
    }
    
    @objc func resetTapped() {
        animate {
            self.miniView.transform = .identity
            self.miniView.frame = self.miniViewFrame
            self.resetButton.alpha = 0
            self.greatJobLabel.alpha = 0
        }
        confettiView.stopConfetti()
    }
    
    @objc func miniViewTapped(pan: UIPanGestureRecognizer) {
        miniView.dragOnce(with: pan,
                          in: view,
                          updatedFrame: miniViewFrame)
        switch pan.state {
        case .changed:
            break
        case .ended:
            if centerView.frame.contains(miniView.frame) {
                miniView.snp.remakeConstraints { make in
                    make.center.equalTo(centerView.center)
                    make.height.width.equalTo(50)
                    miniView.layoutIfNeeded()
                }
                animate {
                    self.miniView.transform = CGAffineTransform(scaleX: 4, y: 4)
                    self.greatJobLabel.alpha = 1
                    self.resetButton.alpha = 1
                }
                confettiView.startConfetti()
            } else {
                animate { self.miniView.frame = self.miniViewFrame }
            }
        default:
            break
        }
    }
    
    func animate(code: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            code()
        })
    }
}
