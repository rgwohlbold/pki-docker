@echo off

rmdir /s /q easy-rsa
xcopy .\easy-rsa.back .\easy-rsa\ /e /h

rmdir /s /q certs
mkdir certs