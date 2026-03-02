import QtQuick
import Box2D 2.0

Rectangle {
    id: root

    required property World world
             property Item selected

    color: "lightgreen"

    Component {
        id: circleComponent

        Rectangle {
            id: circle

            required property QtObject model
            required property int index

            required property real circleRadius
            required property real centerX
            required property real centerY

                     property alias bodyType: body.bodyType
                     property bool created

            x: centerX - circleRadius
            y: centerY - circleRadius
            radius: circleRadius
            width: 2 * radius
            height: width

            color: root.selected === this ? "coral" : "pink"
            border.color: "red"
            border.width: 2

            Body {
                id: body

                active: created && !dragHandle.drag.active
                bodyType: Body.Dynamic
                target: circle
                fixtures: Circle {
                    id: circleShape

                    radius: circle.circleRadius

                    density: 0.1
                    friction: 0.3
                    restitution: 0.5
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: (mouse) => {
                    switch (mouse.button) {
                        case Qt.LeftButton:
                            root.selected = circle
                            break;

                        case Qt.RightButton:
                            circlesModel.remove(index)
                            break;

                        default:
                            break;
                    }
                }
            }

            Rectangle {
                anchors.centerIn: parent

                width: 30
                height: width
                color: "#88888888"
                border.width: 1
                border.color: "lightblue"

                MouseArea {
                    id: dragHandle

                    anchors.fill: parent
                    cursorShape: Qt.DragMoveCursor
                    drag.target: circle
                }
            }

            Text {
                anchors.centerIn: parent

                text: circle.circleRadius.toFixed(2)
                rotation: -parent.rotation
            }
        }
    }

    Instantiator {
        id: spawner

        delegate: circleComponent
        model: ListModel {id: circlesModel}

        onObjectAdded: (index, object) => {
            object.parent = root.parent
        }
    }

    MouseArea {
        property point origin

        function getRadius(mouse) {
            let deltaX = mouse.x - origin.x
            let deltaY = mouse.y - origin.y
            return Math.sqrt(deltaX * deltaX + deltaY * deltaY)
        }

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                root.selected = null

                origin.x = mouse.x
                origin.y = mouse.y
                spawner.model.append({"circleRadius": getRadius(mouse), "centerX": mouse.x, "centerY": mouse.y})
            }
        }

        onPositionChanged: (mouse) => {
            if (mouse.buttons & Qt.LeftButton) {
                spawner.objectAt(spawner.count - 1).circleRadius = getRadius(mouse)
            }
        }

        onReleased: (mouse) => {
            if (mouse.button === Qt.LeftButton) {if (getRadius(mouse) <= 10) {
                    spawner.model.remove(spawner.count - 1)
                } else {
                    spawner.objectAt(spawner.count - 1).created = true
                }
            }
        }
    }
}
