//
//  GameplaySceneInteractions.swift
//  Robotak
//
//  Created by Yauheni Lychkouski on 7/20/19.
//  Copyright © 2019 Yauheni Lychkouski. All rights reserved.
//

import Foundation

class GameplaySceneInteractions {
    enum State {
        case initial
        case playerMove
        case turning
        case applyBonuses
        case fight
    }

    enum Event {
        case onInitialAnimationFinished
        case onTrunButton
        case onTurnCompleted
        case onBonusesApplied
        case onFightFinished
    }

    let stateMachine = StateMachine<State, Event>()

    init() {
        stateMachine.setTransition(from: .initial, to: .playerMove, on: .onInitialAnimationFinished)
        stateMachine.setTransition(from: .playerMove, to: .turning, on: .onTrunButton)
        stateMachine.setTransition(from: .turning, to: .applyBonuses, on: .onTurnCompleted)
        stateMachine.setTransition(from: .applyBonuses, to: .fight, on: .onBonusesApplied)
        stateMachine.setTransition(from: .fight, to: .playerMove, on: .onFightFinished)

        stateMachine.setHandler(for: .initial) { [weak stateMachine] in
        print("initial state handler")
        stateMachine?.fire(.onInitialAnimationFinished)
        }

        stateMachine.setHandler(for: .playerMove) {
        print("playerMove state handler")
        }

        stateMachine.setHandler(for: .turning) {
        print("turning state handler")
        }

        stateMachine.setHandler(for: .applyBonuses) {
        print("applyBonuses state handler")
        }

        stateMachine.setHandler(for: .fight) {
        print("fight state handler")
        }

        stateMachine.start(with: .initial)
    }
}
