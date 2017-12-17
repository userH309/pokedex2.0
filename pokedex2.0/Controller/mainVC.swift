import UIKit
import AVFoundation

class mainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate
{
    @IBOutlet weak var colletionView:UICollectionView! //hook up the colletionView from the view controller
    @IBOutlet weak var searchBar: UISearchBar! //hook up the searchbar from the view controller
     
    var arrayPokemon = [pokemon]() //array that holds pokemons
    var arrayFilteredPokemon = [pokemon]() //array that holds filtered pokemons
    var musicPlayer = AVAudioPlayer()
    var searchMode:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        colletionView.dataSource = self
        colletionView.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio()
    {
        let path = Bundle.main.path(forResource: "uth", ofType: "wav")! //store the filepath for the soundfile
        do
        {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) //test the path
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }
        catch let err as NSError //catch error
        {
            print(err.debugDescription) //print the error to console
        }
    }
    
    func parsePokemonCSV()
    {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")! //store the path for the CSV file
        do
        {
            let csv = try CSV(contentsOfURL: path) //init the CSV class using the convenience init to pull out the rows
            let rows = csv.rows //store the rows in constant
            
            for item in rows //go through each row
            {
                let pokeID = Int(item["id"]!) //get value for key id
                let pokeName = item["identifier"]! //get value for key identifier
                let pokeTemp = pokemon(name: pokeName, pokedexID: pokeID!) //init the pokemon class with values we got from the csv
                arrayPokemon.append(pokeTemp) //append in array
            }
        }
            
        catch let err as NSError
        {
            print(err.debugDescription)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1 //return only one section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if searchMode == true
        {
            return arrayFilteredPokemon.count
        }
        else
        {
            return arrayPokemon.count //return the number of pokemons in array
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var pokeTemp:pokemon!
        if searchMode
        {
            pokeTemp = arrayFilteredPokemon[indexPath.row]
        }
        else
        {
            pokeTemp = arrayPokemon[indexPath.row]
        }
        performSegue(withIdentifier: "pokemonDetailsVC", sender: pokeTemp)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = colletionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? pokeCell //check if cell identifier and type is matching
        {
            let pokeTemp:pokemon
            if searchMode == true //if user types in searchBar
            {
                pokeTemp = arrayFilteredPokemon[indexPath.row]
                cell.configureCell(pokemon: pokeTemp)
            }
            else
            {
                pokeTemp = arrayPokemon[indexPath.row]
                cell.configureCell(pokemon: pokeTemp)
            }
            return cell //return the cell
        }
        else
        {
            return UICollectionViewCell()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text == nil || searchBar.text == ""
        {
            searchMode = false
            colletionView.reloadData()
            view.endEditing(true)
        }
        else
        {
            searchMode = true
            let lower = searchBar.text!.lowercased() //convert the input text to lowercased
            arrayFilteredPokemon = arrayPokemon.filter({$0.name.range(of: lower) != nil}) //check if the stuff we insert in searchbar is the same as one of the object in the array
            colletionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) //prep before segue
    {
        if segue.identifier == "pokemonDetailsVC" //check if segue ID is correct
        {
            if let detailsVC = segue.destination as? pokemonDetailsVC //check if destination is correct
            {
                if let senderTemp = sender as? pokemon //check if sender type is correct
                {
                    detailsVC.pokemon = senderTemp //store in variable pokemon in detailsVC class
                }
            }
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton)
    {
        if musicPlayer.isPlaying
        {
            musicPlayer.pause()
            sender.alpha = 0.2
        }
        else
        {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
}
