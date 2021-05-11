# pds-template-repo-python

This is the template repository for PDS's Python projects.

This repository aims at being a base for new python repositories used in PDS. It guides developers to ease the initialization of a project and recommends preferred options to standardize developments and ease maintenance. Simply click the <kbd>Use this template</kbd> button ↑ (or use [this hyperlink](https://github.com/NASA-PDS/pds-template-repo-python/generate)).


## Prerequisites

Include any system-wide requirements (`brew install`, `apt-get install`, `yum install`, …) **Python 3** should be used regardless as [Python 2 reached end-of-life on January 1st, 2020](https://pythonclock.org/).


## User Quickstart

Install with:

    pip install my_pds_module

If possible, make it so that your program works out of the box without any additional configuration—but see the [Configuration](###configuration) section for details.

To execute, run:

    (put your run commands here)


## Development

To develop this project, use your favorite text editor, or an integrated development environment with Python support, such as [PyCharm](https://www.jetbrains.com/pycharm/).


### Packaging

To isolate and be able to re-produce the environment for this package, you should use a [Python Virtual Environment](https://docs.python.org/3/tutorial/venv.html). To do so, run:

    python -m venv venv

Then exclusively use `venv/bin/python`, `venv/bin/pip`, etc. (It is no longer recommended to use `venv/bin/activate`.)

Dependencies for development are stored in requirements.txt; they are installed into the virtual environment as follows:

    venv/bin/pip install --requirement requirements.txt
     
All the source code is in a sub-directory under `src`.

You should update the `setup.py` file with:

- name of your module
- version
- license, default apache, update if needed
- description
- download url, when you release your package on github add the url here
- keywords
- classifiers
- install_requires, add the dependencies of you module
- entry_points, when your module can be called in command line, this helps to deploy command lines entry points pointing on scripts in your module  

Eventually, we should move to putting everything into `setup.cfg`, as having package metadata in `setup.py` is passé.

For the packaging details, see https://packaging.python.org/tutorials/packaging-projects/ as a reference.


### Configuration

It is convenient to use ConfigParser package to manage configuration. It allows a default configuration which can be overwritten by the user in a specific file in their environment. See https://pymotw.com/2/ConfigParser/

For example:

    candidates = ['my_pds_module.ini', 'my_pds_module.ini.default']
    found = parser.read(candidates)


### Logs

You should not use `print()`vin the purpose of logging information on the execution of your code. Depending on where the code runs these information could be redirected to specific log files.

To make that work, start each Python file with:

```python
import logging

logger = logging.getLogger(__name__)
```

To log a message:

    logger.info("my message")

In your `main` routine, include:

    logging.basicConfig(level=logging.INFO)

to get a basic logging system configured.
    
    
### Code Style

So that your code is readable, you should comply with the [PEP8 style guide](https://www.python.org/dev/peps/pep-0008/). It is automatically enforced in PyCharm IDE.

Note that several PEP8 guidelines are rather old fashioned; trust your judgment.


### Recommended Libraries

Python offers a large variety of libraries. In PDS scope, for the most current usage we should use:

| Library      | Usage                                           |
|--------------|------------------------------------------------ |
| configparser | manage and parse configuration files            |
| argparse     | command line argument documentation and parsing |
| requests     | interact with web APIs                          |
| lxml         | read/write XML files                            |
| json         | read/write JSON files                           |
| pyyaml       | read/write YAML files                           |
| pystache     | generate files from templates                   |

Some of these are built into Python 3; others are open source add-ons you can include in your `requirements.txt`.


### Tests

This section describes testing for your package.


#### Unit tests

Your project should have built-in unit tests, functional, validation, acceptance, etc., tests.

For unit testing, check out the [unittest](https://docs.python.org/3/library/unittest.html) module, built into Python 3.

Tests objects should be in packages `test` modules or preferably in project 'tests' directory which mirrors the project package structure.

Unit tests are launched with command:

    python setup.py test 


#### Integration/Behavioral Tests

One should use the `behave package` and push the test results to "testrail".

See an example in https://github.com/NASA-PDS/pds-doi-service#behavioral-testing-for-integration--testing


## Build

    pip install wheel
    python setup.py sdist bdist_wheel


### Publication

NASA PDS packages can publish automatically using the [Roundup Action](https://github.com/NASA-PDS/roundup-action), which leverages GitHub Actions to perform automated continuous integration and continuous delivery. A default workflow that includes the Roundup is provided in the `.github/workflows/unstable-cicd.yaml` file. (Unstable here means an interim release.)
