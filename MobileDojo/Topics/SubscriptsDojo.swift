import SwiftUI

// Subscripts
//   a. Documentation > Cmd + Click
//   b. Convenient but maybe not safe
struct SubscriptsDojo: View {
    let myArray = ["Element 1️⃣", "Element 2️⃣", "Element 3️⃣"]
    @State var selectedElement: String? = nil

    var body: some View {
        VStack {
            ForEach(myArray, id: \.self) { element in
                Text(element)
            }

            Text("Selected element: \(selectedElement ?? "None")")
                .padding(.vertical, 10)

            SubscriptMatrixView()
        }
        .onAppear {
            selectedElement = myArray["ele"]
        }
    }
}

#Preview {
    SubscriptsDojo()
}

// `getItem` for Array
extension Array {
    // Safer but O(n) time complexity
    func getItem(atIndex: Int) -> Element? {
        for (index, element) in self.enumerated() {
            if index == atIndex {
                return element
            }
        }
        return nil
    }
}

// `safe` index subscript for Array
extension Array {
    // Safer and O(1)
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// simple subscript for Array of String
extension Array where Element == String {
    // Convenient and cool but not common,
    // and can be confusing for newbies to the project
    subscript(str: String) -> Element? {
        self.first(where: { $0.contains(str) })
    }
}



// index subscript for a custom type
struct SubscriptMatrixView: View {
    @State var matrix = Matrix(rows: 3, columns: 4)
    var body: some View {
        Text("\(matrix[0,1] ?? -1)")
            .onAppear(perform: {
                print(matrix.data)
            })
            .task {
                try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                matrix[0,1] = 9
                print(matrix.data)
            }
    }
}

struct Matrix {
    var data = [[Int]]()

    init(rows: Int, columns: Int) {
        for row in 0..<rows {
            var rowData = [Int]()
            for column in 0..<columns {
                rowData.append(row + column)
            }
            data.append(rowData)
        }
    }

    //lets make a subscript with get and set
    subscript(row: Int, column: Int) -> Int? {
        get {
            guard data.indices.contains(row),
                  data[row].indices.contains(column) else { return nil }
            return data[row][column]
        }
        set {
            guard let newValue else { return }
            data[row][column] = newValue
        }
    }
}


//Prompts:
//* explain O(1) vs O(n) for an array collection for example
//* assuming an array has 100 elements, why array[99] is O(1) and not O(n)?
//* what is the O of indices.contains(index) for an array?
