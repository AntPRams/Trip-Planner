import SwiftUI

struct DropDownList: View {
    
    @ObservedObject var viewModel: SearchFieldViewModel
    @State private var scrollViewContentSize: CGSize = .zero
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if viewModel.showDropDown {
            ScrollView {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    ForEach(viewModel.cities, id: \.self) { city in
                        CityRow(type: viewModel.connectionType, text: city)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.text = city
                                }
                            }
                        Divider()
                    }
                }
                .background(
                    GeometryReader { geo -> Color in
                        DispatchQueue.main.async {
                            scrollViewContentSize = geo.size
                        }
                        return Color.clear
                    }
                )
            }
            .frame(height: scrollViewContentSize.height)
            .modifier(ViewBackground())
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


struct DropDownList_Previews: PreviewProvider {
    static var previews: some View {
        DropDownList(viewModel: SearchFieldViewModel(connectionType: .destination))
        .previewLayout(.sizeThatFits)
    }
}
