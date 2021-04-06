from behave import step
from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


@step('Open eBay.com')
def some_test_impl(context):
    context.browser.get(context.url)


@step('Search for "{text}"')
def search_text(context, text):
    WebDriverWait(context.browser, 5) \
        .until(EC.presence_of_element_located((By.XPATH, "//input[@id='gh-ac']")),
               message='Search bar was not located').\
        send_keys(f"{text}")


@step("Search for text")
def search_text(context):
    get_search_field(context).send_keys(context.text)


@step("Click on Search button")
def click_search_button(context):
    WebDriverWait(context.browser, 5) \
        .until(EC.presence_of_element_located((By.XPATH, "//input[@id='gh-btn']")),
               message='Search button was not found') \
        .click()


@step("Press Return/Enter key for Search button")
def press_enter_for_search_button(context):
    get_search_button(context).send_keys(Keys.ENTER)


# --- Helpers ---
def get_search_field(context):
    return context.browser.find_element_by_xpath("//input[@id='gh-ac']")


def get_search_button(context):
    return context.browser.find_element_by_xpath("//input[@id='gh-btn']")

# ---- Assertions ---


@step("Search field reach out of max length")
def max_length_search(context):
    actual_text = get_search_field(context).get_attribute("value")
    expected_length = 300

    if len(actual_text) != expected_length:
        raise ValueError(f"Max length of search field does not meet expectations:\n"
                         f"Expected: {expected_length}\n"
                         f"Actual: {len(actual_text)}\n"
                         f"\"{actual_text}\"")


@step('All items are somewhat "{search}" related')
def all_items_contain_search(context, search):
    search_items = context.browser.find_elements_by_xpath(f"//li[starts-with(@class, 's-item      ')]"
                                                          "[parent::ul[contains(@class, 'srp-results')]]")

    for item in search_items:
        if search.lower() not in item.text.lower():
            raise ValueError(f"Some items are not {search} related:\n {item.text}")


@step("All Categories page displayed")
def all_categories_page(context):
    try:
        context.browser.find_element_by_xpath(f"//div[@class='all-cats-container']//child::h1[text()='All Categories']")
    except NoSuchElementException:
        raise ValueError("All categories page has not been found")


@step("No results error message displayed")
def no_results_error(context):
    try:
        context.browser\
            .find_element_by_xpath("//h3[@class='srp-save-null-search__heading']/text()='No exact matches found'")
    except NoSuchElementException:
        raise ValueError("\"No exact matches found\" error message has not been displayed ")


@step('Filter by "{label}" in category "{header}"')
def apply_filter_single(context, header, label):
    _apply_filter(context, header, label)


@step('Apply following filters')
def apply_filter_multiple(context):
    for row in context.table.rows:
        header = row['Filter']
        label_checkbox = row['value']

        _apply_filter(context, header, label_checkbox)


def _apply_filter(context, header, label):
    _expand_filter(context, header)
    checkbox = context.browser \
        .find_elements_by_xpath(f"//li[@class='x-refine__main__list '][.//h3[text()='{header}']]"
                                f"//div[@class='x-refine__select__svg'][.//span[text()='{label}']]"
                                f"//input")
    if not checkbox:
        raise ValueError(f'No filter by label {label} in category {header}')

    checkbox[0].click()


def _expand_filter(context, header):
    isCollapsed = context \
        .browser.find_elements_by_xpath(f"//li[@class='x-refine__main__list '][.//h3[text()='{header}']]"
                                        f"//parent::div[@aria-expanded='false']")

    if isCollapsed:
        isCollapsed[0].click()


@step("Custom filter results verification")
def filter_verification(context):
    expected_spec = _get_expected_spec(context)
    suspicious_items = _get_suspicious_items(context, expected_spec.values())

    mismatches = []
    original_page = context.browser.current_window_handle

    for title, link in suspicious_items:
        context.browser.execute_script(f'window.open("{link}", "_blank");')
        context.browser.switch_to.window(context.browser.window_handles[-1])

        actual_spec = _get_actual_spec(context)

        for k, v in expected_spec.items():
            if v.lower() not in actual_spec[k].lower():
                mismatches.append(title)
                break

        context.browser.close()
        context.browser.switch_to.window(original_page)

    if mismatches:
        raise ValueError(
            f"Following items do not satisfy filter criteria "
            f"{expected_spec.keys()}: {expected_spec.values()}\n {mismatches}")


def _get_actual_spec(context):
    keys = context.browser.find_elements_by_xpath("//div[@class='itemAttr']//td[@class='attrLabels']")

    return {key.text.strip(":"): key.find_element_by_xpath("following-sibling::td[.//*[text()]]").text for key in keys}


def _get_expected_spec(context):
    headings = context.table.headings

    return {row[headings[0]]: row[headings[1]] for row in context.table.rows}


def _get_suspicious_items(context, expected_labels):
    items = _get_items_data(context)

    list_items = []

    for title, link in items:
        for label in expected_labels:
            if label.lower() not in title.lower():
                list_items.append((title, link))
                break

    return list_items


def _get_items_data(context):
    """Take items only in search results, as items from "Recently viewed items" can be counted"""
    items = context.browser.find_elements_by_xpath("//li[starts-with(@class, 's-item      ')]"
                                                   "[parent::ul[contains(@class, 'srp-results')]]")

    pairs = []
    for item in items:
        pairs.append((item.find_element_by_xpath("descendant::h3").text,
                      item.find_element_by_xpath("descendant::a").get_attribute("href")))

    return pairs


# --- Top navigation menu ---


@step('Click on "{link_name}" link on the header navigation')
def click_header_link(context, link_name):
    try:
        context.browser\
            .find_elements_by_xpath(f"//*[@class = contains(@class,'gh-') and contains(text(), '{link_name}')]")
    except NoSuchElementException:
        raise ValueError(f"{link_name} link does not exist")


@step('Observing the "{title}" page')
def is_page(context, title):
    if title.lower() not in context.browser.title.lower():
        raise ValueError(f"The page {title} has not been found")