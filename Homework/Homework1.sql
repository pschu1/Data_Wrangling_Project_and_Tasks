# QBS 181 Homework 1 code
# Phillip Schuld f0040sz

-- save copy of Demographics table to edit
select * into pschuld.demographics from Demographics
-- 1)
-- a)
sp_rename 'pschuld.demographics.tri_age', 'Age', 'COLUMN';
-- b)
sp_rename 'pschuld.demographics.gendercode', 'GenderCode', 'COLUMN';
-- c)
sp_rename 'pschuld.demographics.contactid', 'ID', 'COLUMN';
-- d)
sp_rename 'pschuld.demographics.address1_stateorprovince', 'State', 'COLUMN';
-- e)
sp_rename 'pschuld.demographics.tri_imaginecareenrollmentemailsentdate', 'EmailSentDate', 'COLUMN';
-- f)
sp_rename 'pschuld.demographics.tri_enrollmentcompletedate', 'CompleteDate', 'COLUMN';
-- g)
ALTER TABLE pschuld.demographics 
add EnrollmentTimeDays as DATEDIFF(day, TRY_CONVERT(date, EmailSentDate, 101), TRY_CONVERT(date, CompleteDate, 101))

-- 2)
ALTER TABLE pschuld.demographics 
ADD EnrollmentStatus AS CASE
       WHEN tri_imaginecareenrollmentstatus = 167410011 THEN 'Complete'
       WHEN tri_imaginecareenrollmentstatus = 167410001 THEN 'Email Sent'
       WHEN tri_imaginecareenrollmentstatus = 167410004 THEN 'Non-Responder'
       WHEN tri_imaginecareenrollmentstatus = 167410005 THEN 'Facilitated Enrollment'
       WHEN tri_imaginecareenrollmentstatus = 167410002 THEN 'Incomplete Enrollments'
       WHEN tri_imaginecareenrollmentstatus = 167410003 THEN 'Opted Out'
       ELSE null
   end
   
-- 3)
ALTER TABLE pschuld.demographics 
ADD GenderName AS CASE
       WHEN try_convert(int, GenderCode) = 2 THEN 'Female'
       WHEN try_convert(int, GenderCode) = 1 THEN 'Male'
       WHEN try_convert(int, GenderCode) = 167410000 THEN 'Other'
       WHEN try_convert(int, GenderCode) is null THEN 'Unknown'
       ELSE null
   end
   
-- 4)
ALTER TABLE pschuld.demographics 
ADD AgeGroup AS CASE
       WHEN Age > 0 and Age <= 25 THEN '0-25'
       WHEN Age > 25 and Age <= 50 THEN '25-50'
       WHEN Age > 50 and Age <= 75 THEN '50-75'
       WHEN Age > 75 THEN 'Over 75'
       ELSE null
   end

ALTER TABLE pschuld.demographics DROP COLUMN gender;
   
-- print random 10 rows
SELECT TOP 10 * INTO pschuld.demographics_10 FROM pschuld.demographics
ORDER BY NEWID()

DROP TABLE pschuld.demographics_10 
