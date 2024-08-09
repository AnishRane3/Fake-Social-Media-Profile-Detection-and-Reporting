import sys
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split, cross_val_score
import matplotlib.pyplot as plt
import os
import io
import base64

# Load your data
data = pd.read_csv('C:\\Hackathon\\FSMPDR_ML\\insta_test.csv')

# Get the profile name from the command line argument
username = sys.argv[1]

# Check if the entered username is in the dataset
if username in data['USERNAME'].unique():
    # Split the data into features (X) and the target variable (y)
    features = [
        'profile pic', 'nums/length username', 'fullname words', 'nums/length fullname',
        'name==username', 'description length', 'external URL', 'private', '#posts',
        '#followers', '#follows'
    ]
    X = data[features]
    y = data['fake']

    # Split the data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train a machine learning model (Random Forest in this example)
    model = RandomForestClassifier()

    # Cross-validation and mean calculation
    cv_scores = cross_val_score(model, X_train, y_train, cv=5)  # 5-fold cross-validation
    mean_cv_score = cv_scores.mean()

    print(f'Mean Cross-Validation Score: {mean_cv_score}')

    # Fit the model on the training data
    model.fit(X_train, y_train)

    # Extract features for the specific profile
    profile_features = data[data['USERNAME'] == username][features]

    # Make prediction for the specific profile
    probabilities = model.predict_proba(profile_features)

    # Prepare the result DataFrame
    result_df = pd.DataFrame({
        'USERNAME': [username],
    })

    # Include all columns with values from the original dataset
    original_data = data[data['USERNAME'] == username]
    for column in data.columns:
        if column not in ['USERNAME', 'fake']:
            result_df[column] = original_data[column].values[0]

    # Append Fake Probability and Real Probability as the last two columns
    result_df['Fake Probability'] = probabilities[0][1] * 100
    result_df['Real Probability'] = probabilities[0][0] * 100

    # Check if the result_with_detection_ml_only.csv file already exists
    result_file = 'C:\\Hackathon\\FSMPDR_ML\\result_with_detection_ml_only.csv'
    if not os.path.isfile(result_file):
        # If not, write the column names to the file
        result_df.to_csv(result_file, mode='a', header=True, index=False)
    else:
        # If yes, check if the USERNAME is already present
        existing_data = pd.read_csv(result_file)
        if username in existing_data['USERNAME'].values:
            # If yes, update the existing row
            existing_data.loc[existing_data['USERNAME'] == username, ['Fake Probability', 'Real Probability']] = [probabilities[0][1] * 100, probabilities[0][0] * 100]
            existing_data.to_csv(result_file, mode='w', header=True, index=False)
        else:
            # If no, append the data without repeating the column names
            result_df.to_csv(result_file, mode='a', header=False, index=False)

    # Convert plots to base64-encoded images
    pie_buffer = io.BytesIO()
    fig_pie, ax_pie = plt.subplots(figsize=(12, 5))

    # Pie chart
    ax_pie.pie([probabilities[0][1] * 100, probabilities[0][0] * 100], labels=['Fake', 'Real'], autopct='%1.1f%%', startangle=90)
    ax_pie.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
    plt.savefig(pie_buffer, format='png')
    pie_image_base64 = base64.b64encode(pie_buffer.getvalue()).decode('utf-8')
    plt.close(fig_pie)  # Close the figure after saving the pie chart image

    # Convert plots to base64-encoded images for Bar Graph
    bar_buffer = io.BytesIO()
    fig_bar, ax_bar = plt.subplots(figsize=(8, 5))

    # Bar graph
    ax_bar.bar(['#posts', '#followers', '#follows'], original_data[['#posts', '#followers', '#follows']].values.flatten(), color=['darkblue', 'blue', 'lightblue'])
    plt.savefig(bar_buffer, format='png')
    bar_image_base64 = base64.b64encode(bar_buffer.getvalue()).decode('utf-8')
    plt.close(fig_bar)  # Close the figure after saving the bar graph image

    
    print(f'Features for : {features}')
    print(f'Username entered: {username}')
    print(f'Fake Probability for  {probabilities[0][1] * 100:.2f}')
    print(f'Real Probability for  {probabilities[0][0] * 100:.2f}')
    print(f'Pie Chart Image: data:image/png;base64,{pie_image_base64}')
    print(f'Bar Chart Image: data:image/png;base64,{bar_image_base64}')
    # Print "name == username: yes" or "name == username: no"
    name_equals_username_value = original_data['name==username'].values[0]
    print(f'name == username: {"yes" if name_equals_username_value == 1 else "no"}')
    # Print the description length
    description_length = original_data['description length'].values[0]
    print(f'Description length: {description_length}')
    # Print "external URL: yes" or "external URL: no"
    external_url_value = original_data['external URL'].values[0]
    print(f'external URL: {"yes" if external_url_value == 1 else "no"}')
    # Print "Profile pic: yes" or "Profile pic: no"
    profile_pic_value = original_data['profile pic'].values[0]
    print(f'Profile pic: {"yes" if profile_pic_value == 1 else "no"}')
    # Print "private: yes" or "private: no"
    private_value = original_data['private'].values[0]
    print(f'private: {"yes" if private_value == 1 else "no"}')
    # Print the number of posts of the input user
    num_posts = original_data['#posts'].values[0]
    print(f'Number of posts: {num_posts}')
    # Print the number of followers of the input user
    num_followers = original_data['#followers'].values[0]
    print(f'Number of followers: {num_followers}')
    # Print the number of follows of the input user
    num_follows = original_data['#follows'].values[0]
    print(f'Number of follows: {num_follows}')
    # Print the number of words in the full name of the input user
    fullname_words = original_data['fullname words'].values[0]
    print(f'Number of words in the full name: {fullname_words}')
    # Calculate the ratio of numbers to the length of the username
    num_username_ratio = original_data['nums/length username'].values[0]
    print(f'Ratio of numbers to the length of the username: {num_username_ratio}')
    # Calculate the ratio of numbers to the length of the full name
    num_fullname_ratio = original_data['nums/length fullname'].values[0]
    print(f'Ratio of numbers to the length of the full name: {num_fullname_ratio}')





else:
    print(f'Profile not found.')
