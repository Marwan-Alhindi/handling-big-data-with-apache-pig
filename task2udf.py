@outputSchema("category:chararray")
def price_category(total_price):
    """
    Categorizes the given total price into one of three categories: 'high value', 'medium', or 'low value'.
    
    This function is intended to be used in data processing pipelines to create a new column 
    that categorizes the total price of items or transactions based on predefined thresholds.
    
    Parameters:
    - total_price (float): The total price value to be categorized.
    
    Returns:
    - str: A string representing the category of the total price. 
           The categories are defined as:
           - 'high value' if total_price >= 300
           - 'medium' if 100 <= total_price < 300
           - 'low value' otherwise
    
    Example:
    >>> price_category(350)
    'high value'
    >>> price_category(150)
    'medium'
    >>> price_category(50)
    'low value'
    """
    if total_price >= 300:
        return "high value"
    elif 300 > total_price >= 100:
        return "medium"
    else:
        return "low value"