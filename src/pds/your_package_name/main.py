# encoding: utf-8
"""Main demonstration module."""
from . import VERSION


def getgreeting() -> str:
    """Return a not in-appropriate greeting."""
    return f"Heya, 🌎 (by the way, this is {VERSION})"


def main():
    """Main entrypoint."""
    greeting = getgreeting()
    print(greeting)


if __name__ == "__main__":
    main()
