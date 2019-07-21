//
//  GameplaySceneInteractions.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation

class GameplaySceneInteractions {
    init(_ presenter: GameplayScenePresenter) {
        self.presenter = presenter

        assembleStateMachine()
        assembleStateMachineHandlers()
        assembleInteractions()

        stateMachine.start(with: .initial)
    }

    private weak var presenter: GameplayScenePresenter!
    private let stateMachine = StateMachine<State, Event>()
}

extension GameplaySceneInteractions {
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
        stateMachine.setHandler(for: .initial) { // [weak stateMachine] in
            print("initial state handler")
            //stateMachine?.fire(.onInitialAnimationFinished)
            // disable bonus type switch buttons
            // disable turn button
            // start initial animation
            // switch state when animation is finished
        }

        stateMachine.setHandler(for: .playerMove) {
            print("playerMove state handler")
            // enable bonus type switch buttons
            // enable turn button

            // turn button handler - switch state on button tap
        }

        stateMachine.setHandler(for: .turning) {
            print("turning state handler")
            // disable bonus type switch buttons
            // disable turn button

            // switch state on done
        }

        stateMachine.setHandler(for: .applyBonuses) {
            print("applyBonuses state handler")
            // apply bonuses - start separate state machine
            // when finished - switch to fight
        }

        stateMachine.setHandler(for: .fight) {
            print("fight state handler")
            // strikes and hurt
            // switch state when all animations are finished
        }
    }

    private func assembleInteractions() {

    }
}
