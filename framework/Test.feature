Feature: Hello world

  Scenario: Verify that all results are related to search word
    Given Open eBay.com
    And   Search for "shoes"
    And   Click on Search button
    And   Filter by "Nike" in category "Brand"
    And   Filter by "Leather" in category "Upper material"
    And   Filter by "Comfort" in category "Features"
    Then  Custom filter results verification

  Scenario Outline: Multiple filter
    Given Open eBay.com
    And   Search for "<search_item>"
    And   Click on Search button
    Then  Apply following filters
      | Filter         | value          |
      | <filter_name>  | <filter_value> |

    Then  Custom filter results verification
      | Filter         | value          |
      | <filter_name>  | <filter_value> |

    Examples: Shoes
      | search_item    | filter_name    | filter_value  |
      | shoes          | Brand          | Nike          |
      | shoes          | Condition      | New           |

#    Examples: Dress
#      | search_item    | filter_name    | filter_value  |
#      | dress          | Dress Length   | Midi          |







