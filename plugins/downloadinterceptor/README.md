# DownloadInterceptor

This is a utility for Ubuntu Touch Webapps that allows them to download files that
the download manager cannot handle. For example DownloadInterceptor can download
files from Nextcloud when you are logged in that would otherwise be unable to be
downloaded.

## Usage

~~~
import DownloadInterceptor 1.0

...

WebContext {
    id: webcontext
    userAgent: 'Mozilla...'
}

WebView {
    ...

    onDownloadRequested: {
        console.log('download requested', request.url.toString(), request.suggestedFilename);
        DownloadInterceptor.download(request.url, request.cookies, request.suggestedFilename, webcontext.userAgent);

        request.action = Oxide.NavigationRequest.ActionReject;
    }
}

Connections {
    target: DownloadInterceptor
    onSuccess: {
        /*
        path is the full path to the file, you can use it to open in
        another app or manipulate it as needed.

        When you are done with the file you can optionally use
        DownloadInterceptor.remove(path) to remove the file.
        */
    }

    onFail: {
        /*
        Something went wrong and the `message` argument will tell you what it was.
        */
    }
}
~~~

## License

Copyright (C) 2018 [Brian Douglass](http://bhdouglass.com/)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License version 3, as published
by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranties of MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
