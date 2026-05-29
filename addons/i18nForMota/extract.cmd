@echo off
cd /d "%~dp0"
call config.cmd
%PYTHON_PATH% filterPot.py > i18n.log
%PYTHON_PATH% extractTable.py >> i18n.log
%PYTHON_PATH% extractEvent.py >> i18n.log
type i18n.log