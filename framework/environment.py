from selenium.webdriver.chrome.options import Options
from selenium import webdriver
import re


def before_all(context):
    context.url = 'https://www.ebay.com'


def before_scenario(context, scenario):
    context.browser = webdriver.Chrome()
    context.browser.delete_all_cookies()


def after_step(context, step):
    if step.status == 'failed':
        step_name = re.sub('[^a-zA-Z \n\.]', '', step.name)
        print(step.name)
        context.browser.save_screenshot(f'{step_name}.png')


def after_scenario(context, scenario):
    context.browser.close()
    context.browser.quit()

