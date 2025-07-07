import UIKit

enum Constants {
    
    enum Colors {
        static let mainColor = UIColor(named: "main")
        static let mainColorDark = UIColor(named: "main-dark")
        static let mainColorLight = UIColor(named: "main-light")
        static let customWhite = UIColor(named: "custom-white")
        static let mainBlack = UIColor(named: "black-main")
        static let error = UIColor(named: "error")
        static let gray = UIColor(named: "gray")
        static let grayDark = UIColor(named: "gray-dark")
        static let placeholder = UIColor(named: "placeholder")
    }
    
    enum Fonts {
        static func mainFont(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "Manrope-Regular", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        }
        
        static func mainFontMedium(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "Manrope-Medium", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        }
        
        static func mainFontSemiBold(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "Manrope-SemiBold", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        }
    }
    
    enum Images {
        static let logoCircle = UIImage(named: "logo-circle")
    }
    
    enum UserDefaults {
        static let userData = "userData"
        static let isLoggedIn = "isUserLoggedIn"
    }
    
    enum Icons {
        static let blind = UIImage(named: "blind")
        static let greeting = UIImage(named: "greeting")
        static let logout = UIImage(named: "logout")
    }
    
}
