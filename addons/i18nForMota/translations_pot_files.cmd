@echo off
cd /d "%~dp0"
call config.cmd
%PYTHON_PATH% addPathToProject.py > i18n.log
type i18n.log