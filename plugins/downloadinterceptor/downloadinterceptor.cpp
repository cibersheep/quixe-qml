#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QStandardPaths>
#include <QNetworkCookie>
#include <QVariant>
#include <QNetworkCookieJar>

#include "downloadinterceptor.h"

DownloadInterceptor::DownloadInterceptor() {
    m_cookieJar = new QNetworkCookieJar();
    m_manager.setCookieJar(m_cookieJar);

    connect(&m_manager, SIGNAL(finished(QNetworkReply*)), SLOT(downloadFinished(QNetworkReply*)));   
}

void DownloadInterceptor::download(QString url, QStringList cookies, QString suggestedFilename, QString userAgent) {
    m_url = QUrl(url);
    m_suggestedFilename = suggestedFilename;
    m_userAgent = userAgent;

    qDebug() << "going to download" << url << suggestedFilename;

    foreach (const QString cookie, cookies) {
        // For some reason the cookies have whitespace at the beginning
        QStringList parts = cookie.trimmed().split("=");
        QString name = parts[0];
        parts.removeFirst();
        QString value = parts.join("=");

        QNetworkCookie networkCookie(name.toUtf8(), value.toUtf8());
        networkCookie.setDomain(m_url.host());
        networkCookie.setPath("/");

        m_cookieJar->insertCookie(networkCookie);
    }

    QNetworkRequest request(m_url);
    // Cookies are automatically added as part of the cookiejar
    request.setHeader(QNetworkRequest::UserAgentHeader, userAgent);

    QNetworkReply *reply = m_manager.get(request);
    connect(reply, SIGNAL(downloadProgress(qint64, qint64)), SIGNAL(downloading(qint64, qint64)));
    connect(this, SIGNAL(abortDownload()), reply, SLOT(abort()));   
}

void DownloadInterceptor::remove(QString path) {
    QFile file(path);
    file.remove();
}

void DownloadInterceptor::downloadFinished(QNetworkReply *reply) {
    qDebug() << "download finished, status code:" << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    QUrl url = reply->url();
    if (reply->error()) {
        qDebug() << "Failed to download" << url << reply->errorString();

        Q_EMIT fail("Failed to download file " + reply->errorString());
    }
    else {
        if (reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toString().isEmpty()) {
            QString filename = m_suggestedFilename;

            if (m_suggestedFilename.isEmpty()) {
                QString urlPath = url.path();
                filename = QFileInfo(urlPath).fileName();
                if (filename.isEmpty()) {
                    filename = "download";
                }
            }

            QString path = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + "/" + filename;

            QFile file(path);
            if (file.open(QIODevice::WriteOnly)) {
                file.write(reply->readAll());
                file.close();

                qDebug() << "Downloaded file to" << path;
                Q_EMIT success(path);
            }
            else {
                qDebug() << "Could not open file for writing" << path << file.errorString();

                Q_EMIT fail("Failed to save file " + file.errorString());
            }
        }
        else {
            QString url = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toString();
            if (!url.startsWith("http://") && !url.startsWith("https://")) {
                int defaultPort = 80;
                if (m_url.scheme() == "https") {
                    defaultPort = 443;
                }

                url = m_url.scheme() + "://" + m_url.host() + ":" + QString::number(m_url.port(defaultPort)) + url;
            }

            qDebug() << "Redirected to" << url;
            QStringList cookies; // Left blank because we are using the cookie jar
            download(url, cookies, m_suggestedFilename, m_userAgent);
        }
    }

    reply->deleteLater();
}

void DownloadInterceptor::abort() {
    emit abortDownload();
}
