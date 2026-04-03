import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle { color: "transparent" }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        
        Label {
            text: "Select Your Region"
            font.pixelSize: 28
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        ComboBox {
            id: regionBox
            model: ["United States", "United Kingdom", "Canada", "Australia", "Germany", "France", "Japan"]
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 300
        }
        
        ComboBox {
            id: keyboardBox
            model: ["US English", "UK English", "German", "French", "Japanese"]
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 300
        }
    }
}
