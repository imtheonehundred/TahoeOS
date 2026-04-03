import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle { color: "transparent" }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        
        Label {
            text: "Connect to Wi-Fi"
            font.pixelSize: 28
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Select a network to connect"
            color: "#a0a0a0"
            Layout.alignment: Qt.AlignHCenter
        }
        
        ListView {
            Layout.preferredWidth: 400
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignHCenter
            model: ["Home WiFi", "Office Network", "Guest Network"]
            delegate: ItemDelegate {
                width: parent.width
                text: modelData
                icon.name: "network-wireless"
            }
        }
        
        Button {
            text: "Skip for now"
            flat: true
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
