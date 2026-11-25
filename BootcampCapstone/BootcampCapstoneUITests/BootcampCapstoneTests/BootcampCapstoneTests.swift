import Foundation
import Testing
@testable import BootcampCapstone

struct BootcampCapstoneTests {
    @Test func productDecodesAPIProductIDAndOptionalFields() throws {
        let json = """
        {
          "productId": 42,
          "name": "Road Helmet",
          "productNumber": "RH-42",
          "listPrice": 79.99
        }
        """.data(using: .utf8)!

        let product = try JSONDecoder().decode(Product.self, from: json)

        #expect(product.id == 42)
        #expect(product.name == "Road Helmet")
        #expect(product.productNumber == "RH-42")
        #expect(product.listPrice == 79.99)
        #expect(product.summary == nil)
    }

    @Test func productEncodingUsesAPIProductIDKey() throws {
        let product = Product(
            id: 7,
            name: "Trail Gloves",
            productNumber: "TG-7",
            color: "Black",
            listPrice: 24.5
        )

        let data = try JSONEncoder().encode(product)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["productId"] as? Int == 7)
        #expect(object["id"] == nil)
        #expect(object["name"] as? String == "Trail Gloves")
        #expect(object["color"] as? String == "Black")
    }

    @Test func productsCompareAndHashByID() {
        let first = Product(id: 3, name: "First", productNumber: "A", listPrice: 1)
        let sameIdentity = Product(id: 3, name: "Renamed", productNumber: "B", listPrice: 2)
        let different = Product(id: 4, name: "First", productNumber: "A", listPrice: 1)

        #expect(first == sameIdentity)
        #expect(first != different)
        #expect(Set([first, sameIdentity, different]).count == 2)
    }

    @Test func loginModelEncodesUsernameAsLoginID() throws {
        let credentials = LoginModel(username: "manager", password: "secret")
        let data = try JSONEncoder().encode(credentials)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: String])

        #expect(object["loginId"] == "manager")
        #expect(object["username"] == nil)
        #expect(object["password"] == "secret")
    }

    @Test func employeeDecodesAPIEmployeeIDAndOptionalFields() throws {
        let json = """
        {
          "employeeId": 17,
          "firstName": "Jack",
          "lastName": "Bool",
          "title": "Mr.",
          "jobTitle": "Sales Rep",
          "department": "Sales"
        }
        """.data(using: .utf8)!

        let employee = try JSONDecoder().decode(Employee.self, from: json)

        #expect(employee.id == 17)
        #expect(employee.firstName == "Jack")
        #expect(employee.lastName == "Bool")
        #expect(employee.jobTitle == "Sales Rep")
        #expect(employee.department == "Sales")
        #expect(employee.shiftHistory?.isEmpty == true)
    }

    @Test func employeeEncodingUsesAPIEmployeeIDKey() throws {
        let employee = Employee(
            id: 23,
            firstName: "Max",
            lastName: "Joe",
            title: "Mx.",
            jobTitle: "Buyer",
            department: "Purchasing"
        )

        let data = try JSONEncoder().encode(employee)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(object["employeeId"] as? Int == 23)
        #expect(object["id"] == nil)
        #expect(object["jobTitle"] as? String == "Buyer")
    }

    @Test func customerOrderDecodesOrderAndProductFields() throws {
        let json = """
        {
          "id": 91,
          "customerId": 12,
          "firstName": "Jamie",
          "lastName": "Taylor",
          "orderNumber": 4801,
          "productId": 55,
          "productName": "Trail Gloves",
          "orderQty": 2,
          "unitPrice": 24.5,
          "lineTotal": 49.0
        }
        """.data(using: .utf8)!

        let order = try JSONDecoder().decode(CustomerOrder.self, from: json)

        #expect(order.id == 91)
        #expect(order.customerId == 12)
        #expect(order.orderNumber == 4801)
        #expect(order.productId == 55)
        #expect(order.productName == "Trail Gloves")
        #expect(order.orderQty == 2)
        #expect(order.lineTotal == 49.0)
    }

    @Test func groupedOrderSumsLineTotalsAndAddsTax() {
        let firstLine = CustomerOrder(
            id: 1,
            customerId: 12,
            firstName: "John",
            lastName: "Doo",
            orderNumber: 4801,
            taxAmt: 3.5,
            productId: 55,
            productName: "Trail Gloves",
            orderQty: 2,
            unitPrice: 24.5,
            lineTotal: 49.0
        )
        
        let secondLine = CustomerOrder(
            id: 2,
            customerId: 12,
            firstName: "John",
            lastName: "Doo",
            orderNumber: 4801,
            taxAmt: 3.5,
            productId: 56,
            productName: "Road Helmet",
            orderQty: 1,
            unitPrice: 79.99,
            lineTotal: 79.99
        )

        let groupedOrder = GroupedOrder(orderNumber: 4801, grouping: [firstLine, secondLine])

        #expect(groupedOrder.subtotal == 128.99)
        #expect(groupedOrder.total == 132.49)
        #expect(groupedOrder.firstName == "John")
        #expect(groupedOrder.customerId == 12)
    }
}
