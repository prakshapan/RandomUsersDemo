//
//  AppAlertModifier.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import SwiftUI

struct AppAlertModifier: ViewModifier {
    @Binding var appAlert: AlertParameters?

    func body(content: Content) -> some View {
        ZStack { content }
            .alert(item: $appAlert) { alert in
                if let secondaryTitle = alert.secondaryButtonTitle {
                    return Alert(title: Text(""),
                        message: Text(alert.message),
                        primaryButton: Alert.Button.default(Text(alert.primaryButtonTitle), action: alert.primaryAction),
                        secondaryButton: Alert.Button.default(Text(secondaryTitle), action: alert.secondaryAction))
                } else {
                    return Alert(title: Text(""),
                        message: Text(alert.message),
                        dismissButton: Alert.Button.default(Text(alert.primaryButtonTitle), action: alert.primaryAction))
                }

        }

    }
}

extension View {
    func appAlert(parameters: Binding<AlertParameters?>) -> some View {
        ModifiedContent(
            content: self,
            modifier: AppAlertModifier(appAlert: parameters)
        )
    }
}

