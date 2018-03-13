import Foundation
import Alamofire

class pokemon {
    private var _name:String!
    private var _pokedexID:Int!
    private var _pokemonURL:String!
    private var _description:String!
    private var _type:String!
    private var _height:String!
    private var _weight:String!
    private var _defence:String!
    private var _attack:String!
    private var _firstEvo:String!
    private var _secondEvo:String!
    private var _thirdEvo:String!
    var height:String {
        let heightTest = _height ?? ""
        return heightTest
    }
    var weight:String {
        let weightTest = _weight ?? ""
        return weightTest
    }
    var defence:String {
        let defenceTest = _defence ?? ""
        return defenceTest
    }
    var attack:String {
        let attackTest = _attack ?? ""
        return attackTest
    }
    var name:String {
        return _name
    }
    var pokedexID:Int {
        return _pokedexID
    }
    var type:String {
        let typeTest = _type ?? ""
        return typeTest
    }
    var description:String {
        let descriptionTest = _description ?? ""
        return descriptionTest
    }
    var firstEvo:String {
        let firstEvoTest = _firstEvo ?? ""
        return firstEvoTest
    }
    var secondEvo:String {
        let secondEvoTest = _secondEvo ?? ""
        return secondEvoTest
    }
    var thirdEvo:String {
        let thirdEvoTest = _thirdEvo ?? ""
        return thirdEvoTest
    }
    
    init(name:String, pokedexID:Int) {
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(pokedexID)"
    }
    
    //Start downloading, mark as complete when finished.
    func downloadPokemonDetails(completed: @escaping downloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
                if let weight = dict["weight"] as? Float {
                    self._weight = "\(weight/10) kg"
                    print(self._weight)
                }
                if let height = dict["height"] as? Float {
                    self._height = "\(height*10) cm"
                    print(self._height)
                }
                if let stats = dict["stats"] as? [Dictionary<String,AnyObject>] {
                    if let base_stat = stats[3]["base_stat"] as? Int {
                        self._defence = "\(base_stat)"
                        print(self._defence)
                    }
                    if let base_stat = stats[4]["base_stat"] as? Int {
                        self._attack = "\(base_stat)"
                        print(self._attack)
                    }
                }
                if let types = dict["types"] as? [Dictionary<String,AnyObject>] {
                    if let type = types[0]["type"] as? Dictionary<String,String> {
                        if let name = type["name"] {
                            self._type = name
                        }
                    }
                }
                if let species = dict["species"] as? Dictionary<String,String> {
                    if let url = species["url"] {
                        Alamofire.request(url).responseJSON{ (response) in
                            if let dict2 = response.value as? Dictionary<String, AnyObject> {
                                if let flavor_text_entries = dict2["flavor_text_entries"] as? [Dictionary<String, AnyObject>]
                                {
                                    if let flavor_text = flavor_text_entries[1]["flavor_text"] as? String {
                                        let new_flavor_text = flavor_text.replacingOccurrences(of: "\n", with: " ")
                                        self._description = new_flavor_text
                                    }
                                }
                                if let evolution_chain = dict2["evolution_chain"] as? Dictionary <String,String> {
                                    if let urlEvo = evolution_chain["url"] {
                                        Alamofire.request(urlEvo).responseJSON { (response2) in
                                            if let dict3 = response2.value as? Dictionary<String,AnyObject> {
                                                if let chain = dict3["chain"] as? Dictionary<String,AnyObject> {
                                                    if let species = chain["species"] as? Dictionary<String,String> {
                                                        if let url = species["url"] {
                                                            let newUrl = url.replacingOccurrences(of:"https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                            self._firstEvo = newUrl.replacingOccurrences(of: "/", with: "")
                                                            print(self._firstEvo)
                                                        }
                                                    }
                                                    if let evolves_to = chain["evolves_to"] as? [Dictionary<String,AnyObject>] {
                                                        print(evolves_to)
                                                        if evolves_to.count > 0 {
                                                        if let species2 = evolves_to[0]["species"] as? Dictionary<String,String>
                                                        {
                                                            if let url2 = species2["url"] {
                                                                let newUrl2 = url2.replacingOccurrences(of:"https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                                self._secondEvo = newUrl2.replacingOccurrences(of: "/", with: "")
                                                                print(self._secondEvo)
                                                            }
                                                        }
                                                            if let evolves_to2 = evolves_to[0]["evolves_to"] as? [Dictionary<String,AnyObject>] {
                                                                if evolves_to2.count > 0
                                                                {
                                                            if let species3 = evolves_to2[0]["species"] as? Dictionary<String,String> {
                                                                if let url3 = species3["url"] {
                                                                    let newUrl3 = url3.replacingOccurrences(of:"https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                                                    self._thirdEvo = newUrl3.replacingOccurrences(of: "/", with: "")
                                                                print(self._thirdEvo)
                                                                }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            completed()
                                        }
                                    }
                                }
                            }
                            completed()
                        }
                    }
                }
            }
            completed()
        }
    }
}
