import SwiftUI

final class Source: ObservableObject {
    
    @Published var selectedCategory: String = "All"
    
    var skinDescription = ""
    var show = false
    
    let dataManager = DataManager()
    
    @Published var recipes: Array<Recipe> = []
    @Published var categories: Array<String> = []
    @Published var achievements: Array<Achievement> = [
        Achievement(title: "Sugar Flowers", description: "Master the technique of making realistic flowers from sugar paste.", image: "SugarFlowers", progress: 0),
        Achievement(title: "Themed Desserts", description: "Create desserts that match a certain theme or holiday.", image: "ThemedDesserts", progress: 0),
        Achievement(title: "Making the Chocolate Glaze", description: "Learn the technique of making a smooth and shiny chocolate glaze.", image: "MakingTheChocolateGlaze", progress: 0),
        Achievement(title: "Making Your First Cake", description: "Bake a simple cake using a basic recipe.", image: "MakingYourFirstCake", progress: 0),
        Achievement(title: "Making the Meringue", description: "Make a light and airy meringue using egg whites and sugar.", image: "MakingTheMeringue", progress: 0),
        Achievement(title: "Filled Cookies", description: "Come up with your own cookie recipe with an unusual filling.", image: "FilledCookies", progress: 0),
        Achievement(title: "Decorating the Buttercream", description: "Learn how to decorate a cake with buttercream roses or other designs.", image: "DecoratingtheButtercream", progress: 0),
        Achievement(title: "Using Food Coloring", description: "Experiment with food coloring to create bright and original desserts.", image: "UsingFoodColoring", progress: 0),
        Achievement(title: "Making a Layered Cake", description: "Assemble a cake from several layers of sponge cake layered with buttercream.", image: "MakingaLayeredCake", progress: 0),
        Achievement(title: "Baking the Macarons", description: "Make French macarons in different flavors and colors.", image: "BakingtheMacarons", progress: 0)
    ]
    
    @Published var currentAchievementIndex = 0
    var recipeForDelete: Recipe?
    var recipeForPrepare: Recipe?
    
    func load(completion: () -> Void) {
        
        if let recipes = try? dataManager.fetchRecipes() {
            self.recipes = recipes
            recipes.forEach { recipe in
                if !categories.contains(recipe.category) {
                    categories.append(recipe.category)
                }
            }
        }
        
        if let cds = try? dataManager.fetchCurrentAchievementIndex() {
            currentAchievementIndex = cds
        }
        
        if let acds = try? dataManager.fetchAchievements() {
            acds.forEach { (str, prog) in
                print(str)
                print(prog)
                if let index = achievements.firstIndex(where: {$0.title == str}) {
                    achievements[index].progress = prog
                }
            }
        }
        
        completion()
    }
    
    func save(_ recipe: Recipe) {
        recipes.append(recipe)
        if !categories.contains(recipe.category) {
            categories.append(recipe.category)
        }
        dataManager.save(recipe)
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        guard let index = recipes.firstIndex(where: {$0.uuid == recipe.uuid}) else { return }
        recipes[index].isFavorite.toggle()
        dataManager.edit(recipes[index])
    }
    
    func setRecipeFavorite(_ recipe: Recipe) {
        guard let index = recipes.firstIndex(where: {$0.uuid == recipe.uuid}) else { return }
        recipes[index].isFavorite = recipe.isFavorite
        dataManager.edit(recipes[index])
    }
    
    func edit(_ recipe: Recipe) {
        guard let index = recipes.firstIndex(where: {$0.uuid == recipe.uuid}) else { return }
        recipes[index] = recipe
        dataManager.edit(recipes[index])
    }
    
    func makeCurrentAchievement(by title: String) {
        guard let index = achievements.firstIndex(where: {$0.title == title}) else { return }
        currentAchievementIndex = index
        dataManager.saveOrEditCurrentAchievementIndex(index)
    }
    
    func remove(_ recipe: Recipe) {
        guard let index = recipes.firstIndex(where: {$0.uuid == recipe.uuid}) else { return }
        recipes.remove(at: index)
        try? dataManager.remove(recipe)
    }
    
    func prepareRecipeStop() {
        guard let recipeForPrepare = recipeForPrepare else { return }
        guard let index = recipes.firstIndex(where: {$0.uuid == recipeForPrepare.uuid}) else { return }
        recipes[index] = recipeForPrepare
        recipes[index].state = 1
        dataManager.edit(recipes[index])
    }
    
    func prepareRecipeCancel() {
        guard let recipeForPrepare = recipeForPrepare else { return }
        guard let index = recipes.firstIndex(where: {$0.uuid == recipeForPrepare.uuid}) else { return }
        recipes[index] = recipeForPrepare
        recipes[index].state = 2
        recipes[index].currentTime = recipes[index].time * 60
        dataManager.edit(recipes[index])
    }
    
    func finishPrepareRecipe() {
        guard let recipeForPrepare = recipeForPrepare else { return }
        guard let index = recipes.firstIndex(where: {$0.uuid == recipeForPrepare.uuid}) else { return }
        recipes[index] = recipeForPrepare
        recipes[index].state = 0
        dataManager.edit(recipes[index])
    }
}
