# pds-template-python
Template repository for PDS python developments.

This repository aims at being a base for new python repository used in PDS.

It guides developers to ease the initialization of a project and recommends preferred options to standardize developments and ease maintenance. 

## Prerequisites

Any system wide requirements (brew install, apt-get install or yum install ...)

**Python3** should be used.


## User quickstart

Install

    pip install my_pds_module

Configure

Update local configuration files is relevant. Ideally a default configuration should work (see [Configuration](###configuration) for detail).

Use (command line or web service url):

    ...


## Developers

**PyCharm** IDE is useful for complex development project.


### Packaging

To isolate and be able to re-produce the environment for the project, we use virtualenv:

    python -m venv venv
    source venv/bin/activate

    
Dependencies for development are stored in file requirements.txt, they are installed in the virtualenv as follow:

    pip install -r requirements.txt


Use setup tools to package your code:

    pip install setuptools

     
All the source code is in a sub-directory named after the developed module, for example my_pds_module.
If the project is complex, we might have different sub-modules in this directory.

Update the setup.py file:
- name of your module
- version
- license, default apache, update if needed
- description
- download url, when you release your package on github add the url here
- keywords
- classifiers
- install_requires, add the dependencies of you module
- entry_points, when your module can be called in command line, this helps to deploy command lines entry points pointing on scripts in your module  

You can update the setup.cfg file which describes how setup.py can be called, with which directives and options. This is useful for pypi publication.

For the packaging details, see https://packaging.python.org/tutorials/packaging-projects/ as a reference.

### Configuration

It is convenient to use ConfigParser package to manage configuration.
It allows to have a default configuration which can be overwritten by the user in a specific file in their environment.
See https://pymotw.com/2/ConfigParser/

For example:

    candidates = ['my_pds_module.ini',
                  'my_pds_module.ini.default']
    found = parser.read(candidates)

### Logs

You should not use `print()`vin the purpose of logging information on the execution of your code. Depending on where the code runs these information could be redirected to specific log files.

To make that work, have a the beginning of your python file:

```python
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
```

To log a message:

    logger.info("my message")
    
    
### Code style

So that your code is readable, you must comply with the PEP8 style guide, see https://www.python.org/dev/peps/pep-0008/

It is automatically enforced in PyCharm IDE.

### Recommended libraries

Python offers a large variety of libraries. In PDS scope, for the most current usage we should use:

| Library    | Usage |
|------------|-----------------------------|
| configparser | manage and parse configuration files |
| argparse | command line argument documentation and parsing |
| requests | interact with web APIs |
| lxml | read/write XML files |
| json | read/write JSON files |
| pyyaml | read/write YAML files |
| pystache | generate files from templates |


### Tests

#### Unit tests

Your project should have built-in unit tests and validation tests.

The package to be used for unit testing is unittest, see https://docs.python.org/3/library/unittest.html

Tests objects must be in packages 'test' subdirectories or preferably in project 'tests' directory which mirrors the project package structure.

Unit tests are launched with command:

    python setup.py test 

#### Integration/behavioral tests

One shoud use the `behave package` and push the test results to testrail.

See example in https://github.com/NASA-PDS/pds-doi-service#behavioral-testing

## Build

    pip install wheel
    python sdist bdist_wheel

### Publication

You can publish your module on PyPi (you need a pypi account):

    pip install twine
    twine upload dist/*
    
You can also use github actions, see example provided in `.github/workflows/publish.yml.example`





