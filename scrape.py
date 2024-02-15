import requests
import pandas as pd

# URL of the GitHub API endpoint to list files in a repository directory
url = 'https://api.github.com/repos/DataTalksClub/zoomcamp-analytics/contents/data/de-zoomcamp-2023'

# Send a GET request to the GitHub API
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Extract the file names from the response JSON
    file_names = [file['name'] for file in response.json()]
    print(file_names)
    # Initialize an empty DataFrame to store all the data
    combined_data = pd.DataFrame()

    # Iterate over each file in the directory
    for file_name in file_names:
        # print(file_name)
        # Construct the URL for the raw CSV file
        file_url = f'https://raw.githubusercontent.com/DataTalksClub/zoomcamp-analytics/main/data/de-zoomcamp-2023/{file_name}'
        
        # dtypes = {
        # 'email': str,
        # 'time_homework': float,
        # 'time_lectures': float,   
        # }
        # Read the CSV data from the URL
        file_data = pd.read_csv(file_url)
        file_data['module']=file_name[:-4]
        # print(file_data.head())
        # Merge the data with the combined DataFrame based on the 'email' column
        if not combined_data.empty:
            combined_data = pd.merge(combined_data, file_data, on='email', how='outer',suffixes=('', f'_{file_name[:-4]}'))
        else:
            combined_data = file_data
    
    # Preview the combined data
    print("Preview of the combined data:")
    print(combined_data.head())
else:
    print("Failed to fetch file names. Status code:", response.status_code)
    
 # Write the final combined data to a CSV file
combined_data.to_csv('data/time_spent.csv', index=False)


# URL of the published Google Sheets document
url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vTbL00GcdQp0bJt9wf1ROltMq7s3qyxl-NYF7Pvk79Jfxgwfn9dNWmPD_yJHTDq_Wzvps8EIr6cOKWm/pubhtml'

# Read data from the Google Sheets document into a DataFrame
tables = pd.read_html(url,header=0,skiprows=1)

# Assuming 'leaderboard' is the first table extracted
leaderboard_df = tables[-1]

leaderboard_df.drop(columns=['1'],inplace=True)
# Preview the data
print(leaderboard_df.head())

leaderboard_df.to_csv('data/scores.csv',index=False)