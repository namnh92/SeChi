//
//  BaseBottomSheetVC.swift
//  VTMap_ODC
//
//  Created by waz on 12/25/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

enum BottomSheetState {
    case collapsed
    case expanded
//    case fullScreen
}

protocol HMBaseBottomSheetDelegate: class {
    func didMoveBottomSheet(y: CGFloat)
    func didCompletion(state: BottomSheetState)
}

class HMBaseBottomSheetVC: HMBaseVC {

    @IBOutlet weak var mainView: UIView!
    var scrollView: UIScrollView!
    @IBOutlet weak var topAreaView: UIView!
    
    // MARK: - Constants
    
    // MARK: - Variables
    weak var delegate: HMBaseBottomSheetDelegate?
    var collapsedHeight: CGFloat = 150
    var needScrollToTop: Bool = true
    var bottomSheetState: BottomSheetState = .collapsed {
        willSet {
            willChangeState(oldState: bottomSheetState, newState: newValue)
        }
        didSet {
            didChangeState(oldState: oldValue, newState: bottomSheetState)
        }
    }
    private var fullView: CGFloat {
        return HMSystemInfo.safeAreaInsetTop
    }
    var w: CGFloat = 0.0
    var h: CGFloat = 0.0
    var partialView: CGFloat {
//        switch bottomSheetState {
//        case .collapsed:
        if isFirstTime {
            isFirstTime = false
            if UIDevice.current.orientation.isLandscape {
                h = HMSystemInfo.screenWidth
                w = HMSystemInfo.screenHeight
            } else {
                w = HMSystemInfo.screenWidth
                h = HMSystemInfo.screenHeight
            }
            return HMSystemInfo.screenHeight  - HMSystemInfo.safeAreaInsetBottom - collapsedHeight
        } else {
            if UIDevice.current.orientation.isLandscape {
                return w - HMSystemInfo.safeAreaInsetBottom - collapsedHeight
            } else {
                return h  - HMSystemInfo.safeAreaInsetBottom - collapsedHeight
            }
        }
//        case .expanded:
//            return ScreenUtils.screenHeight  - ScreenUtils.safeAreaInsetBottom - ScreenUtils.screenHeight*2/3
//        case .fullScreen:
//            return ScreenUtils.safeAreaInsetTop
//        }
    }
    private var numItemHightLight: Int = 0
    private var isFirstTime: Bool = true
    
    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Setup views
    func setupTitle() {
    }
    
    override func setupView() {
        if let topAreaView = topAreaView {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
            tapGesture.delegate = self
            topAreaView.addGestureRecognizer(tapGesture)
        }
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        setupTitle()
    }
    
    func showView(state: BottomSheetState) {
        if state == .expanded {
            delegate?.didCompletion(state: state)
        }
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            guard let sSelf = self else { return }
            let frame = sSelf.view.frame
            switch state {
            case .collapsed:
                sSelf.view.frame = CGRect(x: 0, y: sSelf.partialView, width: frame.width, height: frame.height)
            case .expanded:
                sSelf.view.frame = CGRect(x: 0, y: sSelf.fullView, width: frame.width, height: frame.height)
//            case .fullScreen:
//                sSelf.view.frame = CGRect(x: 0, y: sSelf.partialView, width: frame.width, height: frame.height)
            }
        }) { [weak self] isCompleted in
            guard let sSelf = self else { return }
            if state == .collapsed {
                sSelf.delegate?.didCompletion(state: state)
            }
        }
    }
    
    // MARK: - Actions
    func willChangeState(oldState: BottomSheetState, newState: BottomSheetState) {
        
    }
    
    func didChangeState(oldState: BottomSheetState, newState: BottomSheetState) {
        
    }
    // MARK: - Management datas
    
    // MARK: - Private methods
    @objc private func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: { [weak self] in
                guard let sSelf = self else { return }
                if sSelf.needScrollToTop {
                    sSelf.scrollView.setContentOffset(CGPoint.zero, animated: false)
                }
                let frame = sSelf.view.frame
                switch sSelf.bottomSheetState {
//                case .fullScreen:
//                    sSelf.view.frame = CGRect(x: 0, y: sSelf.fullView, width: frame.width, height: frame.height)
//                    sSelf.bottomSheetState = .collapsed
                case .expanded:
                    sSelf.view.frame = CGRect(x: 0, y: sSelf.partialView, width: frame.width, height: frame.height)
                    sSelf.bottomSheetState = .collapsed
                case .collapsed:
                    sSelf.view.frame = CGRect(x: 0, y: sSelf.fullView, width: frame.width, height: frame.height)
                    sSelf.bottomSheetState = .expanded
                }
                }, completion: { [weak self] _ in
                    guard let sSelf = self else { return }
                    switch sSelf.bottomSheetState {
//                    case .fullScreen:
//                        sSelf.scrollView.isScrollEnabled = true
                    case .expanded:
                        sSelf.scrollView.isScrollEnabled = true
                    case .collapsed:
                        sSelf.scrollView.isScrollEnabled = false
                    }
            })
        }
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= partialView) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        delegate?.didMoveBottomSheet(y: y + translation.y)
        switch recognizer.state {
        case .changed:
            break
        case .ended:
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : ((duration <= 0) ? 0.3 : duration)
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: { [weak self] in
                guard let sSelf = self else { return }
                if sSelf.needScrollToTop {
                    sSelf.scrollView.setContentOffset(CGPoint.zero, animated: false)
                }
                let frame = sSelf.view.frame
                if  velocity.y >= 0 {
//                    switch sSelf.bottomSheetState {
//                    case .fullScreen:
//                        sSelf.bottomSheetState = .expanded
//                        sSelf.view.frame = CGRect(x: 0, y: sSelf.partialView, width: frame.width, height: frame.height)
//                    default:
                        sSelf.bottomSheetState = .collapsed
                        sSelf.view.frame = CGRect(x: 0, y: sSelf.partialView, width: frame.width, height: frame.height)
//                    }
                } else {
//                    switch sSelf.bottomSheetState {
//                    case .collapsed:
//                        sSelf.bottomSheetState = .expanded
//                        sSelf.view.frame = CGRect(x: 0, y: sSelf.partialView, width: frame.width, height: frame.height)
//                    default:
//                        sSelf.bottomSheetState = .fullScreen
                        sSelf.view.frame = CGRect(x: 0, y: sSelf.fullView, width: frame.width, height: frame.height)
//                    }
                }
                
                }, completion: { [weak self] _ in
                    guard let sSelf = self else { return }
                    if ( velocity.y < 0 ) {
                        sSelf.scrollView.isScrollEnabled = true
                        sSelf.delegate?.didCompletion(state: .expanded)
                    }
                    
                    if velocity.y >= 0 {
                        sSelf.delegate?.didCompletion(state: .collapsed)
                    }
            })
        default:
            break
        }
    }
}

extension HMBaseBottomSheetVC: UIGestureRecognizerDelegate {
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer {
            let direction = gesture.velocity(in: view).y
            
            let y = view.frame.minY
            if (y == fullView && scrollView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
                scrollView.isScrollEnabled = false
            } else {
                scrollView.isScrollEnabled = true
            }
            
            return false
        }
        
        if gestureRecognizer is UITapGestureRecognizer {
            return false
        }
        
        return true
    }
    
}
