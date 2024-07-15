import UIKit
import RxSwift
import IDMPhotoBrowser

class DetailsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var privateViewModel: DetailsViewModel!
    
    private var pickerView: UIPickerView!
    
    @IBOutlet weak var treasureImageView: UIImageView!
    @IBOutlet weak var nextButtonOutlet: MainButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoriesTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.setupImage(Asset.Assets.picAbout.image)
        setupPickerView()
        bindViewModel()
        setupObservers()
    }
    
    private func bindViewModel() {
        privateViewModel.categories.bind(to: pickerView.rx.itemTitles) { row, element in
            return element.rawValue
        }.disposed(by: disposeBag)
        privateViewModel.imageObservable.bind(to: treasureImageView.rx.image).disposed(by: disposeBag)
    }
    
    private func setupObservers() {
        pickerView.rx.modelSelected(TreasureCategory.self).subscribe(onNext: { (category) in
            self.categoriesTextField.text = category.first?.rawValue
            self.privateViewModel.setupCategory(category.first ?? .other)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent(.editingDidEnd).asObservable().subscribe(onNext: {
            self.privateViewModel.setupName(self.nameTextField.text ?? "")
            self.nextButtonOutlet.isEnabled = self.nameTextField.text?.count ?? 0 > 2
        }).disposed(by: disposeBag)
        
        descriptionTextField.rx.controlEvent(.editingDidEnd).asObservable().subscribe(onNext: {
            self.privateViewModel.setupDescription(self.descriptionTextField.text ?? "")
        }).disposed(by: disposeBag)
        
        privateViewModel.imageObservable.subscribe(onNext: { img in
            guard img != nil else {return}
            self.treasureImageView.image = img
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    func setupViewModel(_ viewModel: LocationMapViewModel) {
        self.privateViewModel = DetailsViewModel(image: viewModel.getImage(),
                                                 treasureModel: viewModel.treasureModel)
    }
    
    private func setupPickerView() {
        pickerView = UIPickerView()
        categoriesTextField.inputView = pickerView
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                pickerView.setValue(UIColor (named: "white"), forKeyPath: "textColor")
            } else {
                pickerView.setValue(UIColor (named: "blue_dark"), forKeyPath: "textColor")
            }
        }
    }
    
    private func openImageViewer() {
        guard let image = self.treasureImageView.image else {
            pickPhoto()
            return
        }
        let photos = IDMPhoto.photos(withImages: [image])
        guard let browser = IDMPhotoBrowser(photos: photos,animatedFrom: self.treasureImageView) else {return}
        browser.forceHideStatusBar   = true
        present(browser, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ResultMapViewController else { return }
        vc.setupViewModel(self.privateViewModel)
    }
    
    @IBAction func openImageButtonAction(_ sender: Any)
    {
        openImageViewer()
    }
    
    @IBAction func editImageButtonAction(_ sender: Any)
    {
        self.pickPhoto()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        perform(segue: StoryboardSegue.CreateScreen.resultMapSegue)
    }
}

extension DetailsViewController
{
    var viewModel: ImagePickableProtocol {
        return self.privateViewModel
    }
}

extension DetailsViewController: ImagePickableViewControllerProtocol,  UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            self.viewModel.setupImage(nil)
            picker.dismiss(animated: true, completion: nil)
            return
        }
        self.viewModel.setupImage(image)
        picker.dismiss(animated: true, completion: nil)
    }
}
