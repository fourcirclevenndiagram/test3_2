import SwiftUI
import Combine

// 도형 모델 정의
struct ShapeModel: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
}

// ViewModel 정의
class ShapesViewModel: ObservableObject {
    @Published var shapes: [ShapeModel] = []
    @Published var score: Int = 0
    
    private var timer: AnyCancellable?
    private let shapeCount = 20
    
    init() {
        generateShapes()
        startTimer()
    }
    
    private func generateShapes() {
        for _ in 0..<shapeCount {
            let shape = ShapeModel(
                position: CGPoint(x: CGFloat.random(in: 0...300), y: CGFloat.random(in: 0...600)),
                size: CGFloat.random(in: 30...100),
                color: Color.random()
            )
            shapes.append(shape)
        }
    }
    
    private func startTimer() {
        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink { _ in
            self.moveShapes()
        }
    }
    
    private func moveShapes() {
        for index in shapes.indices {
            shapes[index].position.x += CGFloat.random(in: -20...20)
            shapes[index].position.y += CGFloat.random(in: -20...20)
            
            if shapes[index].position.x < 0 { shapes[index].position.x = 0 }
            if shapes[index].position.x > 300 { shapes[index].position.x = 300 }
            if shapes[index].position.y < 0 { shapes[index].position.y = 0 }
            if shapes[index].position.y > 500 { shapes[index].position.y = 500 }
        }
        score += 1
    }
}

// 랜덤 색상 생성
extension Color {
    static func random() -> Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

// ContentView 정의
struct ContentView: View {
    @ObservedObject var viewModel = ShapesViewModel()
    
    var body: some View {
        ZStack {
            ForEach(viewModel.shapes) { shape in
                Circle()
                    .fill(shape.color)
                    .frame(width: shape.size, height: shape.size)
                    .position(shape.position)
            }
            
            VStack {
                Spacer()
                Text("Score: \(viewModel.score)")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

// 미리보기 설정
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
