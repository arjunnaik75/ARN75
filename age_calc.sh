#!/bin/bash

# Ask for Name
read -p "Enter your name : " name
name=$name

# Ask for date of birth in format YYYY-MM-DD
read -p "Enter your date of birth (YYYY-MM-DD): " dob

# Convert DOB and current date into seconds since epoch
birth_sec=$(date -d "$dob" +%s)
current_sec=$(date +%s)

# Difference in seconds
diff_sec=$((current_sec - birth_sec))

# Convert difference back into date components
years=$(date -u -d "@$diff_sec" +%Y)
months=$(date -u -d "@$diff_sec" +%m)
days=$(date -u -d "@$diff_sec" +%d)

# Adjust years (since epoch starts at 1970)
age_years=$((years - 1970))
age_months=$((months - 1))
age_days=$((days - 1))

echo "Hello $name,"
echo "Your Age is: $age_years years, $age_months months, $age_days days"
