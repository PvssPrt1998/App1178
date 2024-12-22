import SwiftUI

struct EditRecipe: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var source: Source
    
    @Binding var recipe: Recipe
    
    let uuid: UUID
    @State var image: Data?
    @State var name: String
    @State var technique: String
    @State var portions: String
    @State var time: String
    @State var category: String
    @State var ingredients: String
    @State var preparation: String
    
    init(recipe: Recipe, recipeBind: Binding<Recipe>) {
        _recipe = recipeBind
        uuid = recipe.uuid
        image = recipe.image
        name = recipe.name
        technique = recipe.technique
        portions = recipe.portions
        time = "\(recipe.time)"
        category = recipe.category
        ingredients = recipe.ingredients
        preparation = recipe.preparation
    }
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        RecipeImageView(imageData: $image, image: setImage(image))
                        TextFieldCustom(text: $name, prefix: "Name", placeholder: "Enter")
                        TextFieldCustom(text: $technique, prefix: "Technique", placeholder: "Enter")
                        TextFieldCustom(text: $portions, prefix: "Portions", placeholder: "0")
                        TextFieldCustom(text: $time, prefix: "Time", placeholder: "0 min")
                        TextFieldCustom(text: $category, prefix: "Category", placeholder: "Enter")
                        
                        VStack(spacing: 12) {
                            Text("Ingredients")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.labelPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditorCustom(text: $ingredients, placeholder: "Enter")
                        }
                        VStack(spacing: 12) {
                            Text("Preparation")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.labelPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            TextEditorCustom(text: $preparation, placeholder: "Enter")
                        }
                    }
                    .padding(EdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16))
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
    private func setImage(_ data: Data?) -> Image? {
        guard let data = data, let image = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: image)
    }
    
    private var disabled: Bool {
        image == nil || name == "" || technique == "" || portions == "" || time == "" || category == "" || ingredients == "" || preparation == ""
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.labelPrimary)
            }
            
            Text("Edit recipes")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.labelPrimary)
                .frame(maxWidth: .infinity)
            
            Button {
                save()
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(disabled ? .labelTertiary.opacity(0.3) : .labelPrimary)
            }
            .disabled(disabled)
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
    }
    
    func save() {
        guard let time = Int(time.filter { Set("0123456789").contains($0) }) else { return }
//        source.edit(Recipe(uuid: uuid, image: image!, name: name, technique: technique, portions: portions, time: time, category: category, ingredients: ingredients, preparation: preparation, state: recipe.state, isFavorite: recipe.isFavorite)) //2 not cooked
        recipe = Recipe(uuid: uuid, image: image!, name: name, technique: technique, portions: portions, time: time, category: category, ingredients: ingredients, preparation: preparation, state: recipe.state, isFavorite: recipe.isFavorite, currentTime: time * 60)
    }
}

//#Preview {
//    EditRecipe(recipe: Recipe(uuid: UUID(), image: Data(), name: "Name", technique: "Tech", portions: "Portion", time: "Time", category: "Cat", ingredients: "Ingred", preparation: "Prepar", state: 0, isFavorite: false), recipeBind: <#Binding<Recipe>#>)
//        .environmentObject(Source())
//}
