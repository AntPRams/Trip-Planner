import SwiftUI

struct DropDownList: View {
    
    @ObservedObject var viewModel: SearchFieldViewModel
    @State private var scrollViewContentSize: CGSize = .zero
    
    var body: some View {
        if viewModel.showDropDown {
            ScrollView {
                Spacer()
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
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
                .background(
                    GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            withAnimation {
                                scrollViewContentSize = geo.size
                            }
                        }
                        return Color.clear
                    }
                )
            }
            .frame(height: scrollViewContentSize.height)
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
