import SwiftUI

struct DeleteActionSheet: View {
    
    @State var offset: CGFloat = 300
    let deleteAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text("A deleted recipe cannot be restored.")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    
                    Divider()
                    
                    Button {
                        deleteAction()
                    } label: {
                        Text("Delete recipe")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.labelPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    
                }
                .background(Color.c234234234)
                .clipShape(.rect(cornerRadius: 14))
                
                Button {
                    withAnimation {
                        offset = 300
                    }
                    cancelAction()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.c234234234)
                        .clipShape(.rect(cornerRadius: 14))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 8, bottom: 14, trailing: 8))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: offset)
        }
        .onAppear {
            withAnimation {
                offset = 0
            }
        }
    }
}

#Preview {
    DeleteActionSheet(deleteAction: {}, cancelAction: {})
}
