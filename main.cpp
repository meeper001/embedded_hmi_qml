#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>

#include "src/SystemInfo.h"
#include "src/Multitouch.h"
#include "lib/lqtutils/lqtutils_ui.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    SystemInfo sysInfo;

    engine.rootContext()->setContextProperty("sysInfo", &sysInfo);
    qmlRegisterType<TouchPointItem>("MyApp", 1, 0, "TouchPointItem");

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    // Get the QQuickWindow from QQmlApplicationEngine's root objects
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
    lqt::enableAutoFrameUpdates(*window);

    // Create and register FPS monitor
    lqt::FrameRateMonitor *monitor = new lqt::FrameRateMonitor(window);
    

    engine.rootContext()->setContextProperty("fpsmonitor", monitor);

    return app.exec();
}
