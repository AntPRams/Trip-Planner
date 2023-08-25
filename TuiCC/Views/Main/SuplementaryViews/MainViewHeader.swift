//
//  MainViewHeader.swift
//  TuiCC
//
//  Created by António Ramos on 24/08/2023.
//

import SwiftUI

struct MainViewHeader: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchField(viewModel: viewModel)
        }
    }
}

struct SearchField: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var showDropdown: Bool = false
    
    var body: some View {
        TextField("Type origin", text: $viewModel.originText)
            .textFieldStyle(.roundedBorder)
            .onReceive(viewModel.$originText.debounce(
                for: .seconds(1),
                scheduler: DispatchQueue.main
            )) { value in
                withAnimation {
                    showDropdown = (value != String())
                    viewModel.cities.remove(at: 2)
                    print("do something \(value)")
                    
                }
            }
            .padding(.all, 12)
            .overlay(alignment: .topLeading) {
                DropDownList(
                    showDropdownList: $showDropdown,
                    list: $viewModel.cities,
                    selectedCity: $viewModel.originText
                )
            }
    }
}

struct DropDownList: View {
    
    @Binding var showDropdownList: Bool
    @Binding var list: [String]
    @Binding var selectedCity: String
    
    var body: some View {
        ZStack {
            if showDropdownList {
                VStack(alignment: .center) {
                    ForEach(list, id: \.self) { city in
                        CityRow(type: .origin, text: city)
                            .onTapGesture {
                                selectedCity = city
                                withAnimation {
                                    showDropdownList = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                        Divider()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                )
                .offset(y: 50)
            }
        }
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
    }
}

enum ConnectionType {
    case origin
    case destination
}

struct CityRow: View {
    
    var type: ConnectionType
    var text: String
    
    var body: some View {
        HStack {
            type == .origin ?
            Image.originPlaneImage :
            Image.destinationPlaneImage
            Text(text)
            Spacer()
        }
    }
}

extension Image {
    
    static let originPlaneImage = Image(systemName: "airplane.departure")
    static let destinationPlaneImage = Image(systemName: "airplane.arrival")
}
//
//#Preview {
//    MainViewHeader(originText: .constant("test1"))
//}
