#ifndef DOWNLOADINTERCEPTORPLUGIN_H
#define DOWNLOADINTERCEPTORPLUGIN_H

#include <QQmlExtensionPlugin>

class DownloadInterceptorPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif
