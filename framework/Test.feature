Feature: Ebay Search

  # --- Search related ---
  Background: Open URL
    When  Open eBay.com

  Scenario: Verify that search displays related results by clicking Search button
    When  Search for "dress"
    And   Click on Search button
    And   All items are somewhat "dress" related

  Scenario: Verify that search displays related results by pressing Return/Enter key
    When  Search for "dress"
    And   Press Return/Enter key for Search button
    Then  All items are somewhat "dress" related

  Scenario: Verify that search displays error message when no results match
    When  Search for "find results by dummy search request"
    And   Click on Search button
    Then  No results error message displayed

  Scenario: Verify that search displays category menu when search is empty
    When  Click on Search button
    Then  All Categories page displayed

  Scenario: Verify that search displays category menu when search has only spaces
    When  Search for " "
    And  Click on Search button
    Then  All Categories page displayed

  Scenario Outline: Verify that search displays auto-fixed results on misspelling
    When  Search for "<misspelled>"
    And   Click on Search button
    Then  All items are somewhat "dress" related

    Examples: Misspelled Dress
      | misspelled  |
      | dryss       |
      | dres        |
      | dross       |

  Scenario: Verify max length of search field
    When  Search for text
   """Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore
   magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
   consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
   """
    Then  Search field reach out of max length

  Scenario Outline: Verify that search is not case sensitive
    When  Search for "<case>"
    And   Click on Search button
    And   All items are somewhat "dress" related
    Examples: XSS
      | case  |
      | Dress |
      | DRESS |
      | dReSS |

  Scenario Outline: Verify that search field is XSS protected
    When  Search for "<xss>"
    And   Click on Search button
    Then  Observing the "Access Denied" page
    Examples: XSS
    | xss                                             |
    | 1'“()%26%25<acx><ScRiPt%20>ohKJ(9820)</ScRiPt>  |
    | ,’“()&%<acx><ScRiPt >f9bK(9620)</ScRiPt>        |
    | coat’“()&%<acx><ScRiPt >l27G(9644)</ScRiPt>     |

  Scenario: Verify that search field accepts Unicode
    When  Search for "उനЬa#ɊЦ%"
    And   Click on Search button
    Then  No results error message displayed

  # --- Search: Autocomplete menu ---

  Scenario: Verify that autocomplete search menu contains search word in each row
    And  Search for "dress"
    Then All items are in autocomplete search somewhat "dress" related
    
  Scenario: Verify that it is able to search from autocomplete menu using click
  Scenario: Verify that it is able to search from autocomplete menu using keyboard
  Scenario: Verify that autocomplete menu displays last search results when search field is empty
  Scenario: Verify that autocomplete menu displays last search results when search field contains last search
  Scenario: Verify that autocomplete results are auto-fixed on misspelled search
  Scenario: Verify that autocomplete menu displays last search results in bold font

  # --- Header Navigation ---

  Scenario Outline: Verify it is able to navigate from Header menu
    When Click on "<link_name>" link on the header navigation
    Then Observing the "<title>" page

    Examples:
    | link_name      | title                                    |
    | Sell           | Sell                                     |
    | Sign In        | Sign In                                  |
    | My eBay        | Sign In                                  |
    | Daily Deals    | Daily Deals                              |
    | Brand Outlet   | Brand Outlet                             |
    | Help & Contact | Customer Service                         |
    | Watchlist      | Electronics, Cars, Fashion, Collectibles |
    | Alert          | Electronics, Cars, Fashion, Collectibles |

  Scenario: Verify that Shoes and Dress search filtered correctly
    Given Open eBay.com
    And   Search for "dress"
    And   Click on Search button
    And   Apply following filters
      | Filter           | value |
      | Brand            | Zara  |
      | Dress Length     | Midi  |

  Scenario Outline: Verify that Shoes and Dress search filtered correctly
    And   Search for "<search_item>"
    And   Click on Search button
    And   Apply following filters
      | Filter           | value            |
      | <filter_name_1>  | <filter_value_1> |
      | <filter_name_2>  | <filter_value_2> |
    Then  Filter results verification

    Examples: Dress
      | search_item      | filter_name_1    | filter_value_1  | filter_name_2    | filter_value_2  |
      | dress            | Brand            | Zara            | Dress Length     | Midi            |

    Examples: Shoes
      | search_item      | filter_name_1    | filter_value_1  | filter_name_2    | filter_value_2  |
      | shoes            | Brand            | Nike            | Upper Material   | Leather         |