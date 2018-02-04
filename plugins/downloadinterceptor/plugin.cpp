#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "downloadinterceptor.h"

void DownloadInterceptorPlugin::registerTypes(const char *uri) {
    //@uri DownloadInterceptor
    qmlRegisterSingletonType<DownloadInterceptor>(uri, 1, 0, "DownloadInterceptor", [](QQmlEngine*, QJSEngine*) -> QObject* { return new DownloadInterceptor; });
}
