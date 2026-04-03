import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Page {
    background: Rectangle { color: "transparent" }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: 400
        
        Label {
            text: "Create Your Account"
            font.pixelSize: 28
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Rectangle {
            width: 80
            height: 80
            radius: 40
            color: "#667eea"
            Layout.alignment: Qt.AlignHCenter
            
            Label {
                anchors.centerIn: parent
                text: "👤"
                font.pixelSize: 32
            }
        }
        
        TextField {
            placeholderText: "Full Name"
            Layout.fillWidth: true
        }
        
        TextField {
            placeholderText: "Username"
            Layout.fillWidth: true
        }
        
        TextField {
            placeholderText: "Password"
            echoMode: TextInput.Password
            Layout.fillWidth: true
        }
        
        TextField {
            placeholderText: "Confirm Password"
            echoMode: TextInput.Password
            Layout.fillWidth: true
        }
    }
}
