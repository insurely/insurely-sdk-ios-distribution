import SwiftUI
import InsurelySDK

/// Mirrors the quickstart in this repository's README, so this stops compiling
/// if the published API drifts from what customers are told to write.
///
/// Never run -- compiling it is the test. The identifiers are placeholders and
/// no collection is started.
@available(iOS 15.0, *)
struct InsurelyScreen: View {
    var body: some View {
        InsurelyView(
            context: InsurelyContext(environment: .test),
            configuration: InsurelyConfiguration(
                customerId: "smoke-test-customer-id",
                configName: "smoke-test-config-name"
            )
        )
        .onInsurelyResults { results in
            _ = results.data
        }
        .onInsurelyError { _ in }
        .onInsurelyEvent { _ in }
    }
}
