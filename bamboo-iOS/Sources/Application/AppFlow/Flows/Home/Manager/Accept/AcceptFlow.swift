import UIKit

import RxFlow
import RxRelay

struct AcceptStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    
    var initialStep: Step {
        return BambooStep.AcceptIsRequired
    }
}

final class AcceptFlow : Flow{
    //MARK: - Properties
    var root: Presentable {
        return self.rootViewController
    }
    private let rootViewController = UINavigationController()
    let stepper: AcceptStepper = .init()

    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step.asBambooStep else {return .none}
        switch step{
        case .AcceptIsRequired :
            return coordinatorToAccept()
        default: return .none
        }
    }
}

//MARK: - Method
private extension AcceptFlow {
    func coordinatorToAccept() -> FlowContributors{
        let vc = AppDelegate.container.resolve(AcceptViewController.self)!
        self.rootViewController.setViewControllers([vc], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc,withNextStepper: vc.reactor!))
    }
}
