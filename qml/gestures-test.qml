import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: page
    title: "Gestures-Test"

    Rectangle {
        id: gestureArea
        width: parent.width
        height: parent.height
        color: "white"
        Rectangle {
            id: draggableRect
            width: 400
            height: 400
            color: "grey"

            // Center Initial Position
            Component.onCompleted: {
                x = (parent.width - width) / 2
                y = (parent.height - height) / 2
            }

            transform: Scale {
                id: scaleTransform
                origin.x: draggableRect.width / 2
                origin.y: draggableRect.height / 2
            }

            Image {
                id: image
                source: "../img/exampleCat.jpeg"
                width: parent.width
                height: parent.height
            }

            Text {
                anchors.centerIn: parent
                text: "Use Two Fingers to move"
                color: "white"
                font.pointSize: 20
            }
        }

        PinchHandler {
            target: draggableRect
        }
          
    }
}
