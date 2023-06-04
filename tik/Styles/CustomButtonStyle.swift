import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Roboto-Regular", size: 16))
            .foregroundColor(.white)
            .padding()
            .background(Color.appBlack)
            .cornerRadius(5)
    }
}
