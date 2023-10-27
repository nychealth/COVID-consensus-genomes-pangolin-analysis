import pandas as pd
from sklearn.metrics import adjusted_mutual_info_score
from sklearn.preprocessing import LabelEncoder

def preprocess_data(df):
    le = LabelEncoder()
    df['Call'] = le.fit_transform(df['Call'])
    return df

def compare_csv_files(file1, file2):
    df1 = pd.read_csv(file1)
    df2 = pd.read_csv(file2)
    
    # Merge data frames on Accession column
    merged_df = pd.merge(df1, df2, on='Accession', suffixes=('_file1', '_file2'), how='inner')
    
    # Preprocess data and extract relevant columns for AMI calculation
    df1_ami = preprocess_data(df1)
    df2_ami = preprocess_data(df2)
    features1 = df1_ami[['Call']].values.flatten()
    features2 = df2_ami[['Call']].values.flatten()
    
    # Calculate Adjusted Mutual Information
    ami = adjusted_mutual_info_score(features1, features2)
    
    # Count matches and mismatches
    matches = len(merged_df[merged_df['Call_file1'] == merged_df['Call_file2']])
    mismatches = len(merged_df[merged_df['Call_file1'] != merged_df['Call_file2']])
    
    # Calculate percentages
    total_entries = len(merged_df)
    match_percentage = (matches / total_entries) * 100
    mismatch_percentage = (mismatches / total_entries) * 100
    
    # Create summary table
    summary_df = pd.DataFrame({
        'Matches': [matches],
        'Mismatches': [mismatches],
        'Match Percentage': [match_percentage],
        'Mismatch Percentage': [mismatch_percentage],
        'Adjusted Mutual Information': [ami]
    })
    
    # Create detailed table
    detailed_df = merged_df[merged_df['Call_file1'] != merged_df['Call_file2']][['Accession', 'Call_file1', 'Call_file2']]
    
    # Save summary and detailed tables to CSV files
    summary_df.to_csv('comparison_summary.csv', index=False)
    detailed_df.to_csv('detailed_comparison.csv', index=False)

# Usage
compare_csv_files('file1.csv', 'file2.csv')
