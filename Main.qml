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

    PolygonEditor {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        height: 100
        z: -1

        world: physicsWorld
    }
}
