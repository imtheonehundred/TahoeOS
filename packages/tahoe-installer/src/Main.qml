import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 600
    title: "Welcome to TahoeOS"
    color: "#1a1a2e"
    
    property int currentPage: 0
    property var pages: ["welcome", "region", "wifi", "account", "appearance", "privacy", "complete"]
    
    StackLayout {
        id: stack
        anchors.fill: parent
        currentIndex: currentPage
        
        WelcomePage {}
        RegionPage {}
        WifiPage {}
        AccountPage {}
        AppearancePage {}
        PrivacyPage {}
        CompletePage {}
    }
    
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        
        Button {
            text: "Back"
            visible: currentPage > 0 && currentPage < pages.length - 1
            onClicked: currentPage--
        }
        
        Item { Layout.fillWidth: true }
        
        PageIndicator {
            count: pages.length
            currentIndex: currentPage
        }
        
        Item { Layout.fillWidth: true }
        
        Button {
            text: currentPage === pages.length - 1 ? "Get Started" : "Continue"
            highlighted: true
            onClicked: {
                if (currentPage < pages.length - 1) {
                    currentPage++
                } else {
                    Qt.quit()
                }
            }
        }
    }
}
