# encoding: utf-8
"""Main demonstration module."""
from . import VERSION


def getgreeting() -> str:
    """Return an appropriate greeting."""
    return f"Heya, 🌎 (by the way, this is {VERSION})"


def main():
    """Main entrypoint.

    That's why it's called "main.".
    """
    greeting = getgreeting()
    print(greeting)


if __name__ == "__main__":
    main()
