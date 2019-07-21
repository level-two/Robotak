//
//  GameplaySceneViewController.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift
import RxViewController

class GameplayScenePresenter {
    init(_ viewController: GameplaySceneViewController) {
        self.viewController = viewController

        assembleStateMachine()
        assembleStateMachineHandlers()
        assembleInteractions()
    }

    private weak var viewController: GameplaySceneViewController!
    private let stateMachine = StateMachine<State, Event>()
    private let disposeBag = DisposeBag()
}

extension GameplayScenePresenter {
    private enum State {
        case initial
        case playerMove
        case turning
        case applyBonuses
        case fight
    }

    private enum Event {
        case onInitialAnimationFinished
        case onTrunButton
        case onTurnCompleted
        case onBonusesApplied
        case onFightFinished
    }

    private func assembleStateMachine() {
        stateMachine.setTransition(from: .initial, to: .playerMove, on: .onInitialAnimationFinished)
        stateMachine.setTransition(from: .playerMove, to: .turning, on: .onTrunButton)
        stateMachine.setTransition(from: .turning, to: .applyBonuses, on: .onTurnCompleted)
        stateMachine.setTransition(from: .applyBonuses, to: .fight, on: .onBonusesApplied)
        stateMachine.setTransition(from: .fight, to: .playerMove, on: .onFightFinished)
    }

    private func assembleStateMachineHandlers() {
        stateMachine.setHandler(for: .initial) { [weak self] in
            guard let self = self else { return }

            self.viewController.disableBonusSwitchButtons()
            self.viewController.disableTurnButton()

            firstly {
                self.viewController.movementAnimation(robotId: .robotLeftBig)
            }.then {
                self.viewController.movementAnimation(robotId: .robotRightBig)
            }.done {
                self.stateMachine.fire(.onInitialAnimationFinished)
            }.cauterize()
        }

        stateMachine.setHandler(for: .playerMove) { [weak self] in
            guard let self = self else { return }

            self.viewController.enableBonusSwitchButtons()
            self.viewController.enableTurnButton()
        }

        stateMachine.setHandler(for: .turning) { [weak self] in
            guard let self = self else { return }

            self.viewController.disableBonusSwitchButtons()
            self.viewController.disableTurnButton()
            // TODO: Animation
            self.stateMachine.fire(.onTurnCompleted)
        }

        stateMachine.setHandler(for: .applyBonuses) { [weak self] in
            guard let self = self else { return }

            // TODO: apply bonuses - start separate state machine
            self.stateMachine.fire(.onBonusesApplied)
        }

        stateMachine.setHandler(for: .fight) { [weak self] in
            guard let self = self else { return }

            firstly {
                self.viewController.shot(from: .robotLeftBig, to: .robotRightBig)
            }.then {
                self.viewController.movementAnimation(robotId: .robotRightBig)
            }.then {
                self.viewController.shot(from: .robotRightSmall, to: .robotLeftBig)
            }.then {
                self.viewController.movementAnimation(robotId: .robotLeftBig)
            }.then {
                self.viewController.shot(from: .robotRightBig, to: .robotLeftSmall)
            }.then {
                self.viewController.movementAnimation(robotId: .robotLeftSmall)
            }.done {
                self.stateMachine.fire(.onFightFinished)
            }.cauterize()
        }
    }

    private func assembleInteractions() {
        viewController.rx.viewDidAppear.bind { [weak self] _ in
            self?.stateMachine.start(with: .initial)
        }

        viewController.onTurnButton.bind { [weak self] in
            self?.stateMachine.fire(.onTrunButton)
        }.disposed(by: disposeBag)
    }
}
