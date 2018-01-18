@echo off

::
:: Удаление службы windows 1C Enterprise RAS
::

set name="1C:Enterprise RAS"

sc delete %name%

pause