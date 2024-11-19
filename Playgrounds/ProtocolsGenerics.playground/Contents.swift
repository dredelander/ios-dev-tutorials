
enum Month {
    case jan
    case feb
    case mar
    case apr
    case may
    case jun
    case jul
    case aug
    case sep
    case oct
    case nov
    case dec
}

protocol Plantable {
    var plantMonth: Month { get}
    var plantingInstructions: String { get }
}

protocol Waterable {
    var inchesOfWater: Int {get}
    var wateringFrequency : String {get}
    var wateringInstructions: String {get}
}

protocol Harvestable {
    var harvestMonth: Month {get}
    var harvestingInstructions: String {get}
}

protocol Gardenable: Harvestable, Waterable, Plantable {
    
    func printGardeningTips()
}

extension Gardenable {
    func printGardeningTips(){
        print("Here are the gardening tips for your. Use caution, apply sunscreen and gire help")
    }
}

struct Kale : Gardenable {
    
    var harvestMonth: Month = .sep
    
    var harvestingInstructions = "Kale is best with other veggies, plant carefully"
    
    var inchesOfWater: Int = 60
    
    var wateringFrequency: String = "Every other day"
    
    var wateringInstructions = " Every 2 weeks"
    
    var plantMonth: Month = .oct
    
    var plantingInstructions = "Kale is best with other veggies, tail first"
    
}

func printTips<T: Gardenable>(for plants:[T]){
    
    for plant in plants {
        plant.printGardeningTips()
    }
}

let kale1 = [Kale()]

printTips(for: kale1)
