# =============================================================
#  PlatinumRx Assignment | Python Proficiency
#  File : 02_Remove_Duplicates.py
#  Task : Remove duplicate characters from a string using a loop
#         and print the unique string (preserving original order).
# =============================================================


def remove_duplicates(s):
    """
    Remove duplicate characters from a string using a loop.
    Preserves the first occurrence of each character in order.

    Args:
        s (str): Input string.

    Returns:
        str: String with duplicate characters removed.

    Examples:
        >>> remove_duplicates("programming")
        'progamin'
        >>> remove_duplicates("hello")
        'helo'
        >>> remove_duplicates("aabbcc")
        'abc'
    """
    result = ""                  # start with an empty string

    for char in s:               # loop through every character
        if char not in result:   # if NOT already seen → add it
            result += char       # if already in result → skip it

    return result


# ── Main: test cases ──────────────────────────────────────────
if __name__ == "__main__":
    test_cases = [
        "programming",
        "hello",
        "aabbcc",
        "abcabc",
        "mississippi",
        "PlatinumRx",
        "",
        "aaaa",
    ]

    print("=" * 45)
    print("  Input             →  Unique String")
    print("=" * 45)
    for s in test_cases:
        result = remove_duplicates(s)
        print(f"  {s!r:<20} →  {result!r}")
    print("=" * 45)
