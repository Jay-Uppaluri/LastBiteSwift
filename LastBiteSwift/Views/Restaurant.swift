import SwiftUI
import CoreLocation
import MapKit
import FirebaseFirestore
import StripePaymentSheet

import SwiftUI
import CoreLocation
import MapKit
import FirebaseFirestore

struct RestaurantView: View {
    let restaurant: Restaurant
    @ObservedObject var model = PaymentService()
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        model.preparePaymentSheet(restaurantId: restaurant.id!)
    }

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 8) {
                GeometryReader { geometry in
                    Image("card-image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .frame(height: UIScreen.main.bounds.height / 5)
                .edgesIgnoringSafeArea(.top)

                Circle()
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                    .offset(y: -25)

                VStack(alignment: .center, spacing: 4) {
                    Text(restaurant.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)

                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)

                    HStack {
                        Spacer()
                        Text("\(restaurant.ordersLeft) orders left!")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            .background(Color(red: 0, green: 128/255, blue: 128))
                            .clipShape(Capsule())
                        Spacer()
                    }

                    Text("Pick up today")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 255/255, green: 90/255, blue: 96/255))

                    Text("from 8am to 8pm")
                        .font(.system(size: 16))
                        .foregroundColor(.black)

                    Text("Location:")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    Text(restaurant.address)
                        .font(.system(size: 16))
                        .foregroundColor(.black)

                    Text("About us")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    Text(restaurant.description)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .padding(.bottom, 32)
                }
                .padding([.leading, .trailing, .bottom])

                if let paymentSheet = model.paymentSheet {
                                   PaymentSheet.PaymentButton(
                                       paymentSheet: paymentSheet,
                                       onCompletion: { result in
                                           model.onPaymentCompletion(result: result)
                                           model.paymentSheet = nil
                                       }
                                   ) {
                                       Text("Reserve")
                                           .font(.system(size: 20))
                                           .foregroundColor(.white)
                                           .frame(minWidth: 0, maxWidth: .infinity)
                                           .padding()
                                           .background(Color.blue)
                                           .cornerRadius(10)
                                   }
                                   .padding([.leading, .trailing, .bottom])
                               } else {
                                   Text("Loading...")
                                       .font(.system(size: 20))
                                       .foregroundColor(.gray)
                                       .frame(minWidth: 0, maxWidth: .infinity)
                                       .padding()
                                       .background(Color.gray.opacity(0.2))
                                       .cornerRadius(10)
                               }
                           }
                       }
                       .background(Color.white.edgesIgnoringSafeArea(.all))
                       .onAppear { model.preparePaymentSheet(restaurantId: restaurant.id!) }
                   }
               }

               struct RestaurantView_Previews: PreviewProvider {
                   static var previews: some View {
                       RestaurantView(restaurant: Restaurant(name: "Test Restaurant", createdOn: Timestamp(), location: GeoPoint(latitude: 37.7749, longitude: -122.4194), ordersRemaining: 10, rating: 4.5, description: "This is a test restaurant.", price: 25.0, ordersLeft: 5, address: "test", type: "Pizza"))
                   }
               }
