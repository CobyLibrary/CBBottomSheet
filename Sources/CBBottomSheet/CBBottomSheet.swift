import SwiftUI

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isOpen: Bool
    @State private var offsetY: CGFloat
    @State private var dragOffset: CGFloat = 0
    
    private let minHeight: CGFloat
    private let maxHeight: CGFloat
    private var sheetHeight: CGFloat {
        self.maxHeight - max(self.offsetY + self.dragOffset, 0)
    }
    
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
                                .padding(.bottom, self.maxHeight - self.sheetHeight)
                        }
                        .frame(width: geometry.size.width, height: self.sheetHeight, alignment: .top)
                        .background(Color.white)
                        .cornerRadius(16)
                        .offset(y: isOpen ? max(self.offsetY + self.dragOffset, 0) : geometry.size.height)
                        .animation(.interactiveSpring(), value: offsetY + dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.height > 50 || value.translation.height < -50 {
                                        self.dragOffset = value.translation.height
                                    }
                                    
                                    print("offsetY: \(offsetY)")
                                    print("dragOffset: \(dragOffset)")
                                    print("sheetHeight: \(sheetHeight)")
                                    print("--------------------------")
                                }
                                .onEnded { value in
                                    withAnimation {
                                        let newHeight = self.offsetY + self.dragOffset
                                        let midHeight = (self.maxHeight - self.minHeight) / 2
                                        
                                        if self.offsetY == self.maxHeight - self.minHeight {
                                            if self.dragOffset > 100 {
                                                self.isOpen = false
                                            } else if newHeight > midHeight {
                                                self.offsetY = self.maxHeight - self.minHeight
                                            } else {
                                                self.offsetY = 0
                                            }
                                        } else {
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
    public func bottomSheet<SheetContent: View>(isOpen: Binding<Bool>, startHeight: CGFloat, maxHeight: CGFloat, @ViewBuilder sheetContent: () -> SheetContent) -> some View {
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
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<20) { _ in
                        Text("Hello, World!")
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.brown)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
