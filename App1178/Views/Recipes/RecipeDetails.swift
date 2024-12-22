import SwiftUI

struct RecipeDetails: View {
    
    //@State var showActionSheet: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var source: Source
    @State var recipe: Recipe
    @Binding var showDeleteActionSheet: Bool
    @Binding var showPrepareActionSheet: Bool
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                ScrollView(.vertical) {
                    content
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            HStack(spacing: 10) {
                Button {
                    source.recipeForDelete = recipe
                    showDeleteActionSheet = true
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.labelPrimary)
                        .frame(width: 37, height: 37)
                        .background(Color.cYellow)
                        .clipShape(.rect(cornerRadius: 10))
                }
                Button {
                    source.recipeForPrepare = recipe
                    showPrepareActionSheet = true
                } label: {
                    Text("Prepare")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 37)
                        .background(Color.cYellow)
                        .clipShape(.rect(cornerRadius: 10))
                }
                Button {
                    recipe.isFavorite.toggle()
                    if source.recipeForPrepare != nil {
                        source.recipeForPrepare?.isFavorite = recipe.isFavorite
                    }
                } label: {
                    Image(systemName: recipe.isFavorite ? "star.fill" : "star")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.labelPrimary)
                        .frame(width: 37, height: 37)
                        .background(Color.cYellow)
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 101, trailing: 16))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
        }
        .onDisappear {
            if source.recipeForPrepare != nil {
//                recipe.currentTime = source.recipeForPrepare!.currentTime
//                recipe.state = source.recipeForPrepare!.state
//                source.recipeForPrepare = nil
                source.recipeForPrepare = nil
                //source.edit(recipe)
            } else {
                source.edit(recipe)
            } 
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Back")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.labelPrimary)
            }
            
            Text("Recipe")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.labelPrimary)
                .frame(maxWidth: .infinity)
            
            NavigationLink {
                EditRecipe(recipe: recipe, recipeBind: $recipe)
            } label: {
                Text("Edit")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.cPrimary)
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            VStack(spacing: 17) {
                setImage(recipe.image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 234)
                    .clipShape(.rect(cornerRadius: 10))
                    .clipped()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                    VStack(alignment: .leading, spacing: 6) {
                        cardLine(title: "Technique", name: recipe.technique)
                        cardLine(title: "Portions", name: recipe.portions)
                        cardLine(title: "Time", name: "\(recipe.time)")
                        cardLine(title: "Category", name: recipe.category)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Ingredients")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.labelPrimary)
                Text(recipe.ingredients)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.black.opacity(0.3))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Preparation")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.labelPrimary)
                Text(recipe.preparation)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.black.opacity(0.3))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
        }
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
    }
    
    private func cardLine(title: String, name: String) -> some View {
        HStack(spacing: 4) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.black.opacity(0.3))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("•")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.cPrimary)
            }
            .frame(width: 66)
            
            Text(name)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.black.opacity(0.3))
        }
    }
    
    private func setImage(_ data: Data) -> Image {
        guard let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
    }
}
//
//#Preview {
//    RecipeDetails(recipe: Recipe(uuid: UUID(), image: Data(), name: "Name", technique: "Tech", portions: "Portions", time: "Time", category: "Category", ingredients: "Ingredients122121221212121122121212112212122222232312313213123123131231231241242142152121\n12121212121212", preparation: "Preparation", state: 2, isFavorite: false))
//        .environmentObject(Source())
//}
