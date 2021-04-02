Feature: Ebay Search


  Scenario Outline: Verify that Shoes and Dress search filtered correctly
    Given Open eBay.com
    And   Search for "<search_item>"
    And   Click on Search button
    And   Apply following filters
      | Filter           | value            |
      | <filter_name_1>  | <filter_value_1> |
      | <filter_name_2>  | <filter_value_2> |

    Then  Custom filter results verification
      | Filter         | value          |
      | <filter_name_1>  | <filter_value_1> |
      | <filter_name_2>  | <filter_value_2> |

    Examples: Dress
      | search_item    | filter_name_1    | filter_value_1  | filter_name_2    | filter_value_2  |
      | dress          | Brand            | Zara            | Dress Length     | Midi            |

    Examples: Shoes
      | search_item    | filter_name_1    | filter_value_1  | filter_name_2    | filter_value_2  |
      | shoes          | Brand            | Nike            | Features         | Waterfroof      |


#  Scenario Outline: Verify that Shirt results are related to search word
#    Given Open eBay.com
#    And   Search for "<search_item>"
#    And   Click on Search button
#    And    Apply following filters
#      | Filter         | value          |
#      | <filter_name>  | <filter_value> |
#    Then  Custom filter results verification
#      | Filter         | value          |
#      | <filter_name>  | <filter_value> |


  Scenario: Verify that search displays related results by clicking Search button
    When  Search for "dress"
    And   Click on Search button
    And   All items are somewhat dress related

  Scenario: Verify that search displays related results by pressing Return/Enter key
    When  Search for "dress"
    And   Press Return/Enter key
    Then  All items are somewhat dress related

  Scenario: Verify that search displays error message when no results matched
    When  Search for "dress"
    And   Click on Search button
    Then  Error message displayed

  Scenario: Verify that search displays category menu when search field is empty
    When  Search for "dress"
    And   Click on Search button
    Then  Category menu displayed

  Scenario: Verify that search displays auto-fixed results on misspelling
    When  Search for "dryss"
    And   Click on Search button
    Then  All items are somewhat dress related

  Scenario: Verify max length of search field
    When  Search for text
   """11 Lorem ipsum dolor sit amet, nonummy ligula volutpat hac integer nonummy. Suspendisse
   ultricies, congue etiam tellus, erat libero, nulla eleifend, mauris pellentesque. Suspendisse
   integer praesent vel, integer gravida mauris, fringilla vehicula lacinia none
   """
    Then  Search fiel accepts text
   """Lorem ipsum dolor sit amet, nonummy ligula volutpat hac integer nonummy. Suspendisse
   ultricies, congue etiam tellus, erat libero, nulla eleifend, mauris pellentesque. Suspendisse
   integer praesent vel, integer gravida mauris, fringilla vehicula lacinia non
   """

  Scenario: Verify that search is not case sensitive

  Scenario: Verify that search field is XSS protected
    When  Search for "1'“()%26%25<acx><ScRiPt%20>ohKJ(9820)</ScRiPt>"
    And   Click on Search button
    Then  Redirected to Access Denied page

  Scenario: Verify that search field accepts Unicode
    When  Search for "उനЬa#ɊЦ1"
    And   Click on Search button
    Then  Category menu displayed

   # Autocomplete menu
  Scenario: Verify that autocomplete menu contains search word in each row
    When Search for "dress"
    And  Autocomplete menu displayed
    Then Autocomplete menu shows "dress" related results is in every row

  Scenario: Verify that it is able to search from autocomplete menu using click
    When Search for "dress"
    And  Autocomplete menu displayed
    And  Click on Search button
    Then All items are somewhat dress related

  Scenario: Verify that it is able to search from autocomplete menu using keyboard
    When Search for "dress"
    And  Autocomplete menu displayed
    And  Press Return/Enter key
    Then All items are somewhat dress related

  Scenario: Verify that autocomplete menu displays last search results when search field is empty
    When Search for "dress"
    And  Click on Search button
    And  Redirect back to previous page
    And  Click on Search field
    Then Autocomplete menu displays "dress"

  Scenario: Verify that autocomplete menu displays last search results when search field contains last search

  Scenario: Verify that autocomplete results are auto-fixed on misspelled search
    When Search for "druss"
    And  Autocomplete menu displayed
    Then Autocomplete menu displays "dress"

  Scenario: Verify that autocomplete menu displays last search results in bold font
    When Search for "dress"
    And  Autocomplete menu displayed
    Then Last "dress" words are bolded

  Scenario: Verify that autocomplete menu does not display new search words in bold font
    When Search for "dress"
    And  Autocomplete menu displayed
    Then New "dress" words are not bolded







