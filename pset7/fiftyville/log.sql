-- Keep a log of any SQL queries you execute as you solve the mystery.

-- The theft took place on July 28, 2021 on Humphrey Street.
-- Finding out what time the theft took place and any witnesses
SELECT description
FROM crime_scene_reports
WHERE month = 7 AND day = 28 AND street = 'Humphrey Street';
/* Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery.
Interviews were conducted today with three witnesses who were present at the time –
each of their interview transcripts mentions the bakery. */

-- Grabbing the interviews from three witnesses
SELECT name, transcript
FROM interviews
WHERE month = 7 AND day = 28 AND transcript LIKE '%bakery%';
/*                                                                                                                
| Ruth    | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
| Eugene  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
| Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket.

Clues:
(1) Thief left the bakery parking lot between 10:15 - 10:25 am
(2) Thief withdrew money from ATM on Leggett Street earlier that day
(3a) Thief called co-conspirator, call lasted less than one minute
(3b) Co-conspirator bought the earliest possible plane ticket to leave Fiftyville tomorrow (7/29)
*/


'Clue 1'
-- Find license plate of potential thief by checking bakery_security_logs
-- Print all people/license plates of people leaving between 10:15 - 10:25
SELECT people.name, bakery_security_logs.license_plate, bakery_security_logs.hour, bakery_security_logs.minute, bakery_security_logs.activity
FROM people
JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate
WHERE month = 7 AND day = 28 AND hour = 10 AND minute <= 25 AND activity = 'exit'
ORDER BY people.name;
/*+---------+---------------+------+--------+----------+
|  name   | license_plate | hour | minute | activity |
+---------+---------------+------+--------+----------+
| Barry   | 6P58WS2       | 10   | 18     | exit     |
| Bruce   | 94KL13X       | 10   | 18     | exit     |
| Diana   | 322W7JE       | 10   | 23     | exit     |
| Iman    | L93JTIZ       | 10   | 21     | exit     |
| Kelsey  | 0NTHK55       | 10   | 23     | exit     |
| Luca    | 4328GD8       | 10   | 19     | exit     |
| Sofia   | G412CB7       | 10   | 20     | exit     |
| Vanessa | 5P2BI95       | 10   | 16     | exit     |
+---------+---------------+------+--------+----------+*/


'Clue 2'
-- Get names/withdrawal amounts for ATM use at Leggett St. on 7/28
-- via people(), bank_accounts() and atm_transactions tables()
SELECT people.name, atm_transactions.amount
FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
WHERE month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw'
ORDER BY people.name;
/*+---------+--------+
|  name   | amount |
+---------+--------+
| Benista | 30     |
| Brooke  | 80     |
| Bruce   | 50     |
| Diana   | 35     |
| Iman    | 20     |
| Kenny   | 20     |
| Luca    | 48     |
| Taylor  | 60     |
+---------+--------+*/

