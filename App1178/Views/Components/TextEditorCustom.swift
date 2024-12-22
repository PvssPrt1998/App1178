import SwiftUI

struct TextEditorCustom: View {
    
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        if #available(iOS 16.0, *) {
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .background(
                    placeholderView
                )
                .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .frame(height: 115)
        } else {
            TextEditor(text: $text)
                .background(
                    placeholderView
                )
                .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .frame(height: 115)
//                .padding(EdgeInsets(top: 12, leading: hPadding, bottom: 0, trailing: hPadding))
        }
    }
    
    private var placeholderView: some View {
        Text(text == "" ? placeholder : "")
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(.black.opacity(0.3))
            .padding(EdgeInsets(top: 8, leading: 4, bottom: 0, trailing: 0))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct TextEditorCustom_Preview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        TextEditorCustom(text: $text, placeholder: "Placeholder")
            .padding()
            .background(Color.black)
    }
    
}
