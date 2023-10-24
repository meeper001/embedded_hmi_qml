import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: page
    title: "Multitouch-Test"

    Rectangle {
        id: touchArea
        width: parent.width
        height: parent.height
        color: "lightgray"

        property int numberOfTouches: 0
        property var ellipses: []

        // Text to display the number of touch points
        Text {
            anchors {
                top: parent.top
                right: parent.right
            }
            text: "Touch Points: " + touchArea.numberOfTouches
            color: "black"
            font.pixelSize: 20
        }

        // Start Text
        Text {
            id:startText
            anchors.centerIn: parent 
            text: "TOUCH TO START"
            color: "white"
            font.pixelSize: 40
            visible: parent.numberOfTouches == 0
        }

        Component {
            id: ellipseComponent

            Rectangle {
                width: 40
                height: 40
                radius: 20
                color: "blue"
                visible: false
            }
        }

        Component.onCompleted: {
            for (var i = 0; i < 10; ++i) {
                var ellipse = ellipseComponent.createObject(touchArea);
                touchArea.ellipses.push(ellipse);
            }
        }

        MultiPointTouchArea {
            id: multiPointTouchArea
            anchors.fill: parent

            minimumTouchPoints: 1
            maximumTouchPoints: 5

            onTouchUpdated: {
                touchArea.numberOfTouches = touchPoints.length
                for (var i = 0; i < touchPoints.length; ++i) {
                    touchArea.ellipses[i].visible = true;
                    touchArea.ellipses[i].x = touchPoints[i].x - touchArea.ellipses[i].width / 2;
                    touchArea.ellipses[i].y = touchPoints[i].y - touchArea.ellipses[i].height / 2;
                }
                for (var j = touchPoints.length; j < touchArea.ellipses.length; ++j) {
                    touchArea.ellipses[j].visible = false;
                }
            }
        }
    }
}
