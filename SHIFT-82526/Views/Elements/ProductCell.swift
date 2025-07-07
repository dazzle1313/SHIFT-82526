import UIKit

final class ProductCell: UICollectionViewCell {
    
    lazy private var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.gray
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Constants.Icons.blind
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var dataStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.mainFontSemiBold(size: 16)
        label.textColor = Constants.Colors.mainBlack
        return label
    }()
    
    lazy private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.mainFontSemiBold(size: 12)
        label.textColor = Constants.Colors.placeholder
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    lazy private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.mainFontSemiBold(size: 16)
        label.textColor = Constants.Colors.mainColor
        return label
    }()
    
    static var identifier = "ProductCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(imageView)
        addSubview(dataStack)
        dataStack.addArrangedSubview(nameLabel)
        dataStack.addArrangedSubview(descriptionLabel)
        dataStack.addArrangedSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            imageBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            imageBackgroundView.widthAnchor.constraint(equalToConstant: 170),
            imageBackgroundView.heightAnchor.constraint(equalToConstant: 170),
            imageBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            dataStack.topAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor, constant: 12),
            dataStack.leadingAnchor.constraint(equalTo: imageBackgroundView.leadingAnchor),
            dataStack.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor)
        ])
    }
    
    func setup(with product: Product) {
        nameLabel.text = product.title
        descriptionLabel.text = product.description
        priceLabel.text = formatePrice(price: product.price)
        
        guard let url = URL(string: product.image) else { return }
        UIImage.load(from: url) { image in
            if let image = image {
                self.imageView.image = image
            } else {
                self.imageView.image = Constants.Icons.blind
            }
        }
    }
    
}
