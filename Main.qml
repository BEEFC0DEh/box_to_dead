import QtQuick
import Box2D 2.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Rectangle {
        id: ball

        width: 20
        height: 20
        radius: width / 2
        border.color: "blue"
        color: "#EFEFEF"
        x: 300
        y: 0

        Body {
            id: body

            world: physicsWorld
            bodyType: Body.Dynamic

            Circle {
                id: circle
                radius: ball.radius
                density: 0.1
                friction: 0.3
                restitution: 0.5
            }
        }
    }

    World { id: physicsWorld }

    Rectangle {
        id: ground

        property var polygon: [
            Qt.point(0, 0),
            Qt.point(width * 0.5, height * 0.75),
            Qt.point(width, 0),
            Qt.point(width, height),
            Qt.point(0, height)
        ]

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        height: 100
        color: "lightgray"
        z: -1

        onWidthChanged: polygonUpdater.restart()
        onHeightChanged: polygonUpdater.restart()
        onXChanged: polygonUpdater.restart()
        onYChanged: polygonUpdater.restart()

        Timer {
            id: polygonUpdater

            interval: 0
            running: false
            onTriggered: groundShape.setVertices()
        }

        Body {
            world: physicsWorld

            fixtures: Chain {
                id: groundShape

                function setVertices() {
                    vertices = ground.polygon.map((point) => Qt.point(point.x + ground.x, point.y + ground.y))
                    console.log(vertices)
                }

                loop: true
            }
        }

        Canvas {
            id: groundCanvas

            anchors.fill: parent

            onPaint: {
                let context = getContext("2d")
                context.beginPath()
                context.moveTo(0, 0)
                let points = ground.polygon
                for (let i = 1; i < points.length; i++) {
                    let point = points[i]
                    let x = point.x
                    let y = point.y
                    context.lineTo(x, y)
                    context.strokeRect(x - 5, y - 5, 10, 10)
                }
                context.strokeStyle = "#000000"
                context.fill()

                context.strokeStyle = "#8888FF"
                for (let i = 1; i < points.length; i++) {
                    let point = points[i]
                    let x = point.x
                    let y = point.y
                    context.strokeRect(x - 5, y - 5, 10, 10)
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: (mouse) => {
                if (mouse.button === Qt.RightButton) {
                    ground.polygon.push(Qt.point(mouse.x, mouse.y))
                    groundCanvas.requestPaint()
                    groundShape.setVertices()
                }
            }

            onPressed: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    selection.origin.x = mouse.x
                    selection.origin.y = mouse.y
                    selection.x = mouse.x
                    selection.y = mouse.y
                    selection.visible = true
                }
            }

            onPositionChanged: (mouse) => {
                if (mouse.buttons & Qt.LeftButton) {
                    let width = mouse.x - selection.origin.x
                    let height = mouse.y - selection.origin.y

                    if (width >= 0) {
                        selection.width = width
                    } else {
                        selection.x = selection.origin.x + width
                        selection.width = -width
                    }

                    if (height >= 0) {
                        selection.height = height
                    } else {
                        selection.y = selection.origin.y + height
                        selection.height = -height
                    }
                }
            }

            onReleased: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    selection.visible = false
                }
            }

            Rectangle {
                id: selection

                property point origin

                border.width: 2
                border.color: "#8888FF"
                color: "#448888FF"
                visible: false
            }
        }
    }
}
