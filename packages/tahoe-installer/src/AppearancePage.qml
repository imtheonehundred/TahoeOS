import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle { color: "transparent" }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30
        
        Label {
            text: "Choose Your Look"
            font.pixelSize: 28
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        RowLayout {
            spacing: 40
            Layout.alignment: Qt.AlignHCenter
            
            Rectangle {
                width: 150
                height: 100
                radius: 12
                color: "#f0f0f0"
                border.color: lightMode.checked ? "#667eea" : "transparent"
                border.width: 3
                
                Label {
                    anchors.centerIn: parent
                    text: "Light"
                    color: "#333"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: lightMode.checked = true
                }
            }
            
            Rectangle {
                width: 150
                height: 100
                radius: 12
                color: "#1e1e2e"
                border.color: darkMode.checked ? "#667eea" : "#444"
                border.width: 3
                
                Label {
                    anchors.centerIn: parent
                    text: "Dark"
                    color: "white"
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: darkMode.checked = true
                }
            }
        }
        
        ButtonGroup {
            id: themeGroup
            buttons: [lightMode, darkMode]
        }
        RadioButton { id: lightMode; visible: false }
        RadioButton { id: darkMode; visible: false; checked: true }
        
        Label {
            text: "Accent Color"
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        RowLayout {
            spacing: 15
            Layout.alignment: Qt.AlignHCenter
            
            Repeater {
                model: ["#667eea", "#f38ba8", "#a6e3a1", "#f9e2af", "#89b4fa", "#f5c2e7"]
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: modelData
                    border.color: "white"
                    border.width: 2
                }
            }
        }
    }
}
