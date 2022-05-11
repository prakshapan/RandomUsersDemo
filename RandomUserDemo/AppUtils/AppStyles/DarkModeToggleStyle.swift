//
//  DarkModeToggleStyle.swift
//  RandomUserDemo
//
//  Created by Praks on 11/05/2022.
//

import SwiftUI
struct DarkModeToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Rectangle()
            .fill(configuration.isOn ? Color.tintColor : .toggleBackground)
            .animation(.easeInOut, value: 2)
            .frame(width: 60, height: 30)
            .cornerRadius(15)
            .overlay(
                setIconImage(for: configuration)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .toggleColor : .white)
                    .padding(.all, 8)
                    .offset(x: configuration.isOn ? 15 : -15, y: 0)
                    .animation(.easeInOut, value: 2)
            )
            .onTapGesture { configuration.isOn.toggle() }
    }
    
    func setIconImage(for configuration: Configuration) -> Image {
        configuration.isOn ? Image.sun : .moon
    }
}
