import SwiftUI

struct SearchField: View {
    
    @StateObject var viewModel: SearchFieldViewModel
    @State private var showDropdown: Bool = false
    
    var body: some View {
        TextField("Type origin", text: $viewModel.text, onEditingChanged: { isEditing in
           showDropdown = isEditing && viewModel.cities.isNotEmpty
        })
            .textFieldStyle(.roundedBorder)
            .onChange(of: viewModel.text, perform: { newValue in
                withAnimation {
                    showDropdown = newValue != String() && !viewModel.cities.contains(newValue)
                }
            })
            .padding(.all, 3)
            .overlay(alignment: .topLeading) {
                DropDownList(viewModel: viewModel, showDropdownList: $showDropdown)
            }
    }
}
//
//struct SearchField_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchField(viewModel: MainViewModel(), textFieldType: .destination)
//    }
//}
