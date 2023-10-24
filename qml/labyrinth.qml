import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: page
    title: "Labyrinth"

    Rectangle {
        id: touchArea
        width: parent.width
        height: parent.height
        color: "white"

        Image {
            id: image
            source: "../img/labyrinth"
            height: parent.height
            width: sourceSize.width * parent.height/sourceSize.height
            anchors.right: parent.right
            smooth: false
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            x: 100
            text: "LABYRINTH\ntouch to draw"
            color: "black"
            font.pixelSize: 40
        }

        Canvas {
            id: canvas
            anchors.fill: parent

            property real lastX: -1
            property real lastY: -1
            property real currentX: 0
            property real currentY: 0

            onPaint: {
                var ctx = getContext("2d");
                ctx.strokeStyle = "blue";
                ctx.lineWidth = 2;

                if (lastX !== -1 && lastY !== -1) {
                    ctx.beginPath();
                    ctx.moveTo(lastX, lastY);
                    ctx.lineTo(currentX, currentY);
                    ctx.stroke();
                }

                lastX = currentX;
                lastY = currentY;
            }
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                canvas.lastX = mouseX;
                canvas.lastY = mouseY;
            }

            onPositionChanged: {
                canvas.currentX = mouseX;
                canvas.currentY = mouseY;
                canvas.requestPaint();
            }

            onReleased: {
                canvas.lastX = -1;
                canvas.lastY = -1;
            }
        }
    }

    Button {
        text: "Reset Canvas"
        anchors.bottom: parent.bottom
        onClicked: {
            // Clear the canvas
            var ctx =  canvas.getContext("2d");
            ctx.reset();
            canvas.requestPaint();
        }
    }
}
