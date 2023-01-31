import UIKit
import SnapKit

final class CustomCell: UITableViewCell, FormConfigurableCell {
    static var reuseIdentifier: String = "CustomCell"
    weak var delegate: MainCellDelegate?
    private var cellData: DataDelegate?
    private lazy var isTaskDone: UIButton = {
        let button = UIButton()
        if let image  = UIImage(systemName: "circle") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .gray
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    private lazy var taskTitle: UILabel = {
        let label = UILabel()
        label.textColor = .textColor
        return label
    }()
    private lazy var moreActions: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        if let image  = UIImage(systemName: "ellipsis") {
            button.setImage(image, for: .normal)
        }
        return button
    }()
    func configure(dataModel: DataDelegate, delegate: MainCellDelegate) {
        if let cellData = dataModel as? ListItem  {
            self.cellData = cellData
            taskTitle.text = cellData.wrappedTitle
            isTaskDone.isHidden = true
        } else if let cellData = dataModel as? TaskItem {
            self.cellData = cellData
            taskTitle.text = cellData.wrappedName
            updateTaskIsDoneState(cellData.wrappedIsDone)
        }
        self.delegate = delegate
        self.contentView.isUserInteractionEnabled = false
        self.selectionStyle = .none
        setupConstraints()
    }
    
}

extension CustomCell {
    private func setupConstraints() {
        [isTaskDone, taskTitle, moreActions].forEach{ self.addSubview($0) }
        isTaskDone.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(CGFloat.leftOffset)
            make.size.equalTo(CGFloat.buttonsSize)
        }
        
        moreActions.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-CGFloat.leftOffset)
            make.size.equalTo(CGFloat.buttonsSize)
        }
        
        taskTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            if let _ = cellData as? ListItem {
                make.left.equalToSuperview().offset(CGFloat.leftOffset)
            } else {
                make.left.equalTo(isTaskDone.snp.right).offset(CGFloat.leftOffset / 2)
            }
            make.right.equalTo(moreActions.snp.left).offset(-CGFloat.leftOffset / 2)
        }
    }
    
    private func updateTaskIsDoneState(_ newState: Bool) {
        if newState {
            isTaskDone.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
            isTaskDone.tintColor = .doneColor
        } else {
            isTaskDone.setImage(UIImage(systemName: "circle"), for: .normal)
            isTaskDone.tintColor = .gray
        }
    }
    
    @objc private func didTapMoreButton() {
        if let cellData = cellData {
            delegate?.moreButtonPressed(cellData)
        }
    }
    
    @objc private func didTapDoneButton() {
        guard let cellData = cellData as? TaskItem else { return }
        updateTaskIsDoneState(cellData.isDone)
        delegate?.taskButtonPressed(cellData)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellData = nil
    }
}

