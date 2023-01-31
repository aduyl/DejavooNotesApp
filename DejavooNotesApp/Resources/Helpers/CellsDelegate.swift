import UIKit

protocol FormConfigurableCell where Self: UITableViewCell {
    func configure(dataModel: DataDelegate, delegate: MainCellDelegate)
    var delegate: MainCellDelegate? { get set }
}
protocol CellViewModel {
    var id: String { get }
    func cellClass() -> UITableViewCell.Type
}

protocol FormConfigurableCellDelegate: AnyObject {
    func buttonPressed(cell: FormConfigurableCell, sender: UIView)
}

protocol MainCellDelegate: AnyObject {
    func moreButtonPressed(_ item: DataDelegate)
    func taskButtonPressed(_ item: DataDelegate)
}

protocol DataDelegate {
    
}
