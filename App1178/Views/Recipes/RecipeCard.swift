import SwiftUI

struct RecipeCard: View {
    
    @EnvironmentObject var source: Source
    let recipe: Recipe
    @Binding var showDeleteRecipe: Bool
    @Binding var showPrepareRecipe: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 17) {
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
                
                NavigationLink {
                    RecipeDetails(recipe: recipe, showDeleteActionSheet: $showDeleteRecipe, showPrepareActionSheet: $showPrepareRecipe)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.cYellow)
                        Text("Details")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.cYellow)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(alignment: .trailing, spacing: 8) {
                setImage(recipe.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 103, height: 99)
                    .clipped()
                    .clipShape(.rect(cornerRadius: 10))
                
                Image(systemName: recipe.isFavorite ? "star.fill" : "star")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.cPrimary)
                    .frame(width: 22, height: 22)
                    .onTapGesture {
                        source.toggleFavorite(recipe)
                    }
            }
        }
        .padding(EdgeInsets(top: 15, leading: 12, bottom: 15, trailing: 12))
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 9))
        .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
    }
    
    private func setImage(_ data: Data) -> Image {
        guard let image = UIImage(data: data) else {
            return Image(systemName: "camera.fill")
        }
        return Image(uiImage: image)
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
}

//#Preview {
//    RecipeCard(recipe: Recipe(uuid: UUID(), image: Data(), name: "name", technique: "tech", portions: "port", time: "time", category: "category", ingredients: "ingredients", preparation: "preparation", state: 2, isFavorite: false))
//        .padding()
//        .background(Color.black)
//        .environmentObject(Source())
//}
