import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle { color: "transparent" }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: 500
        
        Label {
            text: "Privacy"
            font.pixelSize: 28
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "TahoeOS respects your privacy. No data is collected."
            color: "#a0a0a0"
            Layout.alignment: Qt.AlignHCenter
            wrapMode: Text.WordWrap
        }
        
        Rectangle {
            Layout.fillWidth: true
            height: 200
            color: "rgba(255,255,255,0.1)"
            radius: 12
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                RowLayout {
                    Layout.fillWidth: true
                    Label { text: "Location Services"; color: "white" }
                    Item { Layout.fillWidth: true }
                    Switch { checked: false }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    Label { text: "Analytics"; color: "white" }
                    Item { Layout.fillWidth: true }
                    Switch { checked: false }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    Label { text: "Automatic Updates"; color: "white" }
                    Item { Layout.fillWidth: true }
                    Switch { checked: true }
                }
            }
        }
    }
}
