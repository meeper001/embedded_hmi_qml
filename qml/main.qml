import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import "screenMetaData.js" as Meta

// Main application window
ApplicationWindow {
    // Set the window to be visible and fullscreen
    id: window
    visible: true
    visibility: Window.FullScreen
    title: "QML-TESTAPP"

    property string currentTitle

    Column {
        anchors.fill: parent

        // Navigation Bar
        Rectangle {
            id: navbar
            width: parent.width
            height: 50
            z: 1 // Keep On Top
            color: "darkred"
            property string textcolor: "white"

            // Back Button
            Button {
                // Show button only if main screen is not displayed
                visible: stackView.depth > 1 
                height: parent.height
                contentItem: Text {
                    height: parent.height 
                    anchors.centerIn: parent
                    text: "back"
                    color: navbar.textcolor
                    font.pixelSize: parent.height * 0.3
                    verticalAlignment: Text.AlignVCenter 
                }
                background: Rectangle {
                    color: parent.down ? "gray" :  "transparent"
                }
                anchors.left: parent.left
                onClicked: stackView.pop(stackView.get(0))
            }

            // Close button
            Button {
                height: parent.height
                anchors.right: parent.right
                background: Rectangle {
                    color: parent.down ? "gray" :  "black"
                }
                contentItem: Text {
                    height: parent.height 
                    anchors.centerIn: parent 
                    text: "exit"
                    color: navbar.textcolor
                    font.pixelSize: parent.height * 0.3
                    verticalAlignment: Text.AlignVCenter 
                }
                onClicked: {
                    Qt.quit();  // Close the application when the button is clicked
                }
            }

            // Title Text
            Text {
                height: parent.height // Give it the full height to align text vertically
                anchors.centerIn: parent // This positions the text in the center of the Rectangle
                text: "QML | " + currentTitle + " | RAM: " + Math.round(sysInfo.getMemoryUsage()/1000) + " MB | FPS: " + fpsmonitor.freq
                color: navbar.textcolor
                font.pixelSize: parent.height * 0.4
                verticalAlignment: Text.AlignVCenter // Vertically center-align text
            }

        }

        // StackView for Pages
        StackView {
            pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
                }
            }
            pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 200
                }  
            }
            popEnter: Transition {
                PropertyAnimation {
                property: "opacity"
                from: 0
                to:1
                duration: 200
                    }
            }
            popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to:0
                duration: 200
                }
            }

            id: stackView
            height: parent.height - 50
            width: parent.width
            initialItem: mainScreen
            onCurrentItemChanged: {
                // Update the title when the current item changes
                currentTitle = currentItem ? currentItem.title : "";
            }
        }
    }

    // App Selector
    Component {
        id: mainScreen

        Page {
            title: "Home"
            property int appmargin: 60

            Rectangle { // Background color
                color: "white"
                anchors.fill: parent
            }

            ListView {
                id: appListView
                orientation: ListView.Horizontal
                anchors.fill: parent
                model: Math.ceil(Meta.screenMetadata.length / 8) // Calculate number of pages required

                // Make the pages Snap
                Behavior on contentX {
                    NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
                }

                onMovementEnded: {
                    var targetPage = Math.round(contentX / window.width); // Calculate which page we are closest to
                    targetPage = Math.min(Math.max(targetPage, 0), model - 1);  // Limit the target page to be within valid bounds
                    contentX = targetPage * window.width;
                }

                delegate: Item {
                    width: appListView.width  // Minus margins on both sides
                    height: appListView.height  // Minus margins on both sides
                    property int itemIndex: index // Save outer Index

                    GridLayout {
                        id: appgrid
                        anchors.fill: parent
                        anchors.margins: appmargin  // Outer Margin
                        //anchors.topMargin: appmargin - 0
                        columns: 4
                        rows: 2
                        columnSpacing: appmargin
                        rowSpacing: appmargin

                        Repeater {
                            model: appgrid.columns * appgrid.rows

                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true

                                width: height
                                
                                Button {
                                    anchors.fill: parent
                                    
                                    property int globalIndex: index + appgrid.columns * appgrid.rows * itemIndex
                                    // Check if an app should be displayed in this slot
                                    property bool shouldDisplay: globalIndex < Meta.screenMetadata.length
                                    property string currentTitle: shouldDisplay ? Meta.screenMetadata[globalIndex].title : ""
                                    property string currentUrl: shouldDisplay ? Meta.screenMetadata[globalIndex].url : ""
                                    property string iconUrl: shouldDisplay ? Meta.screenMetadata[globalIndex].icon:  ""
                                    visible: shouldDisplay

                                    contentItem: Text {
                                        text: parent.currentTitle
                                        color: "black"
                                        font.pixelSize: 20
                                        anchors.top: parent.bottom
                                        anchors.topMargin: 10
                                        horizontalAlignment: Text.AlignHCenter 
                                    }
                                        
                                    background: Rectangle {
                                        color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                                        height: 191
                                        width: 191
                                        radius: 33
                                        clip: true
                                        border.width: 3
                                        border.color: "black"

                                        Image {
                                            id: backgroundImage
                                            anchors.centerIn: parent
                                            //height: parent.height-5
                                            //width: parent.width-5
                                            source:  parent.parent.iconUrl ? "../img/"+ parent.parent.iconUrl: "" 
                                        }
                                    }

                                    onClicked: {
                                        if (currentUrl !== "") {
                                            stackView.push(Qt.resolvedUrl(currentUrl))
                                        }
                                        //console.log(width)
                                        //console.log(height)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
