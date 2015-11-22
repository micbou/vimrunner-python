@echo on

if %arch% == 32 (
    set PYTHON_PATH=C:\Python%python%
    set SDK_ENV=/x86
    set VIM_CPU=i386
    set VIM_PYTHON2_PATH=C:\Python27
    set VIM_PYTHON3_PATH=C:\Python35
) else (
    set PYTHON_PATH=C:\Python%python%-x64
    set SDK_ENV=/x64
    set VIM_CPU=AMD64
    set VIM_PYTHON2_PATH=C:\Python27-x64
    set VIM_PYTHON3_PATH=C:\Python35-x64
)

rem Used by Tox to select the python version
set TOXENV=py%python%
set PATH=%PYTHON_PATH%;%PYTHON_PATH%\Scripts;%PATH%

pip install --disable-pip-version-check --user --upgrade pip
pip install tox

set VIM_BUILD_DIR=%USERPROFILE%\vim
set PATH=%VIM_BUILD_DIR%\src;%PATH%

if EXIST %VIM_BUILD_DIR%\.git (
    pushd %VIM_BUILD_DIR%
    git fetch
    git diff --exit-code --quiet ..origin/master
    if errorlevel 1 (
        git reset --hard origin/master
        git clean -dfx
        set need_build=1
    )
    popd
) else (
    git clone --depth 1 --single-branch https://github.com/vim/vim %VIM_BUILD_DIR%
    set need_build=1
)

if not defined %need_build% (
    pushd %VIM_BUILD_DIR%\src
    rem From Vim official repository: https://github.com/vim/vim/blob/master/appveyor.yml
    "C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.cmd" %SDK_ENV% /release
    sed -e "s/\$(LINKARGS2)/\$(LINKARGS2) | sed -e 's#.*\\\\r.*##'/" Make_mvc.mak > Make_mvc2.mak
    rem Build vim executable
    nmake -f Make_mvc2.mak CPU=%VIM_CPU% MBYTE=yes ICONV=yes DEBUG=no PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON=%VIM_PYTHON2_PATH% PYTHON3_VER=35 DYNAMIC_PYTHON3=yes PYTHON3=%VIM_PYTHON3_PATH%
    rem Build gvim executable
    nmake -f Make_mvc2.mak CPU=%VIM_CPU% GUI=yes IME=yes MBYTE=yes ICONV=yes DEBUG=no PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON=%VIM_PYTHON2_PATH% PYTHON3_VER=35 DYNAMIC_PYTHON3=yes PYTHON3=%VIM_PYTHON3_PATH%
    popd
)
