import SwiftUI

struct AddRecipe: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var source: Source
    
    @State var image: Data?
    @State var name = ""
    @State var technique = ""
    @State var portions = ""
    @State var time = ""
    @State var category = ""
    @State var ingredients = ""
    @State var preparation = ""
    
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        RecipeImageView(imageData: $image)
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
                    .padding(EdgeInsets(top: 20, leading: 16, bottom: 90, trailing: 16))
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
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
            
            Text("Add recipes")
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
        source.save(Recipe(uuid: UUID(), image: image!, name: name, technique: technique, portions: portions, time: time, category: category, ingredients: ingredients, preparation: preparation, state: 2, isFavorite: false, currentTime: time * 60)) //2 not cooked
    }
}

#Preview {
    AddRecipe()
        .environmentObject(Source())
}
