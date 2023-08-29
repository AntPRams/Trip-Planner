import SwiftUI

struct SearchField: View {
    
    @StateObject var viewModel: SearchFieldViewModel
    
    @FocusState private var isFocused: Bool
    @State private var showDropdown: Bool = false
    
    var body: some View {
        TextField(viewModel.connectionType.placeholder, text: $viewModel.text)
            .textFieldStyle(.roundedBorder)
            .padding(2)
            .focused($isFocused)
            .onChange(of: isFocused, perform: { isFocused in
                viewModel.isBeingEdited = isFocused
                viewModel.shouldShowDropdown()
            })
            .onChange(of: viewModel.text) { newValue in
                viewModel.shouldShowDropdown()
            }
            .overlay(alignment: .topLeading) {
                DropDownList(viewModel: viewModel)
            }
    }
}


struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(viewModel: SearchFieldViewModel(connectionType: .destination))
    }
}
