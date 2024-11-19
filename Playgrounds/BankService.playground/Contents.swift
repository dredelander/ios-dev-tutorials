

struct SwiftBank {
    
    private let password: String
    private var balance: Double = 0 {
        didSet{
            if balance < 100{
                displayLowBalanceMessage()
            }
        }
    }
    static let depositBonusrate: Double = 0.01
    
    init(password: String, initialDeposit: Double) {
        self.password = password
        makeDeposit(ofAmount: initialDeposit)
    }
    
    private func isValid(enteredPassword: String)-> Bool{
        return enteredPassword == password
    }
    
    private func finalDepositWithBonus(fromIntitialDeposit deposit :Double)-> Double{
        return deposit + (deposit * SwiftBank.depositBonusrate)
    }
    
    mutating func  makeDeposit(ofAmount depositAmonut: Double){
        let depositWithBonus = finalDepositWithBonus(fromIntitialDeposit: depositAmonut)
        print("Making a deposit of $\(depositAmonut) with a bonus rate. The final amount deposited is $\(depositWithBonus)")
        balance += depositWithBonus
    }
    
    func displayBalance(usingPassword password:String) {
        if !isValid(enteredPassword: password){
            print("Error: Invalid Password. Cannot retreive balance")
            return
        } else {
            print("Your current balance is $\(balance)")
        }
    }
    
    mutating func makeWithdrawal(ofAmount withdrawalAmount: Double, usingPassowrd password: String){
        if !isValid(enteredPassword: password){
            print("Error: Invalid Password. Cannot make a withdrawal")
            return
        } else {
            balance -= withdrawalAmount
            print("Making a $\(withdrawalAmount) withdrawal")
        }
    }
    
    private func displayLowBalanceMessage(){
        print("Alert: Your balance is under $100")
    }
    
}

var viBanco = SwiftBank(password: "123", initialDeposit: 500)

viBanco.makeDeposit(ofAmount: 50)

viBanco.makeWithdrawal(ofAmount: 100, usingPassowrd: "123")

viBanco.displayBalance(usingPassword: "123")
