

import UIKit
import MapKit
import FirebaseDatabase


protocol AddGeotificationsViewControllerDelegate {
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D,
    radius: Double, identifier: String, note: String, eventType: EventType)
}

var taskTitle: String = ""
var taskDescription: String = ""
var selectedDate: String = ""
var dateFormatter = DateFormatter()
var locationTag: String = ""


class AddGeotificationViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate {
    
     var list = ["atm", "bakery", "bicycle_store", "book_store", "car_repair", "car_wash", "florist", "laundry", "liquor_store", "pet_store", "post_office",  "pharmacy", "shoe_store", "veterinary_care", "convenience_store", "grocery_or_supermarket"]

  @IBOutlet weak var calendarPicker: UIDatePicker!

  @IBOutlet weak var dropDown: UIPickerView!
  @IBOutlet weak var textBox: UITextField!
    
  @IBOutlet var addButton: UIBarButtonItem!
  @IBOutlet var zoomButton: UIBarButtonItem!
  @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var radiusTextField: UITextField!
  @IBOutlet weak var noteTextField: UITextField!
  @IBOutlet weak var mapView: MKMapView!

  var delegate: AddGeotificationsViewControllerDelegate?
  let picker = UIPickerView()
  var ref: DatabaseReference?

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItems = [addButton, zoomButton]
    addButton.isEnabled = false
    picker.delegate = self
    picker.dataSource = self
    textBox.inputView = picker
    
    ref = Database.database().reference()

    
  }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return list.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textBox.text = list[row]
        self.view.endEditing(false)
    }

  @IBAction func textFieldEditingChanged(sender: UITextField) {
    addButton.isEnabled = !radiusTextField.text!.isEmpty && !noteTextField.text!.isEmpty
  }

  @IBAction func onCancel(sender: AnyObject) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction private func onAdd(sender: AnyObject) {
    let coordinate = mapView.centerCoordinate
    let radius = Double(radiusTextField.text!) ?? 0
    let identifier = NSUUID().uuidString
    let note = noteTextField.text
    let taggedLocation = textBox.text!
    
    let eventType: EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
    delegate?.addGeotificationViewController(controller: self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType)
    
    calendarPicker.datePickerMode = UIDatePickerMode.date
    
    dateFormatter.dateFormat = "dd MMM yyyy"
    selectedDate = dateFormatter.string(from: calendarPicker.date)

  
    let key = ref?.child("LocationToDos").childByAutoId().key
    let dictionaryTodo = ["Message" :  note!,
                           "Coordinates" : String(describing: coordinate),
                           "TaggedLocation": taggedLocation,
                           "CompletedBy" : selectedDate]
    if dictionaryTodo["TaggedLocation"]! == "bakery" {
      let coordinate = CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661)
      let custom = CustomAnnotation(coordinate: coordinate, title: "King David Kalakaua", subtitle: "YA")
      self.mapView.addAnnotation(custom)
    }

    
    let childUpdates = ["/LocationToDos/\(key!)": dictionaryTodo]
    ref?.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) -> Void in
      self.navigationController
    })
  
  }

  
  
  

  @IBAction private func onZoomToCurrentLocation(sender: AnyObject) {
    mapView.zoomToUserLocation()
  }
}
