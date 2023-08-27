import SwiftUI

struct SearchField: View {
    
    @StateObject var viewModel: SearchFieldViewModel

    @FocusState private var isFocused: Bool
    @State private var showDropdown: Bool = false
    
    var body: some View {
        TextField(
            Localizable.searchCityTextViewPlaceholder,
            text: $viewModel.text,
            onEditingChanged: { isEditing in
                viewModel.isBeingEdited = isEditing
            })
        .focused($isFocused)
        .textFieldStyle(.roundedBorder)
        .padding(.all, 3)
        .overlay(alignment: .topLeading) {
            DropDownList(viewModel: viewModel)
        }
        .onChange(of: isFocused, perform: { _ in
            viewModel.shouldShowDropdown()
        })
        .onChange(of: viewModel.text) { newValue in
            viewModel.shouldShowDropdown()
        }
    }
}

//
//struct SearchField_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchField(viewModel: MainViewModel(), textFieldType: .destination)
//    }
//}
