import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle { color: "transparent" }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30
        
        Image {
            source: "/usr/share/tahoeos/logo.png"
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 100
        }
        
        Label {
            text: "Welcome to TahoeOS"
            font.pixelSize: 32
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Your system is ready to use"
            font.pixelSize: 16
            color: "#a0a0a0"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Rectangle {
            Layout.preferredWidth: 400
            Layout.preferredHeight: 1
            color: "#444"
            Layout.alignment: Qt.AlignHCenter
        }
        
        GridLayout {
            columns: 2
            columnSpacing: 40
            rowSpacing: 15
            Layout.alignment: Qt.AlignHCenter
            
            Label { text: "Finder"; color: "#89b4fa" }
            Label { text: "Browse your files"; color: "#a0a0a0" }
            
            Label { text: "System Preferences"; color: "#89b4fa" }
            Label { text: "Configure your system"; color: "#a0a0a0" }
            
            Label { text: "App Store"; color: "#89b4fa" }
            Label { text: "Discover new apps"; color: "#a0a0a0" }
            
            Label { text: "Steam"; color: "#89b4fa" }
            Label { text: "Play your games"; color: "#a0a0a0" }
        }
    }
}
