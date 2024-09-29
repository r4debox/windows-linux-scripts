import os
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import requests
import time

# Set the path for the temporary folder
tmp_folder_path = os.path.join(os.getcwd(), 'tmp')

# Create the "tmp" folder if it doesn't exist
os.makedirs(tmp_folder_path, exist_ok=True)

# Set Chrome options for headless mode and specify the download location
chrome_options = Options()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_experimental_option("prefs", {
  "download.default_directory": tmp_folder_path
})

# Set Chrome options and driver with the specified options
driver = webdriver.Chrome(options=chrome_options)

# Navigate to the desired webpage
url = 'https://www.star.nesdis.noaa.gov/goes/conus_band.php?sat=G16&band=05&length=240&dim=0'
driver.get(url)

try:
    # Wait for the "downloadGIF" element to be clickable
    download_gif_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.ID, 'downloadGIF'))
    )

    # Click on the "downloadGIF" element
    download_gif_button.click()

    # Wait for some time (adjust as needed)
    driver.implicitly_wait(10)

    # Click on the "Download animated GIF" link by locating it using its text content
    download_link = WebDriverWait(driver, 30).until(
        EC.element_to_be_clickable((By.XPATH, "//a[text()='Download animated GIF']"))
    )

    # Get the file name from the download link
    file_name = download_link.get_attribute("download")

    # Set the path for the downloaded file within the "tmp" folder
    file_path = os.path.join(tmp_folder_path, file_name)

    download_link.click()
    print("After WebDriverWait for download_button")

    # Wait for the file to be completely downloaded (adjust the waiting time if needed)
    time.sleep(10)  # Sleep for 30 seconds

    # Check if the file size is under 8MB
    if os.path.getsize(file_path) <= 8 * 1024 * 1024:
        # Send the file to a webhook (replace 'YOUR_WEBHOOK_URL' with the actual URL)
        webhook_url = 'YOUR_WEBHOOK_URL'
        with open(file_path, 'rb') as file_content:
            files = {'file': (file_name, file_content)}
            response = requests.post(webhook_url, files=files)

            # Print the response from the webhook
            print(response.text)
    else:
        # Compress the file using ffmpeg
        compressed_file_path = os.path.join(tmp_folder_path, "compressed_" + file_name)
        ffmpeg_command = f"ffmpeg -i {file_path} -vf scale=iw/1.5:ih/1.5 {compressed_file_path}"

        # Run the ffmpeg command
        os.system(ffmpeg_command)

        # Check if the compressed file size is still within 8MB
        if os.path.getsize(compressed_file_path) <= 8 * 1024 * 1024:
            # Send the compressed file to a webhook (replace 'YOUR_WEBHOOK_URL' with the actual URL)
            webhook_url = 'YOUR_WEBHOOK_URL'
            with open(compressed_file_path, 'rb') as file_content:
                files = {'file': (file_name, file_content)}
                response = requests.post(webhook_url, files=files)

                # Print the response from the webhook
                print(response.text)
        else:
            print("Compressed file size still exceeds 8MB limit.")

finally:
    # Close the browser window
    driver.quit()