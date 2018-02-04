#include <QDebug>
#include <QByteArray>
#include <QUuid>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QMimeDatabase>

#include "backend.h"

const QString gamesPath = "/home/phablet/.cache/quixe.cibersheep/Games/";

Backend::Backend() {

}
void Backend::copyLocally(QString path, QString fileName) {
    QFile file(path);
    
    qDebug() << "Copying file " << path;
    qDebug() << "to destination " << QString() << gamesPath << fileName;
    
    QDir appDir;
    appDir.mkpath(gamesPath);
    appDir.cd(gamesPath);
    
    //Check if it's a valid file .zip .ulx .gblorb
    //check if file exists
    //Check if it's zipped
    file.copy(path, QString("/home/phablet/.cache/quixe.cibersheep/Games/%1").arg(fileName));
}


void Backend::remove(QString path) {
	qDebug() << "Deleting file " << path;
    QFile file(path);
    file.remove();
}





/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author : Niklas Wenzel <nikwen.developer@gmail.com>
 */

void Backend::extractZip(const QString fileName, const QString path, const QString destination)
{
    QString program = "/opt/click.ubuntu.com/quixe.cibersheep/current/qml/bin/unzip"; // This programm is available in the images as it is one of the dependencies of the ubuntu-download-manager package.
    //QString program = "unzip";
    QStringList arguments;
    
    arguments << "-j" << fileName << "-d" << destination;

    extractArchive(program, arguments, destination); //Use destination as working directory
    Q_EMIT fileExtracted();
}

void Backend::extractTar(const QString path, const QString destination)
{
    QString program = "tar";
    QStringList arguments;
    arguments << "xf" << path << "-C" << destination;

    extractArchive(program, arguments, destination);
}

void Backend::extractGzipTar(const QString path, const QString destination)
{
    QString program = "tar";
    QStringList arguments;
    arguments << "xzf" << path << "-C" << destination;

    extractArchive(program, arguments, destination);
}

void Backend::extractBzipTar(const QString path, const QString destination)
{
    QString program = "tar";
    QStringList arguments;
    arguments << "xjf" << path << "-C" << destination;

    extractArchive(program, arguments, destination);
}

void Backend::extractArchive(const QString program, const QStringList arguments, const QString path)
{
    if (_process != nullptr && _process->state() == QProcess::ProcessState::Running) {
        return; // Do not allow two extractions running in parallel. Due to the way this is used in QML parallelization is not needed.
    }

    _process = new QProcess(this);

    // Connect to internal slots in order to have one unified onFinished slot handling both events for QML.
    connect(_process,
            static_cast<void(QProcess::*)(int, QProcess::ExitStatus)>
            (&QProcess::finished), this, &Backend::_onFinished);
    connect(_process,
            static_cast<void(QProcess::*)(QProcess::ProcessError)>
            (&QProcess::error), this, &Backend::_onError);
    connect(this, &Backend::killProcess,
            _process, &QProcess::kill);
	_process->setWorkingDirectory(path);
    _process->start(program, arguments);
}

void Backend::cancelArchiveExtraction()
{
    qDebug() << "Cancelling archive extraction";
    emit killProcess();
}

void Backend::_onError(QProcess::ProcessError error)
{
    qDebug() << "Extraction failed (1) with the following error:" << _process->readAllStandardError();
    emit finished(false, error);
}

void Backend::_onFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    if ((exitStatus == QProcess::NormalExit || exitCode == 0) && _process->readAllStandardError().trimmed().isEmpty()) {
        emit finished(true, -1);
    } else {
        qDebug() << "Extraction failed (2) with the following error:" << _process->readAllStandardError();
        emit finished(false, -1);
    }
}
