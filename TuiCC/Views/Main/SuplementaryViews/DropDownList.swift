import SwiftUI

struct DropDownList: View {
    
    @ObservedObject var viewModel: SearchFieldViewModel
    
    var body: some View {
        if viewModel.showDropDown {
            ScrollView {
                LazyVStack {
                    Spacer()
                    ForEach(viewModel.cities, id: \.self) { city in
                        CityRow(type: .origin, text: city)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.text = city
                                }
                            }
                            .frame(maxWidth: .infinity)
                        Divider()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .frame(height: CGFloat(viewModel.cities.count * 52))
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
