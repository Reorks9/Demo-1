@TITLE Developer Command Prompt for VS 2019
@Call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\vsDevCmd.bat " 
@Call MSBuild C:\GameStore\GameStrore.WebUI\gamestore.webui.csproj /p:deployonbuild=true /p:publishprofile=C:\GameStore\GameStrore.WebUI\Properties\PublishProfiles\folderprofile.pubxml
