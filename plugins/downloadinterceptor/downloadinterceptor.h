#ifndef DOWNLOADINTERCEPTOR_H
#define DOWNLOADINTERCEPTOR_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkCookieJar>

class DownloadInterceptor: public QObject {
    Q_OBJECT

public:
    DownloadInterceptor();
    ~DownloadInterceptor() = default;

    Q_INVOKABLE void download(QString url, QStringList cookies, QString suggestedFilename, QString userAgent);
    Q_INVOKABLE void remove(QString path);
    Q_INVOKABLE void abort();

Q_SIGNALS:
    void success(QString path);
    void fail(QString message);
    void downloading(qint64 received, qint64 total);

signals:
    void abortDownload();

public Q_SLOTS:
    void downloadFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager m_manager;
    QUrl m_url;
    QNetworkCookieJar *m_cookieJar;
    QString m_suggestedFilename;
    QString m_userAgent;
};

#endif
