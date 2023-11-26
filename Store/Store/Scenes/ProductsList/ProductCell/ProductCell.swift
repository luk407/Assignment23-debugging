//
//  ProductCell.swift
//  Store
//
//  Created by Baramidze on 25.11.23.
//

import UIKit

protocol ProductCellDelegate: AnyObject {
    func removeProduct(for cell: ProductCell)
    func addProduct(for cell: ProductCell)
}

final class ProductCell: UITableViewCell { // final

    @IBOutlet private weak var prodImageView: UIImageView! // IBOutlets are better to be private
    @IBOutlet private weak var prodTitleLbl: UILabel!
    @IBOutlet private weak var stockLbl: UILabel!
    @IBOutlet private weak var descrLbl: UILabel!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var selectedQuantityLbl: UILabel!
    @IBOutlet private weak var quantityModifierView: UIView!
    
    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quantityModifierView.isUserInteractionEnabled = true // plus and minus buttons were not clickable before I added this
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func prepareForReuse() { // this could help with problem with images after reload
        super.prepareForReuse()
        prodImageView.image = UIImage(named: "placeholder")
        prodTitleLbl.text = nil
        stockLbl.text = nil
        descrLbl.text = nil
        priceLbl.text = nil
        selectedQuantityLbl.text = nil
    }
    
    func setupUI(){
        quantityModifierView.layer.cornerRadius = 5
        quantityModifierView.layer.borderWidth = 1
        quantityModifierView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    func reload(with product: ProductModel) {
        //MARK: reload images are not correct when reloading list after changing quantity. RESOLVED! (I think :))
        setImage(from: product.thumbnail)
        prodTitleLbl.text = product.title
        stockLbl.text = "\(product.stock)"
        descrLbl.text = "\(product.description)"
        priceLbl.text = "\(product.price)$"
        selectedQuantityLbl.text = "\(product.selectedAmount ?? 0)"
    }
    
    private func setImage(from url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.prodImageView.image = image
            }
        }
    }
    
    @IBAction func addProduct(_ sender: UIButton) {
        self.delegate?.addProduct(for: self)
    }
    
    @IBAction func removeProduct(_ sender: UIButton) {
        self.delegate?.removeProduct(for: self)
    }
}
