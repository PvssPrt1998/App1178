import Foundation

final class DataManager {
    private let modelName = "DataModel"
    
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
    func saveOrEditCurrentAchievementIndex(_ index: Int) {
        do {
            if let indexCD = try coreDataStack.managedContext.fetch(CurrentAchievementIndex.fetchRequest()).first {
                indexCD.index = Int32(index)
            } else {
                let indexCD = CurrentAchievementIndex(context: coreDataStack.managedContext)
                indexCD.index = Int32(index)
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchCurrentAchievementIndex() throws -> Int? {
        guard let index = try coreDataStack.managedContext.fetch(CurrentAchievementIndex.fetchRequest()).first?.index else { return nil}
        return Int(index)
    }
    
    func saveOrEditAchievement(_ ach: Achievement) {
        do {
            let achievementsCD = try coreDataStack.managedContext.fetch(AchievementCD.fetchRequest())
            var founded = false
            achievementsCD.forEach { acd in
                if acd.title == ach.title {
                    founded = true
                    acd.title = ach.title
                    acd.progress = ach.progress
                }
            }
            if !founded {
                let acd = AchievementCD(context: coreDataStack.managedContext)
                acd.title = ach.title
                acd.progress = ach.progress
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchAchievements() throws -> Array<(String, Double)> {
        var array: Array<(String, Double)> = []
        let asCD = try coreDataStack.managedContext.fetch(AchievementCD.fetchRequest())
        asCD.forEach { acd in
            array.append((acd.title,acd.progress))
        }
        return array
    }
    
    func save(_ recipe: Recipe) {
        let recipeCD = RecipeCD(context: coreDataStack.managedContext)
        recipeCD.uuid = recipe.uuid
        recipeCD.name = recipe.name
        recipeCD.image = recipe.image
        recipeCD.category = recipe.category
        recipeCD.portions = recipe.portions
        recipeCD.time = Int32(recipe.time)
        recipeCD.currentTime = Int32(recipe.currentTime)
        recipeCD.ingredients = recipe.ingredients
        recipeCD.preparations = recipe.preparation
        recipeCD.technique = recipe.technique
        recipeCD.isFavorite = recipe.isFavorite
        recipeCD.state = Int32(recipe.state)
        
        coreDataStack.saveContext()
    }
    
    func fetchRecipes() throws -> Array<Recipe> {
        var array: Array<Recipe> = []
        let recipesCD = try coreDataStack.managedContext.fetch(RecipeCD.fetchRequest())
        recipesCD.forEach { recipeCD in
            array.append(Recipe(uuid: recipeCD.uuid, image: recipeCD.image, name: recipeCD.name, technique: recipeCD.technique, portions: recipeCD.portions, time: Int(recipeCD.time), category: recipeCD.category, ingredients: recipeCD.ingredients, preparation: recipeCD.preparations, state: Int(recipeCD.state), isFavorite: recipeCD.isFavorite, currentTime: Int(recipeCD.currentTime)))
        }
        return array
    }
    
    func edit(_ recipe: Recipe) {
        do {
            let recipesCD = try coreDataStack.managedContext.fetch(RecipeCD.fetchRequest())
            recipesCD.forEach { recipeCD in
                if recipeCD.uuid == recipe.uuid {
                    recipeCD.name = recipe.name
                    recipeCD.image = recipe.image
                    recipeCD.category = recipe.category
                    recipeCD.portions = recipe.portions
                    recipeCD.time = Int32(recipe.time)
                    recipeCD.currentTime = Int32(recipe.currentTime)
                    recipeCD.ingredients = recipe.ingredients
                    recipeCD.preparations = recipe.preparation
                    recipeCD.technique = recipe.technique
                    recipeCD.isFavorite = recipe.isFavorite
                    recipeCD.state = Int32(recipe.state)
                }
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func remove(_ recipe: Recipe) throws {
        let recipesCD = try coreDataStack.managedContext.fetch(RecipeCD.fetchRequest())
        guard let recipeCD = recipesCD.first(where: {$0.uuid == recipe.uuid }) else { return }
        coreDataStack.managedContext.delete(recipeCD)
        coreDataStack.saveContext()
    }
}
