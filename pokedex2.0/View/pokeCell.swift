import UIKit

class pokeCell: UICollectionViewCell
{
    @IBOutlet weak var thumbImg:UIImageView!
    @IBOutlet weak var nameLbl:UILabel!
    
    required init?(coder aDecoder: NSCoder) //check this later
    {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0 //round the image corners
    }
    
    func configureCell(pokemon: pokemon)
    {
        nameLbl.text = pokemon.name.capitalized //set the label name
        thumbImg.image = UIImage(named: "\(pokemon.pokedexID)") //set the image
    }
}
