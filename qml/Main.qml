import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.3
import Backend 1.0

import Qt.labs.folderlistmodel 2.1

import "components"

MainView {
    id: root
    objectName: 'mainView'

    applicationName: 'quixe.cibersheep'

    anchorToKeyboard: true
    automaticOrientation: true

    property string urlPattern: 'www/*'
    property string gameImported: ""

    width: units.gu(50)
    height: units.gu(75)

	property string lighterColor: '#f7f6f5'
	property string darkColor: '#0e8cba'
	property string lightColor: '#e0e0e0'
	
	property string gamesFolder: "/home/phablet/.cache/quixe.cibersheep/Games/"
	property bool sortByModified: true
	property int marginColumn: units.gu(2)
	
	PageStack {
		id: mainPageStack
		anchors.fill: parent
		Component.onCompleted: mainPageStack.push(page)
		Page {
			id: page
			anchors {
				fill: parent
				bottom: parent.bottom
			}
			width: parent.width
			height: parent.height

			header: AppHeader {
				title: "Quixe"
				id: header
			}
			
			Flickable {
                id: flickable
                anchors {
                    fill: parent
                    horizontalCenter: parent.horizontalCenter
                }
                //width: parent.width - marginColumn * 2
                contentHeight: gameList.height + units.gu(18)

                Column {
                    id: gameList
                    width: parent.width
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: header.visible ? header.height + units.gu(8) : units.gu(8)
                        //bottom: parent.bottom
                    }
                    spacing: units.gu(2)
                    
                    Label {
						height: units.gu(4)
						anchors.horizontalCenter: parent.horizontalCenter
						text: importedGamesModel.count === 0 ? i18n.tr("No Imported Games Yet") : i18n.tr("Previouly Imported Games")
						color: darkColor
					}
					
					
					UbuntuShape {
					   visible: importedGamesModel.count === 0
					   width: units.gu(20)
					   height: width
					   anchors{
						   horizontalCenter: parent.horizontalCenter
					   }
					   aspect: UbuntuShape.Flat
					   source: Image {
						   sourceSize.width: parent.width
						   source: "../assets/bottomEdgeIcon.svg"
					   }
					}
					
					Column {
						id: previousGames
						width: parent.width
						anchors.horizontalCenter: parent.horizontalCenter	

						FolderListModel {
							id: importedGamesModel
							rootFolder: gamesFolder
							folder: gamesFolder
							
							//TO DO: Implement the rest od compressed files
							nameFilters: [ "*.ulx", "*.ULX", "*.gblorb", "*.GBLORB","*.blb", "*.BLB" , "*.zip", "*.ZIP", "*.tar", "*.TAR"]
							showHidden: true
							showDirs: false
							sortField: sortByModified ? FolderListModel.Time : FolderListModel.Name
						}

						Component {
							id: importedGamesDelegate
							
							ListOfGames {}
						}

						ListView {
							id: importGameList
							interactive: false
							width: parent.width

							anchors.horizontalCenter: parent.horizontalCenter
							height: units.gu(7) * importedGamesModel.count

							model: importedGamesModel
							delegate: importedGamesDelegate
						}

					}
					
					Label {
						anchors.horizontalCenter: parent.horizontalCenter
						text: i18n.tr("Accepted formats: %1, %2, %3").arg("ulx").arg("gblorb").arg("blb")
						
					}
					Column {
						id: otherOptions
						width: parent.width
						
						
						Divider {
							width: parent.width
						}
						ListItem{
							width: parent.width
							divider.visible: true
							GelekItemLayout {
								title.text: i18n.tr("Download games from %1").arg("ifarchive.info")
								title.color: darkColor
							}
							onClicked: {
								Qt.inputMethod.hide();
								mainPageStack.push(Qt.resolvedUrl("IfArchiveWebviewPage.qml"));
							}
						}

					}
                
				} //Column
            }
            //BottomEdge
			ImportGameBottomEdge {}
			
			HideHeader {}

		} // </page>
	}

	function importContent() {
		var importPage = mainPageStack.push(Qt.resolvedUrl("ImportPage.qml"),{"contentType": ContentType.All, "handler": ContentHandler.Source})
		importPage.imported.connect(function(fileUrl) {
			gameImported  = fileUrl
			console.log("Import: " + gameImported)
			var gameName = gameImported.split("/")
			console.log("Copy: " + gameName[gameName.length-1])
			Backend.copyLocally(gameImported.replace("file://",""), gameName[gameName.length-1])
			mainPageStack.pop()
		})
		
	}
	
	function extractArchive(filePath, fileName, archiveType) {
		console.log("Extract accepted for filePath, fileName", filePath, fileName)
		PopupUtils.open(extractingDialog, root.mainView, { "fileName" : fileName })
		
		var parentDirectory = filePath.substring(0, filePath.lastIndexOf("/"))
		var fileNameWithoutExtension = fileName.substring(0, fileName.lastIndexOf(archiveType) - 1)
		var extractDirectory = parentDirectory 	//+ "/"	+ fileNameWithoutExtension
		
		console.log("Extracting " + filePath + " named " + fileName + " to " + extractDirectory)

		// Add numbers if the directory already exist: myfile, myfile-1, myfile-2, etc.
		//TO DO: use the correct folder.
		//TO DO: Decide how to handle compressed archives
		/*
		while (pageModel.existsDir(extractDirectory)) {
			var i = 0
			while ("1234567890".indexOf(extractDirectory.charAt(extractDirectory.length - i - 1)) !== -1) {
				i++
			}
			if (i === 0 || extractDirectory.charAt(extractDirectory.length - i - 1) !== "-") {
				extractDirectory += "-1"
			} else {
				extractDirectory = extractDirectory.substring(0, extractDirectory.lastIndexOf("-") + 1) + (parseInt(extractDirectory.substring(extractDirectory.length - i)) + 1)
			}
		}

		pageModel.mkdir(extractDirectory) // This is needed for the tar command as the given destination has to be an already existing directory
		*/
		
		if (archiveType === "zip") {
			Backend.extractZip(fileName, filePath, extractDirectory)
		} else if (archiveType === "tar") {
			Backend.extractTar(filePath, extractDirectory)
		} else if (archiveType === "tar.gz") {
			Backend.extractGzipTar(filePath, extractDirectory)
		} else if (archiveType === "tar.bz2") {
			Backend.extractBzipTar(filePath, extractDirectory)
		}
	}
		
	Component {
		id: extractingDialog
		ExtractingDialog {
		    anchors.fill: parent
		}
	}
	/*
    Component {
        id: openDialogComponent

        OpenDialog {
            anchors.fill: parent
        }
    }
    */

}
