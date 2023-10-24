import QtQuick 2.15
import QtQuick.Controls 2.15
import MyApp 1.0

Page {
    id: page
    title: "Multitouch-Test-C++"

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
            text: "Touch Points: " + parent.numberOfTouches
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
                color: "red"
                visible: false
            }
        }

        Component.onCompleted: {
            for (var i = 0; i < 10; ++i) {
                var ellipse = ellipseComponent.createObject(touchArea);
                touchArea.ellipses.push(ellipse);
            }
        }

        TouchPointItem {
            width: parent.width
            height: parent.height

            onTouchPointsUpdated: {
                // for (var i = 0; i < points.length; i++) {
                //     console.log("Touch point: " + points[i].x + ", " + points[i].y);
                //     // Do something with the touch points
                // }
                touchArea.numberOfTouches = points.length
                for (var i = 0; i < points.length; ++i) {
                    touchArea.ellipses[i].visible = true;
                    touchArea.ellipses[i].x = points[i].x - touchArea.ellipses[i].width / 2;
                    touchArea.ellipses[i].y = points[i].y - touchArea.ellipses[i].height / 2;
                }
                for (var j = points.length; j < touchArea.ellipses.length; ++j) {
                    touchArea.ellipses[j].visible = false;
                }
            }
        }
    }
}
