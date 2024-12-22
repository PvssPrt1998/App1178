import SwiftUI

struct FavoriteRecipes: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var source: Source
    @Binding var showDeleteRecipe: Bool
    @Binding var showPrepareRecipe: Bool
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                if source.recipes.filter({$0.isFavorite}).isEmpty {
                    empty
                } else {
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 16) {
                            ForEach(source.recipes.filter({$0.isFavorite}), id: \.self) { recipe in
                                RecipeCard(recipe: recipe, showDeleteRecipe: $showDeleteRecipe, showPrepareRecipe: $showPrepareRecipe)
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 16, bottom: 90, trailing: 16))
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        Text("Favorites")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.labelPrimary)
            .frame(maxWidth: .infinity)
        .frame(height: 44)
        .overlay(
            HStack(spacing: 0) {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Back")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.labelPrimary)
                }
            }
            , alignment: .leading
        )
        .padding(.horizontal, 16)
    }
    
    private var empty: some View {
        VStack(spacing: 22) {
            Image("oven")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 42)
            VStack(spacing: 8) {
                Text("Empty")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.labelPrimary)
                Text("No recipes added")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.labelPrimary)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

//#Preview {
//    FavoriteRecipes()
//        .environmentObject(Source())
//}
