/*The Following Query used for List all Channels along with Their Frequencies and Types*/
SELECT Name AS 'Channel Name', freqancy AS 'Frequency', type AS 'Channel Type'
FROM VNC.Channel;




/*The Following Query used for List Total Salary of Managers per Department*/
SELECT M.department_dname AS 'Department Name', SUM(M.monthly_salary) AS 'Total Salary of Department'
FROM VNC.Manger M
GROUP BY M.department_dname;




/*The Following Query used for List the total number of episodes aired for each program*/
SELECT P.name AS 'Program Name', COUNT(E.enumber) AS 'Total Episodes Aired'
FROM VNC.Program P
LEFT JOIN VNC.Season S ON P.ID = S.program_ID
LEFT JOIN VNC.Episode E ON S.number = E.season_number
GROUP BY P.name;




/*The Following Query used for List live matches after a specific date*/
SELECT LM.*
FROM VNC.Live_match LM
WHERE LM.date > '2023-01-01';



/*The Following Query used for Display Matches with Their Sport Type*/
SELECT LM.date AS 'Sport Date',  P.type AS 'Sport Type',LM.start_time AS 'Start Time'
FROM VNC.Live_match LM
JOIN VNC.Sport S ON LM.sport_program_ID = S.program_ID
JOIN VNC.Program P ON S.program_ID = P.ID;



/*The Following Query used for List program name and type and the total duration of the programm*/
SELECT P.name AS 'Program Name', P.type AS 'Program Type', SUM(S.start_date) AS 'Total Duration'
FROM VNC.Program P
JOIN VNC.Season S ON P.ID = S.program_ID
GROUP BY P.type;




/*The Following Query used for List the channels hat don't have any associated studios yet*/
SELECT C.Name AS 'Channel Name', C.freqancy AS 'Channel Frequency'
FROM VNC.Channel C
LEFT JOIN VNC.Studio S ON C.freqancy = S.channel_freqancy
WHERE S.studio_id IS NULL
ORDER BY C.freqancy;




/*The Following Query used for List the Total Cost and Duration of Ads of each Sponsor*/
SELECT A.sponser_name, SUM(A.duration) AS Total_Duration, SUM(A.price_per_minute) AS Total_Cost
FROM VNC.Ads A
JOIN VNC.Show S ON A.sponser_name = S.Ads_sponser_name
GROUP BY A.sponser_name;




/*The Following Query used for Find the Total Cost of Devices in Each Type*/
SELECT D.type, SUM(D.cost) AS 'Total Cost'
FROM VNC.Device D
GROUP BY D.type;




/*The Following Query used for List program details with channel and studio information*/
SELECT P.name AS 'Program Name', C.Name AS 'Channel Name', S.location AS 'Studio Location'
FROM VNC.Program P
JOIN VNC.Show SH ON P.ID = SH.program_ID
JOIN VNC.Channel C ON SH.channel_freqancy = C.freqancy
JOIN VNC.Studio S ON SH.channel_freqancy = S.channel_freqancy;




/*The Following Query used for Finding Directors Who Have Managed More than one Season*/
SELECT CONCAT(P.fname, ' ', P.lname) AS 'Director Name', COUNT(DISTINCT SN.number) AS 'Seasons Managed'
FROM VNC.Director D
JOIN VNC.Staff S ON D.dssn = S.Person_ssn
JOIN VNC.Person P ON D.dssn = P.ssn
JOIN VNC.Season SN ON D.dssn = SN.dssn
GROUP BY CONCAT(P.fname, ' ', P.lname)
HAVING COUNT(DISTINCT SN.number) > 1;



/*The Following Query used for counting of different types of programs viewed on each channel*/
SELECT C.name AS 'Channel Name', C.freqancy AS 'Channel Frequency', COUNT(DISTINCT P.type) AS 'Number of Program Types'
FROM VNC.Channel C
LEFT JOIN VNC.Show S ON C.freqancy = S.channel_freqancy
LEFT JOIN VNC.Program P ON S.program_ID = P.ID
GROUP BY C.freqancy;




