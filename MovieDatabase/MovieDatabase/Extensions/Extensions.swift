
//  MovieDatabase
//
//  Created by arturs.olekss on 22/11/2023.
//

import UIKit

extension UIViewController {
    
    func basicAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
        }
    }
    
    func changeToAdd(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.yellow.cgColor
        button.layer.borderWidth = 0
        button.setTitle("+ Add to Watchlist", for: .normal)
        button.setTitleColor(.black, for: .normal)
    }
    
    func changeToAdded(_ button: UIButton) {
        button.layer.backgroundColor = UIColor.systemGray6.cgColor
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.yellow.cgColor
        button.setTitle("✓ Added to Watchlist", for: .normal)
        button.setTitleColor(.white, for: .normal)
    }
}

extension Optional where Wrapped == Double  {

    var stringValue: String {
        guard let value = self else { return "No Value Provided" }
        return String(format: "%.1f", value)
    }
}

extension Optional where Wrapped == String {
    
    var longDateString: String {
        guard let date = self else { return "No Value Provided" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let dateObj = dateFormatter.date(from: date) else { return "" }
        
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateStyle = .long
        
        return "\(dateFormatter.string(from: dateObj))"
    }
    
    var stringValue: String {
        guard let value = self else { return "No Value Provided" }
        return value
    }
}

extension Optional where Wrapped == Int {
    
    var hoursAndMinutes: String {
        guard let minutes = self else { return "No Value Provided" }
        
        if minutes != 0 {
            return "\(minutes / 60)h \(minutes % 60)m"
        }else{
            return "Runtime unknown"
        }
    }
    
    var stringValue: String {
        guard let value = self else { return "No Value Provided" }
        return "\(value)"
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.label
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

