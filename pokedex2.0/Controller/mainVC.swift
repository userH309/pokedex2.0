import UIKit
import AVFoundation

class mainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var colletionView:UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    //An array to store all the pokemons.
    var arrayPokemon = [pokemon]()
    //Array for storing all the pokemons.
    var arrayFilteredPokemon = [pokemon]()
    var musicPlayer = AVAudioPlayer()
    var searchMode:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        colletionView.delegate = self
        colletionView.dataSource = self
        searchBar.returnKeyType = .done
        parsePokemonCSV()
        initAudio()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //If we are searching.
        if searchMode {
            return arrayFilteredPokemon.count
        }
        else {
            return arrayPokemon.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokeTemp:pokemon!
        //If we are searching.
        if searchMode {
            pokeTemp = arrayFilteredPokemon[indexPath.row]
        }
        else {
            pokeTemp = arrayPokemon[indexPath.row]
        }
        performSegue(withIdentifier: "pokemonDetailsVC", sender: pokeTemp)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = colletionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? pokeCell {
            let pokeTemp:pokemon
            //If we are searching.
            if searchMode == true {
                pokeTemp = arrayFilteredPokemon[indexPath.row]
                cell.configureCell(pokemon: pokeTemp)
            }
            else {
                pokeTemp = arrayPokemon[indexPath.row]
                cell.configureCell(pokemon: pokeTemp)
            }
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    //Prepare before segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Hvis segue ID er pokemonDetailsVC.
        if segue.identifier == "pokemonDetailsVC" {
            if let detailsVC = segue.destination as? pokemonDetailsVC {
                if let senderTemp = sender as? pokemon {
                    detailsVC.pokemon = senderTemp
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searchMode = false
            colletionView.reloadData()
            view.endEditing(true)
        }
        else {
            searchMode = true
            //Convert searchbar input text to lowercase.
            let lower = searchBar.text!.lowercased()
            //Find pokemons that match search text then store in arrayFilteredPokemon.
            arrayFilteredPokemon = arrayPokemon.filter({$0.name.range(of: lower) != nil})
            colletionView.reloadData()
        }
    }
    
    func initAudio() {
        //Store path for internal sound file.
        let path = Bundle.main.path(forResource: "uth", ofType: "wav")!
        do {
            //Check if we find the sound file.
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            //Preload audio in buffers.
            musicPlayer.prepareToPlay()
            //Infinite loop.
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        //Store filepath for internal csv file.
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do {
            //Pass in our filepath to the csv class convenience init.
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //Pick the id and identifier, then pass it to pokemon init.
            for item in rows {
                let pokeID = Int(item["id"]!)
                let pokeName = item["identifier"]!
                let pokeTemp = pokemon(name: pokeName, pokedexID: pokeID!)
                arrayPokemon.append(pokeTemp)
            }
        }
        catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }
        else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
}
