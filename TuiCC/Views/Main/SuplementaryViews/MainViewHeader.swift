import SwiftUI


struct MainViewHeader: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SearchField(viewModel: viewModel, textFieldType: .origin)
                .zIndex(3)
            SearchField(viewModel: viewModel, textFieldType: .destination)
                .zIndex(2)
        }
    }
}

struct SearchField: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var showDropdown: Bool = false
    
    var textFieldType: ConnectionType
    
    var body: some View {
        TextField("Type origin", text: textFieldType == .origin ? $viewModel.originText : $viewModel.destinationText)
            .textFieldStyle(.roundedBorder)
            .onReceive(
                (textFieldType == .origin ? viewModel.$originText : viewModel.$destinationText).debounce(
                for: .seconds(1),
                scheduler: DispatchQueue.main
            )) { value in
                withAnimation {
                    showDropdown = (value != String())
                }
            }
            .padding(.all, 3)
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
//
//struct MainViewHeader_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
