# -*- coding: utf-8 -*-

import setuptools, versioneer


# Package Metadata
# ----------------
#
# Replace values below with what's appropriate for your package:

name               = 'my-package'
description        = 'A short description, about 100–120 characters'
keywords           = ['pds', 'planetary data', 'various', 'other', 'keywords']
zip_safe           = True
namespace_packages = ['pds']
extras_require     = {}
entry_points       = {}


# You can find the vocabulary for these at https://pypi.org/classifiers/
classifiers = [
    'Programming Language :: Python :: 3',
    'License :: OSI Approved :: Apache Software License',
    'Operating System :: OS Independent',
]

# Below here, you shouldn't have to change anything:

with open('README.md', 'r') as fh:
    long_description = fh.read()

with open('requirements.txt', 'r') as f:
    pip_requirements = f.readlines()


setuptools.setup(
    name=name,
    version=versioneer.get_version(),
    license='apache-2.0',  # There's almost no standardization about what goes here, even amongst ALv2 projects
    author='PDS',
    author_email='pds_operator@jpl.nasa.gov',
    description=description,
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/NASA-PDS/' + name,
    download_url='https://github.com/NASA-PDS/' + name + '/releases/download/…',
    packages=setuptools.find_packages('src'),
    include_package_data=True,
    zip_safe=zip_safe,  # Change this if you need
    namespace_packages=namespace_packages,
    package_dir={'': 'src'},
    keywords=keywords,
    classifiers=classifiers,
    python_requires='>=3.6',
    install_requires=pip_requirements,
    entry_points=entry_points,
    extras_require=extras_require,
    cmdclass=versioneer.get_cmdclass()
)


# For future consideration:
#
# - `setup.py` metadata passé; move to `setup.cfg`
