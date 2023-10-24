#include <QQmlContext>
#include <QFile>
#include <QTextStream>
#include <QObject>

class SystemInfo : public QObject
{
    Q_OBJECT
public:
    // Report Current Memory usage in Kb
    Q_INVOKABLE int getMemoryUsage() {
        int memoryUsage = 0;
        QFile file("/proc/self/status");
        if(file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            QTextStream in(&file);
            QString line = in.readLine();
            while (!line.isNull()) {
                if(line.startsWith("VmRSS:")) {
                    QStringList parts = line.split(" ", Qt::SkipEmptyParts);  // use Qt::SkipEmptyParts
                    if(parts.size() > 1) {
                        memoryUsage = parts.at(1).toInt();
                        break;
                    }
                }
                line = in.readLine();
            }
        }
        return memoryUsage;
    }
};