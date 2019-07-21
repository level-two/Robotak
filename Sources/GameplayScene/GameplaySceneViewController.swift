//
//  GameplaySceneView.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import RxSwift
import RxCocoa

class GameplaySceneViewController: UIViewController {
    public let onTurnButton = PublishSubject<Void>()

    public func setupDependencies() {
        self.presenter = GameplayScenePresenter(self)
        self.interactions = GameplaySceneInteractions(presenter)
    }

    override func viewDidLoad() {
        turnButton.rx.tap.bind(to: onTurnButton).disposed(by: disposeBag)
        setupDependencies() // FIXME: Should be called by the fabric
    }

    public func enableBonusSwitchButtons() {

    }

    public func disableBonusSwitchButtons() {

    }

    public func enableTurnButton() {
        turnButton.isEnabled = true
    }

    public func disableTurnButton() {
        turnButton.isEnabled = false
    }

    public func shot(from robot0: RobotId, to robot1: RobotId) -> Promise<Void> {
        let robot0Center = robotView(for: robot0).frame.center
        let robot1Center = robotView(for: robot1).frame.center

        let shotFrame = CGRect(center: robot0Center, size: .init(width: 10, height: 10))
        let shot = UIView(frame: shotFrame)
        shot.layer.cornerRadius = shotFrame.width/2
        shot.backgroundColor = .green

        self.view.addSubview(shot)

        return .init() { seal in
            UIView.animate(withDuration: 2, animations: {
                UIView.setAnimationCurve(.linear)
                shot.frame = .init(center: robot1Center, size: shot.frame.size)
            }, completion: { _ in
                shot.removeFromSuperview()
                seal.fulfill(())
            })
        }
    }

    public func movementAnimation(robotId: RobotId) -> Promise<Void> {
        let robot = robotView(for: robotId)
        let origTransform = robot.transform

        return .init() { seal in
            UIView.animate(withDuration: 0.5, animations: {
                robot.transform = origTransform.scaledBy(x: 1.0, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    robot.transform = origTransform
                }, completion: { _ in
                    seal.fulfill(())
                })
            })
        }
    }

    @IBOutlet var robotLeftBig: UIImageView!
    @IBOutlet var robotLeftSmall: UIImageView!
    @IBOutlet var robotRightBig: UIImageView!
    @IBOutlet var robotRightSmall: UIImageView!
    @IBOutlet var turnButton: UIButton!

    private var presenter: GameplayScenePresenter!
    private var interactions: GameplaySceneInteractions!
    private let disposeBag = DisposeBag()
}

extension GameplaySceneViewController {
    func robotView(for id: RobotId) -> UIView {
        switch id {
        case .robotLeftBig:
            return robotLeftBig
        case .robotLeftSmall:
            return robotLeftSmall
        case .robotRightBig:
            return robotRightBig
        case .robotRightSmall:
            return robotRightSmall
        }
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width/2,
                  y: center.y - size.height/2,
                  width: size.width,
                  height: size.height)
    }

    var center: CGPoint {
        return .init(x: midX, y: midY)
    }
}
