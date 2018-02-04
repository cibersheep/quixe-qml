#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "backend.h"

void BackendPlugin::registerTypes(const char *uri) {
    //@uri Backend
    qmlRegisterSingletonType<Backend>(uri, 1, 0, "Backend", [](QQmlEngine*, QJSEngine*) -> QObject* { return new Backend; });
    
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
