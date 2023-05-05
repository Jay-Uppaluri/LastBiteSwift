//
//  CategoriesCard.swift
//  Restaurant
//

import SwiftUI

struct CategoriesCard: View {
  var category: String
    var body: some View {
      VStack {
        Text(category)
          .font(.custom("DMSans-Bold", size: 14))
          .padding(18)
          .foregroundColor(Color(hex: "266577"))
      }
      .frame(height: 24)
      .background(Color(hex: "D5F7FE"))
    }
}
