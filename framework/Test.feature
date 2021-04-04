Feature: Ebay Search

  Background: Open URL
    When  Open eBay.com

  # --- Search related ---

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

  Scenario: Verify that search displays auto-fixed results on misspelling
    When  Search for "dryss"
    And   Click on Search button
    Then  All items are somewhat "dress" related

  Scenario: Verify max length of search field
    When  Search for text
   """Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore
   magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
   consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
   """
    Then  Search field reach out of max length

  Scenario: Verify that search is not case sensitive
    When  Search for "DrEss"
    And   Click on Search button
    And   All items are somewhat "dress" related

  Scenario: Verify that search field is XSS protected
    When  Search for "1'“()%26%25<acx><ScRiPt%20>ohKJ(9820)</ScRiPt>"
    And   Click on Search button
    Then  Redirected to "Access Denied" page

  Scenario: Verify that search field accepts Unicode
    When  Search for "उനЬa#ɊЦ1"
    And   Click on Search button
    Then  No results error message displayed

  # --- Search - Autocomplete menu ---

  Scenario: Verify that autocomplete menu contains search word in each row
  Scenario: Verify that it is able to search from autocomplete menu using click
  Scenario: Verify that it is able to search from autocomplete menu using keyboard
  Scenario: Verify that autocomplete menu displays last search results when search field is empty
  Scenario: Verify that autocomplete menu displays last search results when search field contains last search
  Scenario: Verify that autocomplete results are auto-fixed on misspelled search
  Scenario: Verify that autocomplete menu displays last search results in bold font

  # --- Header Navigation ---

  Scenario Outline: Verify it is able to navigate from Header menu
    When Click on "<link_name>" link on the header navigation
    Then Redirected to "<title>" page

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

  Scenario Outline: Verify that Shoes and Dress search filtered correctly
    Given Open eBay.com
    And   Search for "<search_item>"
    And   Click on Search button
    And   Apply following filters
      | Filter           | value            |
      | <filter_name_1>  | <filter_value_1> |
      | <filter_name_2>  | <filter_value_2> |

    Then  Custom filter results verification
      | Filter           | value            |
      | <filter_name_1>  | <filter_value_1> |
      | <filter_name_2>  | <filter_value_2> |

    Examples: Dress
      | search_item    | filter_name_1    | filter_value_1  | filter_name_2    | filter_value_2  |
      | dress          | Brand            | Zara            | Dress Length     | Midi            |