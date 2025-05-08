# encoding: utf-8
"""Main demonstration module."""


def getgreeting() -> str:
    """Return an appropriate greeting."""
    return "Heya, 🌎"


def main():
    """Main entrypoint."""
    greeting = getgreeting()
    print(greeting)


if __name__ == "__main__":
    main()
