//
//  AlertParameters.swift
//  RandomUserDemo
//
//  Created by Praks on 10/05/2022.
//

import Foundation
struct AlertParameters: Identifiable {
    var message: String
    var id = UUID()
    var primaryButtonTitle = "Ok"
    var secondaryButtonTitle: String?

    var primaryAction: () -> () = { }
    var secondaryAction: () -> () = { }
}
