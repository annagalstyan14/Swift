//
//  ContentView.swift
//  Calculator
//
//  Created by Anna Galstyan on 18.03.25.
//

import SwiftUI

enum CalcButton: String, Hashable{
    case zero = "0", one = "1", two = "2", three = "3", four = "4"
    case five = "5", six = "6", seven = "7", eight = "8", nine = "9"
    case decimal = ","
    case equals = "=", plus = "+", minus = "-", multiply = "×", divide = "÷"
    case clear = "AC", plusMinus = "±", percent = "%"
    
    var buttonColor: Color {
            switch self {
            case .clear, .plusMinus, .percent:
                return Color(.lightGray)
            case .divide, .multiply, .minus, .plus:
                return .orange
            case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .decimal, .equals:
                return Color(.darkGray)
            }
        }
    var foregroundColor: Color {
        switch self {
        case .clear, .plusMinus, .percent:
            return .white
        default:
            return .white
        }
    }
    var isWide: Bool {
        return self == .zero
    }
}

struct ContentView: View {
    @StateObject private var calculator = Calculator()
    let buttons: [[CalcButton]] = [
        [.clear, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 12){
                Spacer()
                HStack{
                    Spacer()
                    Text(calculator.getDisplayValue())
                        .bold()
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.trailing, 24)
                }
                //Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12){
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.buttonTapped(button)
                            }){
                                Text(button.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(button),
                                           height: self.buttonHeight(button))
                                    .background(button.buttonColor)
                                    .foregroundColor(button.foregroundColor)
                                    .cornerRadius(self.buttonHeight(button)/2)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
    }
    private func buttonWidth(_ button: CalcButton) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        let totalSpacing = 3 * spacing
        let regularWidth = (screenWidth - totalSpacing - 2 * spacing) / 4
        
        if button.isWide {
            return regularWidth * 2 + spacing
        }
        return regularWidth
    }
    private func buttonHeight(_ button: CalcButton) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 12
        let totalSpacing = 3 * spacing
        let regularHeight = (screenWidth - totalSpacing - 2 * spacing) / 4
        
        return regularHeight
    }
    private func buttonTapped (_ button : CalcButton){
        switch button {
        case .clear:
            calculator.clear()
        case .plusMinus:
            calculator.negate()
        case .percent:
            calculator.applyPercentage()
        case .equals:
            calculator.calculateResult()
        case .plus, .minus, .divide, .multiply:
            calculator.enterOperation(button.rawValue)
        case .decimal :
            calculator.enterDecimal()
        default:
            calculator.enterDigit(button.rawValue)
        }
    }
}

#Preview {
    ContentView()
}


