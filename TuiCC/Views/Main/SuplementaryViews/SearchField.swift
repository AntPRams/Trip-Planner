import SwiftUI

struct SearchField: View {
    
    @StateObject var viewModel: SearchFieldViewModel
    @State private var showDropdown: Bool = false
    
    var body: some View {
        TextField(
            Localizable.searchCityTextViewPlaceholder,
            text: $viewModel.text,
            onEditingChanged: { isEditing in
                viewModel.isBeingEdited = isEditing
            })
        .onChange(of: viewModel.text, perform: { newValue in
            withAnimation {
                viewModel.shouldShowDropdown()
            }
        })
        .textFieldStyle(.roundedBorder)
        .padding(.all, 3)
        .overlay(alignment: .topLeading) {
            DropDownList(viewModel: viewModel)
        }
    }
}
//
//struct SearchField_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchField(viewModel: MainViewModel(), textFieldType: .destination)
//    }
//}
