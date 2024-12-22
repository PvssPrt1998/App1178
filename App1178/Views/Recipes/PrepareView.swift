import SwiftUI

struct PrepareView: View {
    
    @State var offset: CGFloat = 300
    @State var currentTime: Int
    let totalTime: Int
    let finishAction: () -> Void
    let stopAction: () -> Void
    let cancelAction: () -> Void
    
    @EnvironmentObject var source: Source
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private var barFrame: CGFloat {
        return CGFloat((1 - (CGFloat(currentTime) / CGFloat(totalTime))) * 308)
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 8) {
                VStack(spacing: 0) {
                    Text("Prepare")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                    
                    Divider()
                    
                    HStack(spacing: 5) {
                        Image("lolipopLeft")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Image(systemName: "clock.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.labelPrimary)
                        Text("\(currentTime / 60) : \(currentTime - (currentTime/60) * 60)")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.labelPrimary)
                        Image("lolipopRight")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .onReceive(timer, perform: { _ in
                        strokeTimer()
                    })
                    
                    Divider()
                    
                    HStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.cSecondary.opacity(0.44))
                            .frame(width: 308, height: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.cPrimary)
                                    .frame(width: max(5, barFrame), height: 5)
                                ,alignment: .leading
                            )
                        Text("\(Int((1 - Double(currentTime) / Double(totalTime)) * 100)) %")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.cPrimary)
                    }
                    .frame(height: 56)
                }
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 14))
                
                Button {
                    withAnimation {
                        offset = 300
                    }
                    source.recipeForPrepare?.currentTime = currentTime
                    finishAction()
                } label: {
                    Text("Finish")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(currentTime > 0 ? .white.opacity(0.4) : .labelPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(currentTime > 0 ? Color.c161161161 : Color.cYellow)
                        .clipShape(.rect(cornerRadius: 14))
                }
                .disabled(currentTime > 0)
                
                if currentTime > 0 {
                    Button {
                        withAnimation {
                            offset = 300
                        }
                        source.recipeForPrepare?.currentTime = currentTime
                        stopAction()
                    } label: {
                        Text("Stop")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white.opacity(0.4))
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.c686868)
                            .clipShape(.rect(cornerRadius: 14))
                    }
                }
                
                Button {
                    withAnimation {
                        offset = 300
                    }
                    cancelAction()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.labelPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white)
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
    
    func strokeTimer() {
        if currentTime >= 1 {
            currentTime -= 1
        }
    }
}

//#Preview {
//    PrepareView(currentTime: 8, finishAction: {}, stopAction: {}) {}
//        .environmentObject(Source())
//}
