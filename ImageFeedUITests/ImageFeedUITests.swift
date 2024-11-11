//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Anastasiia Ki on 10.11.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        // тестируем сценарий авторизации
        
        app.buttons["Authenticate"].tap()
        
        // Подождать, пока экран авторизации открывается и загружается
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        // Ввести данные в форму
        let loginTextField = webView.descendants(matching: .textField).element
        loginTextField.tap()
        loginTextField.typeText("email@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        passwordTextField.tap()
        passwordTextField.typeText("password")
        webView.swipeUp()
        
        // Нажать кнопку логина
        let button = webView.buttons["Login"]
        button.tap()
        
        // Подождать, пока открывается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // тестируем сценарий ленты
        
        // Подождать, пока открывается и загружается экран ленты
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        // Сделать жест «смахивания» вверх по экрану для его скролла
        cell.swipeUp()
        sleep(3)
        
        // Поставить лайк в ячейке верхней картинки
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["Like_Button"].tap()
        sleep(2)
        
        // Отменить лайк в ячейке верхней картинки
        cellToLike.buttons["Like_Button"].tap()
        sleep(2)
        
        // Нажать на верхнюю ячейку
        cellToLike.tap()
        
        // Подождать, пока картинка открывается на весь экран
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        // Увеличить картинку
        image.pinch(withScale: 3, velocity: 1)
        sleep(2)
        
        // Уменьшить картинку
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(1)
        
        // Вернуться на экран ленты
        let button = app.buttons["Back_Button"]
        button.tap()
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
        
        // Подождать, пока открывается и загружается экран ленты
        sleep(3)
        
        // Перейти на экран профиля
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        
        // Проверить, что на нём отображаются ваши персональные данные
        XCTAssertTrue(app.staticTexts["firstName + lastName"].exists)
        XCTAssertTrue(app.staticTexts["loginName"].exists)
        
        // Нажать кнопку логаута
        app.buttons["Logout_Button"].tap()
        sleep(2)

        // Проверить, что открылся экран авторизации
        app.alerts["Alert"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
    }
}
