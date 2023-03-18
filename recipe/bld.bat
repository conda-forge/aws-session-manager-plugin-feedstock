@REM The VERSION file doesn't seem to be updated in the repository-
@REM maybe it's updated by an internal AWS build process?
@REM Echo without newline https://stackoverflow.com/questions/7105433/windows-batch-echo-without-new-line
<nul set /p="%PKG_VERSION%" > VERSION
@REM Without this the old version string is still used
make pre-build

make build-windows-amd64
MKDIR %PREFIX%\bin

COPY %SRC_DIR%\bin\windows_amd64\ssmcli.exe %PREFIX%\bin
COPY %SRC_DIR%\bin\windows_amd64_plugin\session-manager-plugin.exe %PREFIX%\bin

SET GOPATH=%CD%\vendor;%CD%\build\private
set GO111MODULE=auto
go-licenses save .\src\sessionmanagerplugin-main\ .\src\ssmcli-main\ --save_path=.\license-files

IF NOT EXIST license-files\github.com\ EXIT \b 1
