import SwiftUI

struct Recipes: View {
    
    @EnvironmentObject var source: Source
    @Binding var showDeleteRecipe: Bool
    @Binding var showPrepareRecipe: Bool
    @State var selection = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("mainBackground")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    header
                    category
                    segmented
                    
                    switch selection {
                    case 0: cookedCards
                    case 1: inProgressCards
                    case 2: notCookedCards
                    default: notCookedCards
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                NavigationLink {
                    AddRecipe()
                } label: {
                    Text("Add recipes")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 37)
                        .background(Color.cYellow)
                        .clipShape(.rect(cornerRadius: 10))
                }
                .shadow(color: .yellowShadow.opacity(0.5), radius: 10)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 91, trailing: 16))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder private var cookedCards: some View {
        if source.recipes.filter({$0.state == 0}).isEmpty {
            empty
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(source.selectedCategory != "All" ? source.recipes.filter({$0.state == 0}).filter({$0.category == source.selectedCategory}) : source.recipes.filter({$0.state == 0}), id: \.self) { recipe in
                        RecipeCard(recipe: recipe, showDeleteRecipe: $showDeleteRecipe, showPrepareRecipe: $showPrepareRecipe)
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 150, trailing: 16))
            }
        }
    }
    
    @ViewBuilder private var inProgressCards: some View {
        if source.recipes.filter({$0.state == 1}).isEmpty {
            empty
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(source.selectedCategory != "All" ? source.recipes.filter({$0.state == 1}).filter({$0.category == source.selectedCategory}) : source.recipes.filter({$0.state == 1}), id: \.self) { recipe in
                        RecipeCard(recipe: recipe, showDeleteRecipe: $showDeleteRecipe, showPrepareRecipe: $showPrepareRecipe)
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 150, trailing: 16))
            }
        }
    }
    
    @ViewBuilder private var notCookedCards: some View {
        if source.recipes.filter({$0.state == 2}).isEmpty {
            empty
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(source.selectedCategory != "All" ? source.recipes.filter({$0.state == 2}).filter({$0.category == source.selectedCategory}) : source.recipes.filter({$0.state == 2}), id: \.self) { recipe in
                        RecipeCard(recipe: recipe, showDeleteRecipe: $showDeleteRecipe, showPrepareRecipe: $showPrepareRecipe)
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 150, trailing: 16))
            }
        }
    }
    
    private var header: some View {
        Text("Recipes")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.labelPrimary)
            .frame(maxWidth: .infinity)
        .frame(height: 44)
        .overlay(
            HStack(spacing: 0) {
                NavigationLink {
                    FavoriteRecipes(showDeleteRecipe: $showDeleteRecipe, showPrepareRecipe: $showPrepareRecipe)
                } label: {
                    Image(systemName: "star.fill")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.cYellow)
                        .frame(width: 22, height: 22)
                }
            }
            , alignment: .leading
        )
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder private var category: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                categoryCard("All", selected: source.selectedCategory == "All").onTapGesture {
                    source.selectedCategory = "All"
                }
                cookedCategories
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 32)
        .padding(.top, 20)
    }

    
    private var cookedCategories: some View {
        ForEach(configureCategoriesFor(state: 0), id: \.self) { category in
            categoryCard(category, selected: source.selectedCategory == category)
                .onTapGesture {
                    print("0")
                    source.selectedCategory = category
                }
        }
    }
//    private var inProgressCategories: some View {
//        ForEach(configureCategoriesFor(state: 1), id: \.self) { category in
//            categoryCard(category, selected: source.inProgressSelectedCategory == category)
//                .onTapGesture {
//                    print("1")
//                    source.inProgressSelectedCategory = category
//                }
//        }
//    }
//    private var notCookedCategories: some View {
//        ForEach(configureCategoriesFor(state: 2), id: \.self) { category in
//            categoryCard(category, selected: source.notCookedSelectedCategory == category)
//                .onTapGesture {
//                    print("Lol")
//                    source.notCookedSelectedCategory = category
//                }
//        }
//    }
//    
    private func categoryCard(_ category: String, selected: Bool) -> some View {
        Text(category)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.labelPrimary)
            .padding(.horizontal, 12)
            .frame(height: 30)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(!selected ? Color.labelPrimary : Color.clear, lineWidth: 1)
            )
            .background(selected ? Color.cYellow : Color.clear)
            .clipShape(.rect(cornerRadius: 6))
    }
    
    private func configureCategoriesFor(state: Int) -> Array<String> {
        var array: Array<String> = []
        source.recipes.forEach { recipe in
            if !array.contains(recipe.category) {
                array.append(recipe.category)
            }
        }
        return array
    }
    
    private var segmented: some View {
        Picker("", selection: $selection) {
            Text("Cooked").tag(0)
            Text("In progress").tag(1)
            Text("Not cooked").tag(2)
        }
        .pickerStyle(.segmented)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
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
//    Recipes()
//        .environmentObject(Source())
//}
