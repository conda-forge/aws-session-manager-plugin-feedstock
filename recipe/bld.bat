make build-windows-amd64
MKDIR %PREFIX%\bin

COPY %SRC_DIR%\bin\windows_amd64\ssmcli.exe %PREFIX%\bin
COPY %SRC_DIR%\bin\windows_amd64_plugin\session-manager-plugin.exe %PREFIX%\bin

SET GOPATH=%CD%\vendor;%CD%\build\private
set GO111MODULE=auto
go-licenses save .\src\sessionmanagerplugin-main\ .\src\ssmcli-main\ --save_path=.\license-files

IF NOT EXIST license-files\github.com\ EXIT \b 1
