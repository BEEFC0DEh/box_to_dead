#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <box2dplugin.h>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Box2DPlugin plugin;
    plugin.registerTypes("Box2D");
    qmlProtectModule("Box2D", 2);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("box_to_dead", "Main");

    return app.exec();
}
