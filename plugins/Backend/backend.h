#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <QProcess>

class Backend: public QObject {
    Q_OBJECT

public:
    Backend();
    ~Backend() = default;

    Q_INVOKABLE void copyLocally(const QString path, const QString fileName);
    Q_INVOKABLE void remove(QString path);

    Q_INVOKABLE void extractZip(const QString fileName, const QString path, const QString destination);
    Q_INVOKABLE void extractTar(const QString path, const QString destination);
    Q_INVOKABLE void extractGzipTar(const QString path, const QString destination);
    Q_INVOKABLE void extractBzipTar(const QString path, const QString destination);
    Q_INVOKABLE void cancelArchiveExtraction();

signals:
    void finished(bool success, int errorCode);
    void killProcess();

Q_SIGNALS:
    void fileExtracted();

private slots:
    void _onError(QProcess::ProcessError error);
    void _onFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    void extractArchive(const QString program, const QStringList arguments, const QString path);

    QProcess* _process = nullptr;

};

#endif




