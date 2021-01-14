# -*- coding: utf-8 -*-

'''My PDS Module'''

from ._version import get_versions
__version__ = get_versions()['version']
__date__ = get_versions()['date']
del get_versions


# For future consideration:
#
# - Other metadata (__docformat__, __copyright__, etc.)
# - Namespace packages?
