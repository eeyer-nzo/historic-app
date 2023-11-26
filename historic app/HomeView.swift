//
//  HomeView.swift
//  historic app
//
//  Created by Arthan Tjen on 25/11/23.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var showSheet = false
    @State private var sheetPosition: CGFloat = 0 // Initially on-screen
    @State private var chkShtTbPos = false
    @State private var isExpanded = false
    
    @State private var zoomInOut = 0.001
    
    @State private var locationManager = CLLocationManager()
    
    var body: some View {
        ZStack {
            MapView(zoomInOut: $zoomInOut, locationManager: locationManager)
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    VStack(spacing: 0) {
                        HandleBar()
                            .frame(maxWidth: .infinity)
                            .background(.black.opacity(0.000001))
                        
                        //DO NOT CHANGE WTV CODE IS FROM HERE{
                            .gesture(
                                DragGesture(coordinateSpace: .named("Geometry"))
                                    .onChanged { value in
                                        // Update sheet position based on drag gesture
                                        sheetPosition = value.translation.height
                                    }
                                    .onEnded { value in
                                        
                                        // Determine whether to show or hide the sheet based on drag distance
                                        let threshold: CGFloat = -50
                                        
                                        //BTW you can edit the code but ONLY the one below if u understand whats going on wtv is above DO NOT TOUCH is the sheet movement code.
                                        
                                        //What happens when the sheet goes up
                                        
                                        withAnimation(.smooth){
                                            chkShtTbPos = true
                                            if chkShtTbPos == true{
                                                isExpanded = true
                                                sheetPosition = 0
                                            }
                                        }
                                        if value.translation.height < threshold {
                                            withAnimation {
                                                // This controls how high the sheet goes up btw higher value decreases height 不要问
                                                showSheet = false
                                                
                                            }
                                        } else { // What happens when sheet goes down
                                            
                                            withAnimation(.smooth){
                                                
                                                chkShtTbPos = false
                                                if chkShtTbPos == false{
                                                    isExpanded = false
                                                    sheetPosition = 0
                                                }
                                            }
                                            
                                            
                                            sheetPosition = 0
                                            showSheet = true
                                        }
                                        
                                    })// }TO HERE its basically a .gesture code with a super long parameter details inside
                        
                        LocationsListView()// This is the sheets view like buttons
                    }
                    .background(Color(.systemBackground))
                    .frame(height: geometry.size.height * (isExpanded ? 1 : 0.5) - sheetPosition)
                }//Vstack ends here
            }
            .coordinateSpace(name: "Geometry")
        }
        .onAppear {
            requestLocationPermission()
        }
    }
    
    // and ends roughly somewhere here
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

#Preview {
    HomeView()
}