-- Check matching names for Clue 1 and Clue 2 for suspects
SELECT people.name
FROM people
JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate
WHERE month = 7 AND day = 28 AND hour = 10 AND minute <= 25 AND activity = 'exit'
AND people.name IN(
    SELECT people.name
    FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
    WHERE month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw');
/*+-------+
| name  |
+-------+
| Bruce |
| Luca  |
| Iman  |
| Diana |
+-------+*/


'Clue 3a'
-- Thief called as they left bakery - call with co-conspirator lasted less than one minute
-- Find caller for calls 1 min or less (theif)
SELECT people.name, phone_calls.caller, phone_calls.duration
FROM phone_calls
JOIN people ON people.phone_number = phone_calls.caller
WHERE people.phone_number = phone_calls.caller AND month = 7 AND day = 28 AND duration <= 60
ORDER BY phone_calls.duration;
/*+---------+----------------+----------+
|  name   |     caller     | duration |
+---------+----------------+----------+
| Kelsey  | (499) 555-9472 | 36       |
| Carina  | (031) 555-6622 | 38       |
| Taylor  | (286) 555-6063 | 43       |
| Bruce   | (367) 555-5533 | 45       |
| Diana   | (770) 555-1861 | 49       |
| Kelsey  | (499) 555-9472 | 50       |
| Sofia   | (130) 555-0289 | 51       |
| Benista | (338) 555-6650 | 54       |
| Kenny   | (826) 555-1652 | 55       |
| Kathryn | (609) 555-5876 | 60       |
+---------+----------------+----------+*/

-- Find receiver for calls 1 min or less (co-conspirator)
SELECT people.name, phone_calls.receiver, phone_calls.duration
FROM phone_calls
JOIN people ON people.phone_number = phone_calls.receiver
WHERE people.phone_number = phone_calls.receiver AND month = 7 AND day = 28 AND duration <= 60
ORDER BY phone_calls.duration;
/*+------------+----------------+----------+
|    name    |    receiver    | duration |
+------------+----------------+----------+
| Larry      | (892) 555-8872 | 36       |
| Jacqueline | (910) 555-3251 | 38       |
| James      | (676) 555-6554 | 43       |
| Robin      | (375) 555-8161 | 45       |
| Philip     | (725) 555-3243 | 49       |
| Melissa    | (717) 555-1342 | 50       |
| Jack       | (996) 555-8899 | 51       |
| Anna       | (704) 555-2131 | 54       |
| Doris      | (066) 555-9701 | 55       |
| Luca       | (389) 555-5198 | 60       |
+------------+----------------+----------+*/


'Clue 3b'
-- Co-conspirator bought earliest possible plane ticket around 10:15am leaving Fiftyville tomorrow 7/29
-- Show all flights originating from Fiftyville leaving on 7/29
SELECT id, origin_airport_id, destination_airport_id, month, day, hour, minute
FROM flights
WHERE origin_airport_id IN(
    SELECT id FROM airports WHERE city = 'Fiftyville')
AND day = 29
ORDER BY hour, minute;
/*+----+-------------------+------------------------+-------+-----+------+--------+
| id | origin_airport_id | destination_airport_id | month | day | hour | minute |
+----+-------------------+------------------------+-------+-----+------+--------+
| 36 | 8                 | 4                      | 7     | 29  | 8    | 20     |
| 43 | 8                 | 1                      | 7     | 29  | 9    | 30     |
| 23 | 8                 | 11                     | 7     | 29  | 12   | 15     |
| 53 | 8                 | 9                      | 7     | 29  | 15   | 20     |
| 18 | 8                 | 6                      | 7     | 29  | 16   | 0      |
+----+-------------------+------------------------+-------+-----+------+--------+
Earliest possible flight = id 36. */

-- Finding out which city the thief is departing to
SELECT city
FROM airports
WHERE id IN(
    SELECT destination_airport_id
    FROM flights
    WHERE id = 36);
/*+---------------+
|     city      |
+---------------+
| New York City |
+---------------+*/

-- All people on flight 36
SELECT name
FROM people
WHERE passport_number IN(
    SELECT passport_number
    FROM passengers
    WHERE flight_id = 36)
    ORDER BY name;
/*+--------+
|  name  |
+--------+
| Bruce  |
| Doris  |
| Edward |
| Kelsey |
| Kenny  |
| Luca   |
| Sofia  |
| Taylor |
+--------+*/


'Finding the perpetrators'
-- Union of Clue 1, Clue 2, Clue 3a and Clue 3b to find the thief
SELECT people.name -- License Plate clue
FROM people
JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate
WHERE month = 7 AND day = 28 AND hour = 10 AND minute <= 25 AND activity = 'exit'
AND people.name IN( -- ATM withdrawal clue
    SELECT people.name
    FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
    WHERE month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw')
AND people.name IN( -- Phone caller clue
    SELECT people.name
    FROM phone_calls
    JOIN people ON people.phone_number = phone_calls.caller
    WHERE people.phone_number = phone_calls.caller AND month = 7 AND day = 28 AND duration <= 60)
AND people.name IN( -- Flight 36 clue
    SELECT name
    FROM people
    WHERE passport_number IN(
    SELECT passport_number
    FROM passengers
    WHERE flight_id = 36));
/*+-------+
| name  |
+-------+
| Bruce |
+-------+*/

-- Finding co-conspirator by referencing thief's phone call duration to the receiver call table
SELECT people.name
FROM phone_calls
JOIN people ON people.phone_number = phone_calls.receiver
WHERE people.phone_number = phone_calls.receiver
AND month = 7 AND day = 28 AND duration <= 60
AND phone_calls.duration IN(
    SELECT phone_calls.duration
    FROM phone_calls
    JOIN people ON people.phone_number = phone_calls.caller
    WHERE people.phone_number = phone_calls.caller AND month = 7 AND day = 28 AND people.name = 'Bruce');
/*+-------+
| name  |
+-------+
| Robin |
+-------+*/