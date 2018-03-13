import UIKit

class pokemonDetailsVC: UIViewController {
    var pokemon:pokemon!
    @IBOutlet weak var pokemonNameLbl: UILabel!
    @IBOutlet weak var pokeIMG: UIImageView!
    @IBOutlet weak var pokeDescription: UILabel!
    @IBOutlet weak var pokeType: UILabel!
    @IBOutlet weak var pokeHeight: UILabel!
    @IBOutlet weak var pokeWeight: UILabel!
    @IBOutlet weak var pokeDefence: UILabel!
    @IBOutlet weak var pokeID: UILabel!
    @IBOutlet weak var pokeAttack: UILabel!
    @IBOutlet weak var pokeEvoIMG1: UIImageView!
    @IBOutlet weak var pokeEvoIMG2: UIImageView!
    @IBOutlet weak var pokeEvoIMG3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonNameLbl.text = pokemon.name.capitalized
        //Download pokemon data.
        pokemon.downloadPokemonDetails {
            self.updateUI()
        }
    }
    
    func updateUI() {
        pokeAttack.text = pokemon.attack
        pokeDefence.text = pokemon.defence
        pokeHeight.text = pokemon.height
        pokeWeight.text = pokemon.weight
        pokeID.text = "\(pokemon.pokedexID)"
        pokeType.text = pokemon.type.capitalized
        pokeDescription.text = pokemon.description
        pokeIMG.image = UIImage(named: "\(pokemon.pokedexID)")
        pokeEvoIMG1.image = UIImage(named: "\(pokemon.firstEvo)")
        pokeEvoIMG2.image = UIImage(named: "\(pokemon.secondEvo)")
        pokeEvoIMG3.image = UIImage(named: "\(pokemon.thirdEvo)")
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
