import QtQuick
import Box2D 2.0

Rectangle {
    id: root

    property alias world: body.world
    property var polygon: [
        Qt.point(0, 0),
        Qt.point(width * 0.5, height * 0.75),
        Qt.point(width, 0),
        Qt.point(width, height),
        Qt.point(0, height)
    ]

    color: "lightgray"

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
        id: body

        fixtures: Chain {
            id: groundShape

            function setVertices() {
                vertices = root.polygon.map((point) => Qt.point(point.x + root.x, point.y + root.y))
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
            let points = root.polygon
            for (let i = 1; i < points.length; i++) {
                let point = points[i]
                let x = point.x
                let y = point.y
                context.lineTo(x, y)
                context.strokeRect(x - 5, y - 5, 10, 10)
            }
            context.fillStyle = "#44000000"
            context.fill()
            context.strokeStyle = "#000000"
            context.stroke()

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
                root.polygon.push(Qt.point(mouse.x, mouse.y))
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
