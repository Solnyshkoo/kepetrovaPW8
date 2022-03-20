import Foundation
import UIKit
final class DetailsMoviewView: UIView {
    private lazy var overview: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var title: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemMint
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var spokenLanguages: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productionCountries: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var voteAverage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genre: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var status: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var adult: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemMint
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: DetailsPresenter) {
        overview.text = data.overview
        print(data.overview)
        title.text = data.originalTitle
        adult.text = data.adult ?? false ? "+18" : ""
        spokenLanguages.text = "Language: " + data.spokenLanguages
        productionCountries.text = "Countries: " + data.productionCountries
        voteAverage.text = "Rating: " + String(data.voteAverage)
        genre.text = "Genre: " + data.genres
        status.text = "Status: " + data.status
        if adult.text == "" {
            title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        } else {
            title.trailingAnchor.constraint(equalTo: adult.leadingAnchor, constant: -5).isActive = true
        }
    }

    private func configureUI() {
        addSubview(overview)
        addSubview(title)
        addSubview(adult)
        addSubview(spokenLanguages)
        addSubview(productionCountries)
        addSubview(voteAverage)
        addSubview(genre)
        addSubview(status)
       
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.heightAnchor.constraint(equalToConstant: 50),
            
            adult.topAnchor.constraint(equalTo: topAnchor),
            adult.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            adult.heightAnchor.constraint(equalToConstant: 40),
            adult.widthAnchor.constraint(equalToConstant: 40),
            
            voteAverage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            voteAverage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            voteAverage.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            voteAverage.heightAnchor.constraint(equalToConstant: 30),
            
            status.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            status.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            status.topAnchor.constraint(equalTo: voteAverage.bottomAnchor),
            status.heightAnchor.constraint(equalToConstant: 30),
            
            genre.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            genre.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            genre.topAnchor.constraint(equalTo: status.bottomAnchor),
            genre.heightAnchor.constraint(equalToConstant: 30),
            
            spokenLanguages.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            spokenLanguages.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            spokenLanguages.topAnchor.constraint(equalTo: genre.bottomAnchor),
            spokenLanguages.heightAnchor.constraint(equalToConstant: 40),
            
            productionCountries.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            productionCountries.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            productionCountries.topAnchor.constraint(equalTo: spokenLanguages.bottomAnchor),
            productionCountries.heightAnchor.constraint(equalToConstant: 40),
            
            overview.topAnchor.constraint(equalTo: productionCountries.bottomAnchor),
            overview.leadingAnchor.constraint(equalTo: leadingAnchor),
            overview.trailingAnchor.constraint(equalTo: trailingAnchor),
            overview.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}
