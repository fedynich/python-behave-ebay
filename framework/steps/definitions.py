from behave import step
from telnetlib import EC
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


@step("Open eBay.com")
def open_url(context):
    context.browser.get(context.url)


@step('Search for "{text}"')
def search_text(context, text):
    WebDriverWait(context.browser, 5) \
        .until(EC.presence_of_element_located((By.XPATH, "//input[contains(@class, 'ui-autocomplete-input')]")),
               message='Search bar was not located') \
        .send_keys(f"{text}")


@step("Click on Search button")
def click_search_button(context):
    WebDriverWait(context.browser, 5) \
        .until(EC.presence_of_element_located((By.XPATH, "//input[@id='gh-btn']")),
               message='Search button was not found') \
        .click()


@step('Filter by "{label}" in category "{header}"')
def apply_filter_single(context, header, label):
    apply_filter(context, header, label)


@step('Apply following filters')
def apply_filter_multiple(context):
    for filter in context.table.rows:
        header = filter['Filter']
        label_checkbox = filter['value']

        apply_filter(context, header, label_checkbox)


def apply_filter(context, header, label):
    expand_filter(context, header)
    checkbox = context.browser \
        .find_elements_by_xpath(f"//li[@class='x-refine__main__list '][.//h3[text()='{header}']]"
                                f"//div[@class='x-refine__select__svg'][.//span[text()='{label}']]"
                                f"//input")
    if not checkbox:
        raise ValueError(f'No filter by label {label} in category {header}')

    checkbox[0].click()


def expand_filter(context, header):
    isCollapsed = context \
        .browser.find_elements_by_xpath(f"//li[@class='x-refine__main__list '][.//h3[text()='{header}']]"
                                        f"//parent::div[@aria-expanded='false']")

    if isCollapsed:
        isCollapsed[0].click()


@step("Custom filter results verification")
def filter_verification(context):
    original_page = context.browser.current_window_handle
    expected_spec = _get_expected_spec(context)
    suspicious_items = _get_suspicious_items(_get_item_link_and_title(context), expected_spec.values())

    mismatches = []

    for title, link in suspicious_items:
        context.browser.execute_script(f'window.open("{link}", "_blank");')
        context.browser.switch_to.window(context.browser.window_handles[-1])

        actual_spec = _get_actual_spec(_get_spec_keys(context))

        for k, v in expected_spec.items():
            if v not in actual_spec[k]:
                mismatches.append(title)
                break

        context.browser.close()
        context.browser.switch_to.window(original_page)

    if mismatches:
        raise ValueError(
            f"Following items do not satisfy filter criteria "
            f"{expected_spec.keys()}: {expected_spec.values()}\n {[mismatch for mismatch in mismatches]}")


def _get_spec_keys(context):
    return context.browser.find_elements_by_xpath("//div[@class='itemAttr']//td[@class='attrLabels']")


def _get_actual_spec(keys):
    return {key.text.strip(":"): key.find_element_by_xpath("following-sibling::td[.//*[text()]]").text for key in keys}


def _get_expected_spec(context):
    return {row['Filter']: row['value'] for row in context.table.rows}


def _get_suspicious_items(items, expected_labels):
    list_items = []

    for title, link in items:
        for label in expected_labels:
            if label.lower() not in title.lower():
                list_items.append((title, link))
                break

    return list_items


def _get_item_link_and_title(context):
    """Take items only in search results, as items from "Recently viewed items" can be counted"""
    items = context.browser.find_elements_by_xpath("//li[starts-with(@class, 's-item      ')]"
                                                   "[parent::ul[contains(@class, 'srp-results')]]")

    pairs = []
    for item in items:
        pairs.append((item.find_element_by_xpath("descendant::h3").text,
                      item.find_element_by_xpath("descendant::a").get_attribute("href")))

    return pairs
