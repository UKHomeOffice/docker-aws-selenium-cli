import time
import json
import datetime
from datetime import datetime
import logging 
import os
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_prefs = {}
chrome_options.experimental_options["prefs"] = chrome_prefs
chrome_prefs["profile.default_content_settings"] = {"images": 2}

jira_username = os.getenv('jira-username')
jira_password = os.getenv('jira-password')
logger = logging.Logger('catch_all')

now = datetime.now()
filename = f"{now.strftime('%Y-%b-%d')}--0100.zip"


def jira_restore():
    
    driver = webdriver.Chrome(options=chrome_options)
    try:
        
        driver.get(f"https://jira.shs-dev.dsa-notprod.homeoffice.gov.uk/secure/admin/XmlRestore!default.jspa")
        element = driver.find_element_by_xpath("//*[@id='login-form-username']").send_keys(jira_username)
        element = driver.find_element_by_xpath("//*[@id='login-form-password']").send_keys(jira_password)
        element = driver.find_element_by_xpath("//*[@id='login-form-submit']").click()
        WebDriverWait(driver, 20).until(EC.visibility_of_element_located((By.XPATH, "//*[@id='login-form-authenticatePassword']")))
    except:
        logger.exception('Failed to log in')
        raise 
    try:
        element = driver.find_element_by_xpath("//*[@id='login-form-authenticatePassword']").send_keys(jira_password)
        element = driver.find_element_by_xpath("//*[@id='login-form-submit']").click()
        WebDriverWait(driver, 20).until(EC.visibility_of_element_located((By.XPATH, "//*[@id='restore-xml-data-backup-file-name']")))

    except:
        logger.exception('Failed to log in as admin')
        raise
    try:
        file = driver.find_element_by_xpath("//*[@id='restore-xml-data-backup-file-name']").send_keys(filename)
        restorebutton = driver.find_element_by_xpath("//*[@id='restore-xml-data-backup-submit']".click()
        sleep(60)
    except:
        logger.exception('Failed to restore jira')
        raise
    driver.close

if __name__ == "__main__":
    logging.basicConfig(level=logging.WARNING, format='%(asctime)s:%(levelname)7s:%(message)s')
    logging.info("start")
    jira_restore()
    logging.info("end")