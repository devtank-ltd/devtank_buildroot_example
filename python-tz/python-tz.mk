################################################################################
#
# python-tz
#
################################################################################

PYTHON_TZ_VERSION = 2021.1
PYTHON_TZ_SOURCE = pytz-$(PYTHON_TZ_VERSION).tar.gz
PYTHON_TZ_SITE = https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d
PYTHON_TZ_SETUP_TYPE = setuptools
PYTHON_TZ_LICENSE = MIT
PYTHON_TZ_LICENSE_FILES = LICENSE

$(eval $(python-package))
