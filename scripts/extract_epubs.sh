#!/bin/bash
set -e

cd /Users/simon/git/workforce_transformation || exit

mkdir -p .ingestion_staging/1 .ingestion_staging/2 .ingestion_staging/3 .ingestion_staging/4 .ingestion_staging/5

cp "src/resources/people_analytics/workforce_research/RESEARCH IN PERSONNEL AND HUMAN RESOURCES MANAGEMENT - JONATHON R. B. HALBESLEBEN M. RONALD BUCKLEY & WHEELER, ANTHONY R_.epub" .ingestion_staging/1/pilot.epub
cp "src/resources/hr_service_delivery/core_hr_administration/australia/Australian Master Human Resources Guide - Editors, C.epub" .ingestion_staging/2/pilot.epub
cp "src/resources/hr_service_delivery/core_hr_administration/Essential HR Handbook_ A Quick and Handy Resource for Any Mana or HR Professional, The - Sharon Armstrong & Barbara Mitchell.epub" .ingestion_staging/3/pilot.epub
cp "src/resources/centres_of_excellence/employee_relations_and_compliance/Labour and Employment Law Manual - Joydeep Hor.epub" .ingestion_staging/4/pilot.epub
cp "src/resources/centres_of_excellence/total_rewards/Your Total Rewards Playbook_ Compensation and Benefits for Global Teams - Oyster.epub" .ingestion_staging/5/pilot.epub

echo "Extracting File 1..."
cd .ingestion_staging/1 && epub2md -c pilot.epub && cd ../..
echo "Extracting File 2..."
cd .ingestion_staging/2 && epub2md -c pilot.epub && cd ../..
echo "Extracting File 3..."
cd .ingestion_staging/3 && epub2md -c pilot.epub && cd ../..
echo "Extracting File 4..."
cd .ingestion_staging/4 && epub2md -c pilot.epub && cd ../..
echo "Extracting File 5..."
cd .ingestion_staging/5 && epub2md -c pilot.epub && cd ../..

echo "Extraction complete."
