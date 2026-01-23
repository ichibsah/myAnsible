
def compute_ssnit(basic_salary, ssnit_rate=0.055):
    """Compute SSNIT (Tier 1) on BASIC salary, rounded to 2 decimals."""
    return round((basic_salary or 0.0) * ssnit_rate, 2)


def compute_paye_tax(taxable_income=None, categories=None, include_deductions=False,
                     line_name="PAYE Tax", deduct_ssnit=False, ssnit_rate=0.055):
    """
    Compute Ghana PAYE tax for monthly payroll.
    Returns: result, result_rate, result_qty, result_name (Odoo-compatible).
    """

    # Determine taxable income
    if taxable_income is None:
        if categories is None:
            raise ValueError("Provide taxable_income or categories.")
        taxable_income = categories.get('BASIC', 0.0) + categories.get('ALW', 0.0)
        if include_deductions:
            taxable_income -= categories.get('DED', 0.0)

    # Deduct SSNIT if required
    if deduct_ssnit and categories:
        taxable_income -= compute_ssnit(categories.get('BASIC', 0.0), ssnit_rate)

    taxable_income = max(round(taxable_income, 2), 0.0)
    original_income = taxable_income

    # Ghana PAYE monthly bands
    bands = [
        (539.0, 0.00), (110.0, 0.05), (130.0, 0.10),
        (3167.0, 0.175), (16000.0, 0.25), (30520.0, 0.30),
        (float('inf'), 0.35)
    ]

    # Compute tax progressively
    tax = 0.0
    marginal_rate = 0.0
    remaining = taxable_income
    for size, rate in bands:
        if remaining <= 0:
            break
        portion = min(remaining, size)
        tax += portion * rate
        remaining -= portion
        marginal_rate = rate

    tax = round(tax, 2)
    effective_rate = round((tax / original_income * 100) if original_income > 0 else 0.0, 2)

    # Odoo outputs
    result = original_income  # base amount
    result_rate = effective_rate
    result_qty = 1.0
    result_name = f"{line_name} (effective {effective_rate:.2f}%, marginal {marginal_rate*100:.1f}%)"

    return result, result_rate, result_qty, result_name


# Using categories and deducting SSNIT
result, result_rate, result_qty, result_name = compute_paye_tax(
    categories=categories,
    include_deductions=False,
    deduct_ssnit=False
)


# Using pre-computed taxable income
my_taxable = round(max(categories.get('BASIC', 0.0) + categories.get('ALW', 0.0) - categories.get('DED', 0.0), 0.0), 2)
result, result_rate, result_qty, result_name = compute_paye_tax(taxable_income=my_taxable)
 # End of ghTaxCal.py
 