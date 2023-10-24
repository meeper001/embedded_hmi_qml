import QtQuick 2.15
import QtQuick.Controls 2.15


Page {
    id: page
    title: "Animation Performance Test"

    property bool enableMovement: true
    property bool enableRotation: false
    property bool enableScaling: false
    property bool enableOpacity: true

    
    Rectangle {
        width: parent.width
        height: parent.height
        color: "white"
        

        // Create a repeater to generate multiple moving images
        Repeater {
            id: repeater
            model: slider.value // Number of images

            delegate: Image {
                id: imageDelegate
                source: "../img/exampleCat" // Replace with your image path
                width: 50
                height: 50
                opacity: page.enableOpacity ? Math.random() : 1.0

                // Initial position
                x: Math.random() * parent.width
                y: Math.random() * parent.height

                function randomRange(min, max) {
                    return Math.random() * (max - min) + min;
                }

                function updateAnimations() {
                    anim.animations = [];
                    if (enableMovement) {
                        anim.animations.push(anim_x);
                        anim.animations.push(anim_y);
                    }
                    if (enableScaling) {
                        anim.animations.push(anim_scale);
                    }
                    if (enableRotation) {
                        anim.animations.push(anim_rotation);
                    }
                    anim.restart();
                }

                Timer {
                    interval: randomRange(1000, 3000)
                    running: true
                    repeat: true
                    onTriggered: {
                        anim.running = false
                        anim_x.to = Math.random() * page.width;
                        anim_y.to = Math.random() * page.height;
                        anim.running = true
                    }
                }

                // Moving and scaling animations
                Component.onCompleted: {
                    updateAnimations();
                }

                ParallelAnimation {
                    id: anim
                    loops: Animation.Infinite
                }

                PropertyAnimation {
                    id: anim_x
                    target: imageDelegate
                    property: "x"
                    duration: randomRange(1000, 3000)
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    id: anim_y
                    target: imageDelegate
                    property: "y"
                    duration: randomRange(1000, 3000)
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    id: anim_scale
                    target: imageDelegate
                    property: "scale"
                    to: randomRange(0.1, 5)
                    duration: randomRange(1000, 3000)
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    id: anim_rotation
                    target: imageDelegate
                    property: "rotation"
                    to: rotation + 360
                    duration: randomRange(1000, 3000)
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Controls
        Column {
            anchors.fill: parent
            spacing: 5

            Row {
                id: row
                spacing: 10

                Slider {
                    id: slider
                    from: 1
                    to: 200
                    value: 20
                    stepSize: 1
                    anchors.verticalCenter: row.verticalCenter  // Vertical alignment for the Slider
                }

                Label {
                    text: "Images: " + slider.value
                    anchors.verticalCenter: row.verticalCenter  // Vertical alignment for the Label
                }
            }
            
            CheckBox {
                id: movementCheckbox
                text: "Enable Movement"
                checked: page.enableMovement
                onCheckedChanged: {
                    page.enableMovement = checked;
                    for (var i = 0; i < repeater.count; i++) {
                        var img = repeater.itemAt(i);
                        img.updateAnimations();
                    }
                }
            }

            CheckBox {
                id: rotationCheckbox
                text: "Enable Rotation"
                checked: page.enableRotation
                onCheckedChanged: {
                    page.enableRotation = checked;
                    for (var i = 0; i < repeater.count; i++) {
                        var img = repeater.itemAt(i);
                        if (checked == false)
                        {
                            img.rotation = 0
                        }
                        img.updateAnimations();
                    }
                }
            }

            CheckBox {
                id: scalingCheckbox
                text: "Enable Scaling"
                checked: page.enableScaling
                onCheckedChanged: {
                    page.enableScaling = checked;
                    for (var i = 0; i < repeater.count; i++) {
                        var img = repeater.itemAt(i);
                        if (checked == false)
                        {
                            img.scale = 1.0
                        }
                        img.updateAnimations();
                    }
                }
            }

            CheckBox {
                id: opacityCheckbox
                text: "Enable Opacity"
                checked: page.enableOpacity
                onCheckedChanged: {
                    page.enableOpacity = checked;
                }
            }
            
        }
    }
}
