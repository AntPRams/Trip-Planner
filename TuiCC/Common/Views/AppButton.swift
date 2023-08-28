//
//  AppButton.swift
//  TuiCC
//
//  Created by António Ramos on 28/08/2023.
//

import SwiftUI

struct AppButton: View {
    
    var image: Image?
    var text: Text?
    var color: Color
    var action: (() -> Void)?
    
    init(image: Image? = nil,
         text: Text? = nil,
         color: Color = .accentColor,
         action: (() -> Void)? = nil
    ) {
        self.image = image
        self.text = text
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                image
                text
            }
        }
        .foregroundColor(color)
        .buttonStyle(.bordered)
    }
}

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton()
    }
}
