import SwiftUI

struct DropDownList: View {
    
    @ObservedObject var viewModel: SearchFieldViewModel
    @Binding var showDropdownList: Bool
    
    var body: some View {
        if showDropdownList {
            ScrollView {
                LazyVStack(alignment: .center) {
                    ForEach(viewModel.cities, id: \.self) { city in
                        CityRow(type: .origin, text: city)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.text = city
                                    showDropdownList = false
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                        Divider()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: CGFloat(viewModel.cities.count * 50))
            .frame(maxHeight: 250)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.white)
                    .shadow(radius: 4)
            )
            .offset(y: 40)
            .transition(
                .asymmetric(
                    insertion: .scale,
                    removal: .opacity
                )
            )
        }
    }
}


//struct DropDownList_Previews: PreviewProvider {
//    static var previews: some View {
//        DropDownList(
//            showDropdownList: .constant(true),
//            list: .constant(["a", "b", "c"]),
//            selectedCity: .constant("")
//        )
//        .previewLayout(.sizeThatFits)
//    }
//}
