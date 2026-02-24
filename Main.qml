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

    Item {
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

        Body {
            fixtures: Chain {
                id: groundShape
                vertices: ground.polygon.map((point) => Qt.point(point.x + ground.x, point.y + ground.y))
                loop: true
            }
            world: physicsWorld
        }

        Canvas {
            id: groundCanvas

            anchors.fill: parent

            onPaint: {
                let context = groundCanvas.getContext("2d")
                context.beginPath()
                context.moveTo(0, 0)
                let points = ground.polygon
                for (let i = 1; i < points.length; i++) {
                    let point = points[i]
                    let x = point.x
                    let y = point.y
                    context.lineTo(x,y)
                }
                context.fillStyle = "#000000"
                context.fill()
            }
        }
    }
}
