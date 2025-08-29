# encoding: utf-8
"""Example tests."""
import unittest


class HelloWorldTests(unittest.TestCase):
    """Example test of the greeting."""

    def test_greeting(self):
        """Ensure the ``getgreeting`` function works as expected."""
        from pds.your_package_name.main import getgreeting

        greeting = getgreeting()[0:7]
        self.assertEqual("Heya, 🌎", greeting, "Expected greeting does not match … er … expectations")


if __name__ == "__main__":
    unittest.main()