/*The Following Query used for List Engineers Handling More than Three Device Types*/
SELECT CONCAT(P.fname, ' ', P.lname) AS 'Engineer Full Name', COUNT(DISTINCT D.type) AS 'Device Types Count'
FROM VNC.Engineer E
JOIN VNC.Device D ON E.essn = D.essn
JOIN VNC.Person P ON E.essn = P.ssn
GROUP BY E.essn, `Engineer Full Name`
HAVING COUNT(DISTINCT D.type) > 3;



/*The Following Query used for List the count of devices per engineer and their total cost with engineer's full name*/
SELECT CONCAT(P.fname, ' ', P.lname) AS Engineer_Name, COUNT(D.serial_number) AS Device_Count, SUM(D.cost) AS Total_Cost
FROM VNC.Engineer E
JOIN VNC.Person P ON E.essn = P.ssn
JOIN VNC.Device D ON E.essn = D.essn
GROUP BY E.essn;



/*The Following Query used for List total cost of devices purchased in each department*/
SELECT D.dname AS 'Department Name', SUM(DV.cost) AS 'Total Cost of Devices'
FROM VNC.Department D
LEFT JOIN VNC.Staff S ON D.dname = S.department_dname
LEFT JOIN VNC.Engineer E ON S.Person_ssn = E.essn
LEFT JOIN VNC.Device DV ON E.essn = DV.essn
GROUP BY D.dname;



/*The Following Query used for List programs and their total number of episodes having more than 5 episodes*/
SELECT P.name AS 'Program Name', COUNT(*) AS 'Total Episodes'
FROM VNC.Program P
JOIN VNC.Season S ON P.ID = S.program_ID
JOIN VNC.Episode E ON S.number = E.season_number
GROUP BY P.name
HAVING COUNT(*) > 5;




/*The Following Query Retrieve the details of the channels that have studios associated with them the total number of devices used in each studio.*/
SELECT C.Name AS 'Channel Name' , C.freqancy AS 'Channel Frequency', S.studio_id AS 'Studio ID', COUNT(U.device_serial_number) AS 'Total Devices'
FROM VNC.Channel C
JOIN VNC.Studio S ON C.freqancy = S.channel_freqancy
LEFT JOIN VNC.Use U ON S.studio_id = U.Studio_studio_id
GROUP BY C.freqancy, S.studio_id
ORDER BY C.freqancy, S.studio_id;




/*The Following Query used for List channels with departments having more than 10 staff members*/
SELECT C.Name AS Channel_Name
FROM VNC.Channel C
JOIN VNC.Department D ON C.freqancy = D.channel_freqancy
JOIN VNC.Staff S ON D.dname = S.department_dname
GROUP BY C.Name
HAVING COUNT(DISTINCT S.Person_ssn) > 10;





/*The Following Query used for List channels with departments having more than 10 staff members*/
SELECT C.Name AS Channel_Name
FROM VNC.Channel C
JOIN VNC.Department D ON C.freqancy = D.channel_freqancy
JOIN VNC.Staff S ON D.dname = S.department_dname
JOIN VNC.Person P ON S.Person_ssn = P.ssn
GROUP BY C.Name
HAVING COUNT(DISTINCT P.ssn) > 10;






/*The Following Query used for List (name, job title, SSN, salary, and department) of employees working in the department with the highest average salary among all departments.*/
SELECT CONCAT(P.fname, ' ', P.lname) AS 'Person Name', S.job_title AS 'Job Title' ,S.Person_ssn AS 'SSN', S.monthly_salary AS 'Monthly Salary', S.department_dname AS 'Department Name'
FROM VNC.Staff S
JOIN VNC.Person P ON S.Person_ssn = P.ssn
WHERE S.department_dname = (
    SELECT department_dname
    FROM VNC.Staff
    GROUP BY department_dname
    HAVING AVG(monthly_salary) = (
        SELECT MAX(avg_salary)
        FROM (
            SELECT AVG(monthly_salary) AS avg_salary
            FROM VNC.Staff
            GROUP BY department_dname
        ) AS department_avg_salary
    )
);




