#include <QQuickItem>
#include <QTouchEvent>

class TouchPointItem : public QQuickItem
{
    Q_OBJECT

public:
    TouchPointItem()
    {
        setAcceptedMouseButtons(Qt::AllButtons);
        setAcceptTouchEvents(true);
    }

protected:
    void touchEvent(QTouchEvent *event) override
    {
        QList<QTouchEvent::TouchPoint> touchPoints = event->touchPoints();

        // Convert to a type that QML understands. Here, let's convert it to QVariantList.
        QVariantList pointList;
        for (const QTouchEvent::TouchPoint &point : touchPoints)
        {
            if (point.state() != Qt::TouchPointReleased)
            { // Skip the point if it's in 'released' state
                QVariantMap pointMap;
                pointMap.insert("x", point.pos().x());
                pointMap.insert("y", point.pos().y());
                pointList.append(pointMap);
            }
        }

        emit touchPointsUpdated(pointList);
    }

signals:
    void touchPointsUpdated(QVariantList points);
};
