# -*- coding: utf-8 -*-

import setuptools, versioneer

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="my_pds_module",  # Replace with your own package name
    version=versioneer.get_version(),
    license="apache-2.0",
    author="pds ",
    author_email="pds_operator@jpl.nasa.gov",
    description="short description of my pds module, less than 100–120 characters",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/NASA-PDS/pds-template-python",
    download_url="https://github.com/NASA-PDS/pds-template-python/releases/download/....",
    packages=setuptools.find_packages(),
    keywords=['pds', 'other keywords'],

    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
    install_requires=[],
    entry_points={
        'console_scripts': ['snapshot-release=pds_github_util:snapshot_release.main'],
    },
    cmdclass=versioneer.get_cmdclass()
)


# For future consideration:
#
# - `setup.py` metadata passé; move to `setup.cfg`
