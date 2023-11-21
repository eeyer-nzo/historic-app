import SwiftUI
import MapKit
//You should know

//IDK someone fill this in
struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    //Map details
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 1.2540, longitude: 103.8234)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Sentosa"
        uiView.addAnnotation(annotation)
    }
}

//Content view variables theyre name-explanatory
struct ContentView: View {
    @State private var showSheet = false
    @State private var sheetPosition: CGFloat = 0 // Initially on-screen
    @State private var selectedTab = 0
    @State private var textEntered = ""
    @State private var tabPos: CGFloat = 0
    //4 The var below, false is when the sheet is down
    @State private var chkShtTbPos = false
    @State private var spacerMnLngth: CGFloat = 300
    @State private var showFav = false
    
    
    var body: some View {
        //Everything on screen starts here{
        
        ZStack {
            MapView()
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                VStack(spacing: 0) {
                    
                    HandleBar()
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.000001))
                    //DO NOT CHANGE WTV CODE IS FROM HERE{
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Update sheet position based on drag gesture
                                    withAnimation {
                                        sheetPosition = max(min(value.translation.height, 0), -UIScreen.main .bounds.height)
                                    }
                                }
                            
                                .onEnded { value in
                                    // Determine whether to show or hide the sheet based on drag distance
                                    let threshold: CGFloat = -100
                                    
                                    //BTW you can edit the code but ONLY the one below if u understand whats going on wtv is above DO NOT TOUCH is the sheet movement code.
                                    
                                    //What happens when the sheet goes up
                                    withAnimation(.snappy){
                                        chkShtTbPos = true
                                        if chkShtTbPos == true{
                                            spacerMnLngth = -300
                                        }
                                    }
                                    if value.translation.height < threshold {
                                        withAnimation {
                                            // This controls how high the sheet goes up
                                            sheetPosition =  -UIScreen.main.bounds.height
                                            + 525
                                            showSheet = false
                                            
                                        }
                                    } else { // What happens when sheet goes down
                                        withAnimation(.snappy){
                                            chkShtTbPos = false
                                            if chkShtTbPos == false{
                                                spacerMnLngth = 300
                                            }
                                        }
                                        
                                        withAnimation {
                                            sheetPosition = 0
                                            showSheet = true
                                        }
                                        
                                    }
                                }
                            
                        )// }TO HERE its basically a .gesture code with a super long parameter details inside
                    
                    //Creates the tab bar
                    TabView{
                        VStack {
                            // This is shown when the home "Button" is clicked
                            NavigationStack {
                                CustomSheetView()// This is the sheets view like buttons
                                //The nav title is honestly redundant but lets just leave it
                                    .navigationTitle("Locations")
                            }
                        }
                        //Creates the home button design
                        
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                            
                        }
                        VStack{
                            
                        }
                        .tabItem {
                            Image(systemName: "star.fill")
                            Text("Favourites")
                            
                        }
                        
                    }
                    // The spacer 🎵 push and pull like a magnet do 🎵 the Tab Bar
                    Spacer(minLength: spacerMnLngth)
                }
            }
            //Vstack ends here
            .background(Color(.systemBackground))
            .offset(y: sheetPosition + 350)
            
        }
    }
    // and ends roughly somewhere here
}

//Edits everthing displayed on the sheet{
struct CustomSheetView: View {
    let names = ["Fort Canning Park", "CHIJMES", "Fort Siloso", "The Battle Box", "Old Changi Hospital", "National Museum", "Lau Pa Sat"]
    @State private var searchText = ""
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { name in
                    
                    NavigationLink {
                        
                        Image("monkey")
                        HStack {
                            Text(name)
                                .font(.system(size: 24))
                                .bold()
                            Text("200km")
                                .font(.system(size: 12))
                            Button {
                                //placeholder text, its supposed to put the location into favourites
                                print("favourite!")
                            } label: {
                                Label(" ", systemImage: "heart.circle")
                                    
                            }
                            
                        }
                        HStack {
                            Text("2 Fusionopolis Way, Singapore 138634")
                                .font(.system(size: 17))
                                .bold()
                            Image(systemName: "location.circle.fill")
                        }
                        Text("blablablablabla something about history idk extend this thing alot cookie monster chicken nugget french fry onion ring upsize coca cola zero sugar two plus two equals to four")
                        Spacer()
                        Text("Nearest MRT Station: one-north (CC23)")
                        Text("Nearest Bus Services: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10")
                        Spacer()
                    } label: {
                        Text(name)
                        
                    }
                }
            }
            .navigationTitle("Locations")
            
            .searchable(text: $searchText)
            
            
            var searchResults: [String] {
                if searchText.isEmpty {
                    return names
                } else {
                    return names.filter { $0.contains(searchText) }
                }
            }
        }
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
        //.preferredColorScheme(.dark)
    }
}
