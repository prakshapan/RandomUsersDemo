//
//  NumberOfResults.swift
//  RandomUserDemo
//
//  Created by Praks on 11/05/2022.
//

import Foundation
enum NumberOfResults: Int, CaseIterable, Identifiable {
    var id: NumberOfResults { self }
    case TEN = 10
    case TWENTY = 20
    case THIRTY = 30
}

