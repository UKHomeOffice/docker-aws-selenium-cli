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

jira_username = os.getenv('jirausername')
jira_password = os.getenv('jirapassword')
logging.basicConfig(level = logging.INFO)


now = datetime.now()
now_in_utc = datetime.utcnow()
filename = f"{now.strftime('%Y-%b-%d')}--0100.zip"

def jira_restore():
    
    driver = webdriver.Chrome(options=chrome_options)
    try:
        logging.info(f"{now_in_utc} Starting the function")
        driver.get("https://jira.shs-dev.dsa-notprod.homeoffice.gov.uk/secure/admin/XmlRestore!default.jspa")
        element = driver.find_element_by_xpath("//*[@id='login-form-username']").send_keys(jira_username)
        element = driver.find_element_by_xpath("//*[@id='login-form-password']").send_keys(jira_password)
        element = driver.find_element_by_xpath("//*[@id='login-form-submit']").click()
        logging.info(f"{now_in_utc} Logging in to jira as api user")
        WebDriverWait(driver, 20).until(EC.visibility_of_element_located((By.XPATH, "//*[@id='login-form-authenticatePassword']")))
        logging.info(f"{now_in_utc} Successfully logged into jira as api user")
        logging.info(f"{filename}")
    except:
        logging.exception(f"{now_in_utc} Failed to log in")
        driver.close 
        quit()
    try:
        element = driver.find_element_by_xpath("//*[@id='login-form-authenticatePassword']").send_keys(jira_password)
        element = driver.find_element_by_xpath("//*[@id='login-form-submit']").click()
        logging.info(f"{now_in_utc} Authenticating to jira as an admin")
        WebDriverWait(driver, 20).until(EC.visibility_of_element_located((By.XPATH, "//*[@id='restore-xml-data-backup-file-name']")))
        logging.info(f"{now_in_utc} Successfully authenticated as a jira admin")
    except:
        logging.exception(f"{now_in_utc} Failed to log in as admin")
        driver.close
        quit()
    try:
        file = driver.find_element_by_xpath("//*[@id='restore-xml-data-backup-file-name']").send_keys(filename)
        logging.info(f"{now_in_utc} found and sent filename section")
        restorebutton = driver.find_element_by_xpath("//*[@id='restore-xml-data-backup-submit']").click()
        logging.info(f"{now_in_utc} found and clicked restore button")
        time.sleep(30)
    except:
        logging.exception(f"{now_in_utc} failed to enter filename")
        driver.close
        quit()

    if "importprogress?" in driver.current_url:
        logging.info(f"{now_in_utc} Beginning restoration")
    else:
        error_element = driver.find_element_by_xpath("/html/body/div/div/section/div[2]/div/main/form/div[1]/fieldset[1]/div/div[1]").get_attribute('value')
        if error_element:
            logging.exception(f"{now_in_utc} failed to start restoration - {error_element}")
            driver.close
            quit()
        else:
            logging.exception(f"{now_in_utc} failed to start restoration - {error_element}")
            driver.close
            quit()

    logging.info(f"{now_in_utc} Attempting jira restore...")
    logging.info(f"{driver.current_url}")
    x = True
    while x:
        try:
            driver.find_element_by_xpath("//*[@id='main']/div[1]/p")
            x = False
            logging.info(f"{now_in_utc} Successfully restored jira")
            driver.close
        except:
            try:
                driver.find_element_by_xpath("/html/body/div/div/div/div/main/div[2]/p[2]/a")
                x = False
                logging.info(f"{now_in_utc} Successfully restored jira")
                driver.close
            except:
                try:
                    driver.find_element_by_xpath("/html/body/div[1]/div/div/div/main/form/div[2]/div/input")
                    x = False
                    logging.info(f"{now_in_utc} Successfully restored jira")
                    driver.close
                except:
                    logging.info(f"{now_in_utc} Restoration is still ongoing")
                    time.sleep(60)


       

if __name__ == "__main__":
    jira_restore()
    # //*[@id="main"]/div[1]/p
    # //*[@id="main"]/div[1]