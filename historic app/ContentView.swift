import MapKit
import SwiftUI
import CoreLocation

struct MapView: UIViewControllerRepresentable {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var zoomInOut: Double
    let locationManager: CLLocationManager
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(parent: MapView) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        viewController.view = mapView
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let mapView = uiViewController.view as! MKMapView
        mapView.delegate = context.coordinator
        
        for location in viewModel.locations {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let span = MKCoordinateSpan(latitudeDelta: zoomInOut, longitudeDelta: zoomInOut)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location.name
            mapView.addAnnotation(annotation)
        }
    }
}

//Content view variables theyre name-explanatory
struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "star.fill")
                }
        }
        .environmentObject(viewModel)
    }
}

//Its that little grey thing on top of the sheet
struct HandleBar: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 5)
            .foregroundColor(Color.gray)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .preferredColorScheme(.dark)
    }
}

