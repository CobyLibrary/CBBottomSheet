import SwiftUI

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isOpen: Bool
    @State private var offsetY: CGFloat
    @State private var dragOffset: CGFloat = 0
    
    private let minHeight: CGFloat
    private let maxHeight: CGFloat
    
    let sheetContent: SheetContent
    
    init(isOpen: Binding<Bool>, startHeight: CGFloat, maxHeight: CGFloat, @ViewBuilder sheetContent: () -> SheetContent) {
        self._isOpen = isOpen
        self._offsetY = State(initialValue: maxHeight - startHeight)
        self.minHeight = startHeight
        self.maxHeight = maxHeight
        self.sheetContent = sheetContent()
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            GeometryReader { geometry in
                if isOpen {
                    VStack {
                        Spacer()
                        
                        VStack {
                            Capsule()
                                .frame(width: 40, height: 6)
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                            
                            self.sheetContent
                        }
                        .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
                        .background(Color.white)
                        .cornerRadius(16)
                        .offset(y: isOpen ? max(self.offsetY + self.dragOffset, 0) : geometry.size.height)
                        .animation(.interactiveSpring(), value: offsetY + dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.dragOffset = value.translation.height
                                }
                                .onEnded { value in
                                    withAnimation(.interactiveSpring()) {
                                        let newHeight = self.offsetY + self.dragOffset
                                        let midHeight = (self.maxHeight - self.minHeight) / 2
                                        
                                        if self.offsetY == self.maxHeight - self.minHeight {
                                            // 현재 시트가 최대 높이에 있을 때
                                            if newHeight > self.maxHeight - self.minHeight {
                                                self.isOpen = false
                                            } else if newHeight > midHeight {
                                                self.offsetY = self.maxHeight - self.minHeight
                                            } else {
                                                self.offsetY = 0
                                            }
                                        } else {
                                            // 현재 시트가 최소 높이에 있을 때
                                            if newHeight > midHeight {
                                                self.offsetY = self.maxHeight - self.minHeight
                                            } else {
                                                self.offsetY = 0
                                            }
                                        }
                                        self.dragOffset = 0
                                    }
                                }
                        )
                    }
                    .edgesIgnoringSafeArea(.all)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isOpen)
                }
            }
        }
    }
}

extension View {
    func bottomSheet<SheetContent: View>(isOpen: Binding<Bool>, startHeight: CGFloat, maxHeight: CGFloat, @ViewBuilder sheetContent: () -> SheetContent) -> some View {
        self.modifier(BottomSheetModifier(isOpen: isOpen, startHeight: startHeight, maxHeight: maxHeight, sheetContent: sheetContent))
    }
}

struct ContentView: View {
    @State private var isBottomSheetOpen = false
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.isBottomSheetOpen.toggle()
                }
            }) {
                Text("Open Bottom Sheet")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
        .bottomSheet(isOpen: $isBottomSheetOpen, startHeight: 500, maxHeight: 700) {
            VStack {
                ForEach(0..<100) { _ in
                    Text("Hello, World!")
                        .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
