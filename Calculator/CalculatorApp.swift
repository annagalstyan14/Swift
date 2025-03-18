//
//  CalculatorApp.swift
//  Calculator
//
//  Created by Anna Galstyan on 18.03.25.
//

import SwiftUI

@main
struct CalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class Calculator: ObservableObject{
    @Published private(set) var expression: String = "0"
    private var currentNumber: String = "0"
    private var isStartingNewNumber = true
    private var lastResult: Double?
    private var shouldReplaceExpression = false
    
    // Get the current display value
    func getDisplayValue() -> String {
        return currentNumber
    }
    
    // Handle number input
    func enterDigit(_ digit: String) {
        if shouldReplaceExpression {
            clear()
            shouldReplaceExpression = false
        }
        
        if isStartingNewNumber {
            currentNumber = digit
            isStartingNewNumber = false
        } else {
            currentNumber = currentNumber == "0" ? digit : currentNumber + digit
        }
        
        if expression == "0" {
            expression = digit
        } else if isStartingNewNumber {
            expression += digit
        } else {
           // expression = expression.replacingOccurrences(of: currentNumber.dropLast().description, with: currentNumber, options: .anchored)
            if isStartingNewNumber {
                expression += "\(digit)"
            } else {
                expression += digit
            }
        }
    }
    
    // Handle decimal point
    func enterDecimal() {
        if shouldReplaceExpression {
            clear()
            shouldReplaceExpression = false
        }
        
        if isStartingNewNumber {
            currentNumber = "0."
            expression += "0."
            isStartingNewNumber = false
        } else if !currentNumber.contains(".") {
            currentNumber += "."
            expression += "."
        }
    }
    
    // Handle operations (+, -, ×, ÷)
    func enterOperation(_ operation: String) {
        if shouldReplaceExpression {
            expression = currentNumber
            shouldReplaceExpression = false
        }
        
        // If we're in the middle of entering a number, add it to the expression
        if !isStartingNewNumber {
            isStartingNewNumber = true
        }
        
        // Add the operation to the expression
        expression += " \(operation) "
    }
    
    // Handle equals
    func calculateResult() {
        let formattedExpression = expression
            .replacingOccurrences(of: "×", with: "*")
            .replacingOccurrences(of: "÷", with: "/")
            .replacingOccurrences(of: ",", with: ".")
        
        let exp = NSExpression(format: formattedExpression)
        if let result = exp.expressionValue(with: nil, context: nil) as? Double {
            lastResult = result
            currentNumber = formatResult(result)
            expression = currentNumber
            shouldReplaceExpression = true
        }
    }
    
    // Handle percentage
    func applyPercentage() {
        if let number = Double(currentNumber) {
            let result = number / 100.0
            currentNumber = formatResult(result)
            
            // Update the last number in the expression with the percentage result
            let components = expression.components(separatedBy: " ")
            if components.count > 0 {
                expression = components.dropLast().joined(separator: " ")
                if !expression.isEmpty {
                    expression += " "
                }
                expression += currentNumber
            } else {
                expression = currentNumber
            }
        }
    }
    
    // Handle plus/minus
    func negate() {
        if let number = Double(currentNumber) {
            currentNumber = formatResult(-number)
            
            // Update the last number in the expression with the negated value
            let components = expression.components(separatedBy: " ")
            if components.count > 0 {
                expression = components.dropLast().joined(separator: " ")
                if !expression.isEmpty {
                    expression += " "
                }
                expression += currentNumber
            } else {
                expression = currentNumber
            }
        }
    }
    
    // Handle clear
    func clear() {
        expression = "0"
        currentNumber = "0"
        isStartingNewNumber = true
        lastResult = nil
        shouldReplaceExpression = false
    }
    
    // Get the full expression (useful for debugging)
    func getExpression() -> String {
        return expression
    }
    
    // Format result to avoid unnecessary decimal places
    private func formatResult(_ number: Double) -> String {
        if abs(number) > 1e10 {
            return String(format: "%.2e", number)
        }
        
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", number)
        } else {
            return String(format: "%.8f", number)
                .replacingOccurrences(of: #"\.?0+$"#, with: "", options: .regularExpression)
        }
    }
}

