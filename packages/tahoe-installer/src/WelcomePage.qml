import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle { color: "transparent" }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        
        Image {
            source: "/usr/share/tahoeos/logo.png"
            Layout.alignment: Qt.AlignHCenter
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 120
        }
        
        Label {
            text: "Welcome to TahoeOS"
            font.pixelSize: 32
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Let's get your system set up"
            font.pixelSize: 16
            color: "#a0a0a0"
            Layout.alignment: Qt.AlignHCenter
        }
        
        ComboBox {
            id: languageBox
            model: ["English", "Español", "Français", "Deutsch", "日本語", "中文"]
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 200
        }
    }
}
