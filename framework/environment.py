from selenium import webdriver
import re


def before_all(context):
    context.url = 'https://www.ebay.com/sch/i.html?_from=R40&_nkw=shoes&_sacat=0&LH_TitleDesc=0&rt=nc&Brand=Nike&_dcat=93427'
def before_scenario(context, scenario):
    context.browser = webdriver.Chrome()

def after_step(context, step):
    if step.status == 'failed':
        step_name = re.sub('[^a-zA-Z \n\.]', '', step.name)
        print(step.name)
        context.browser.save_screenshot(f'{step_name}.png')

def after_scenario(context, scenario):
    context.browser.close()
    context.browser.quit()

