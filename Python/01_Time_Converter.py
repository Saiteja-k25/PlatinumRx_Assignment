# =============================================================
#  PlatinumRx Assignment | Python Proficiency
#  File : 01_Time_Converter.py
#  Task : Convert integer minutes into human-readable form
#         e.g. 130 → "2 hr 10 minutes"
# =============================================================


def minutes_to_human(minutes):
    """
    Convert a number of minutes into a human-readable string.

    Args:
        minutes (int): Total number of minutes (non-negative integer).

    Returns:
        str: Human-readable duration string.

    Examples:
        >>> minutes_to_human(130)
        '2 hr 10 minutes'
        >>> minutes_to_human(110)
        '1 hr 50 minutes'
        >>> minutes_to_human(60)
        '1 hr'
        >>> minutes_to_human(45)
        '45 minutes'
        >>> minutes_to_human(0)
        '0 minutes'
    """
    hrs  = minutes // 60   # integer division → whole hours
    mins = minutes % 60    # modulo           → remaining minutes

    if hrs == 0:
        return f"{mins} minutes"
    elif mins == 0:
        return f"{hrs} hr"
    else:
        return f"{hrs} hr {mins} minutes"


# ── Main: test cases ──────────────────────────────────────────
if __name__ == "__main__":
    test_cases = [130, 110, 60, 45, 0, 1, 90, 200, 1440]

    print("=" * 40)
    print("  Minutes  →  Human Readable")
    print("=" * 40)
    for mins in test_cases:
        print(f"  {mins:>6}   →  {minutes_to_human(mins)}")
    print("=" * 40)
