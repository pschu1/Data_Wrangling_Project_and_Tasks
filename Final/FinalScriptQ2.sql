select * into pschuld.merged from Demographics a
inner join Conditions b 
on a.contactid = b.tri_patientid 
inner join Text c
on c.tri_contactId = a.contactid 
inner join PhoneCall d 
on d.tri_CustomerIDEntityReference = a.contactid

 SELECT *
 FROM
 (
     SELECT ROW_NUMBER() OVER (PARTITION BY contactid ORDER BY TextSentDate) as RowNum, *
     FROM pschuld.merged
 ) X 
 WHERE RowNum = 1
