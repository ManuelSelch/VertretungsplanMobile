import Foundation
import Combine
import Redux
import PulseLogHandler
import Log

import CommonServices

struct MonitorMiddleware {
    
    func handle(_ state: AppFeature.State, _ action: AppFeature.Action) -> AnyPublisher<AppFeature.Action, Never> {
        if(UserDefaultService.isLocalLog) {
            let actionFormatted = Log.LogMiddleware.formatAction(action)
            LoggerStore.shared.storeMessage(label: "Action", level: .debug, message: actionFormatted)
        }
        return .none
    }
}

