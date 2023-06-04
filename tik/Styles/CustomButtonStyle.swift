import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Roboto-Bold", size: 22))
            .foregroundColor(.appBlack)
            .padding()
            .background(Color.appYellow)
            .cornerRadius(15)
    }
}
