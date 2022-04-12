//
//  TutorialView.swift
//  TaskManagmentCoreData
//
//  Created by Максим Чесников on 12.04.2022.
//

import SwiftUI

struct TutorialView: View {
    
    @State var screenState = true
    
    var body: some View {
        UIOnboardingView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

import SwiftUI
import UIOnboarding
import UserNotifications

struct UIOnboardingView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIOnboardingViewController
    
    func makeUIViewController(context: Context) -> UIOnboardingViewController {
        let onboardingController: UIOnboardingViewController = .init(withConfiguration: .setUp())
        onboardingController.delegate = context.coordinator
        return onboardingController
    }
    
    func updateUIViewController(_ uiViewController: UIOnboardingViewController, context: Context) {}
    
    class Coordinator: NSObject, UIOnboardingViewControllerDelegate {
        
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        func didFinishOnboarding(onboardingViewController: UIOnboardingViewController) {
            notificationCenter.requestAuthorization(options: options) {
                (didAllow, error) in
                DispatchQueue.main.async {
                    onboardingViewController.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return .init()
    }
}

extension UIOnboardingViewConfiguration {
    //UIOnboardingViewController init
    static func setUp() -> UIOnboardingViewConfiguration {
        return .init(appIcon: Bundle.main.appIcon ?? .init(named: "onboarding-icon")!,
                     welcomeTitle: NSMutableAttributedString(string: "Welcome to Расписание".localizationString),
                     features: [
                        .init(icon: UIImage(systemName: "doc.text.fill")!, title: "Создавай задачи на каждый день!".localizationString, description: "Просто откройте приложение и начните создавать задачи. Никаких выборов и сложных манипуляций от вас не требуется. Просто открой и создай!".localizationString),
                        .init(icon: UIImage(systemName: "flame.fill")!, title: "Приоритеты".localizationString, description: "Поставьте задачам приоритеты и вам будет удобно выбирать в каком порядке их выполнять.".localizationString),
                        .init(icon: UIImage(systemName: "repeat")!, title: "Автоповтор".localizationString, description: "Поставьте задачи на автоповтор и создайте удобное расписание на дни вперед!".localizationString),
                        .init(icon: UIImage(systemName: "alarm.fill")!, title: "Уведомления".localizationString, description: "Наши уведомления помогут вам вовремя выполнять поставленные цели!".localizationString)
                     ],
                     textViewConfiguration: .init(icon: UIImage(systemName: "person.3.fill")!, text: "Мы не отправляем ваши данные. Все ваши задачи хранятся на устройстве!".localizationString),
                     buttonConfiguration: .init(title: "Далее".localizationString, backgroundColor: .blue))
    }
}
