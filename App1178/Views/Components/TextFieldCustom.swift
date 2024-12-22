import SwiftUI

struct TextFieldCustom: View {
    
    @Binding var text: String
    
    var needPrefix: Bool = true
    let prefix: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 0) {
            if needPrefix {
                Text(prefix)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(width: 100)
            }
            TextField("", text: $text)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.black)
                .autocorrectionDisabled(true)
                .accentColor(.black)
                .background(
                    placeholderView()
                )
        }
        .padding(.leading, 16)
        .frame(height: 44)
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder func placeholderView() -> some View {
        Text(text != "" ? "" : placeholder)
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.black.opacity(0.3))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TargetTextField_Preview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        TextFieldCustom(text: $text, prefix: "Name", placeholder: "Name")
            .padding()
    }
}
