REM
REM  Copyright © 2012-2018 Inria.  All rights reserved.
REM  See COPYING in top-level directory.
REM

call %JENKINS_CONFIG_DIR%\\ciprofile.bat

REM  remove everything but the last 10 builds
sh -c "rm -rf $(ls | grep -v ^hwloc- | grep -v ^job-) || true"
sh -c "rm -rf $(ls -td hwloc-* | tail -n +21) || true"
REM  chmod not needed when not doing make distcheck

REM  find the tarball name
for /f %%i in ('sh -c "ls -tr hwloc-*.tar.gz | grep -v build.tar.gz | tail -1 | sed -e s/.tar.gz//"') do set TARBALL=%%i

sh -c "tar xfz %TARBALL%.tar.gz"
if %errorlevel% neq 0 exit /b %errorlevel%

cd %TARBALL%\contrib\windows
if %errorlevel% neq 0 exit /b %errorlevel%

%MSBUILD_PATH%\MSBuild hwloc.sln /p:Configuration=Release /p:Platform=x64
if %errorlevel% neq 0 exit /b %errorlevel%

x64\Release\lstopo-no-graphics.exe
if %errorlevel% neq 0 exit /b %errorlevel%

x64\Release\hwloc-info.exe --support
if %errorlevel% neq 0 exit /b %errorlevel%

cd ..\..\..

sh -c "tar cfz %TARBALL%-build.tar.gz %TARBALL%"
if %errorlevel% neq 0 exit /b %errorlevel%

sh -c "rm -rf %TARBALL%"
