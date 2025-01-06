from cs50 import SQL

#import database
database = SQL("sqlite:///fiftyville.db")

'license plates of all ppl leaving bakery 10:15 - 10:25'
clue1 = database.execute("SELECT people.name, bakery_security_logs.license_plate, bakery_security_logs.hour, bakery_security_logs.minute, bakery_security_logs.activity FROM people JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate WHERE month = 7 AND day = 28 AND hour = 10 AND minute <= 25 AND activity = 'exit' ORDER BY people.name")
license_plates = []
#print("name | license_plate | time")
for i in range(len(clue1)):
    #print(clue1[i]['name']+":",clue1[i]['license_plate']+",",clue1[i]['hour'],":",clue1[i]['minute'])
    license_plates.append(clue1[i]['name'])
#print(license_plates)

'ppl who withdrew money from ATM at Leggett St on 7/28'
atm_withdrawal = []
clue2 = database.execute("SELECT people.name, atm_transactions.amount FROM people JOIN bank_accounts ON people.id = bank_accounts.person_id JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw' ORDER BY people.name")
#print("name | amount")
for i in range(len(clue2)):
    #print(clue2[i]['name'], clue2[i]['amount'])
    atm_withdrawal.append(clue2[i]['name'])
#print(atm_withdrawal)

'matching names from clues 1&2'
match12 = database.execute("SELECT people.name FROM people JOIN bakery_security_logs ON bakery_security_logs.license_plate = people.license_plate WHERE month = 7 AND day = 28 AND hour = 10 AND minute <= 25 AND activity = 'exit' AND people.name IN(SELECT people.name FROM people JOIN bank_accounts ON people.id = bank_accounts.person_id JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number WHERE month = 7 AND day = 28 AND atm_location = 'Leggett Street' AND transaction_type = 'withdraw')")
#print(match12)
clue12name = []
for i in range(len(match12)):
    #print(match12[i]['name'])
    clue12name.append(match12[i]['name'])
#print(clue12name)

'finding caller'
clue3a = database.execute("SELECT people.name, phone_calls.caller, phone_calls.duration FROM phone_calls JOIN people ON people.phone_number = phone_calls.caller WHERE people.phone_number = phone_calls.caller AND month = 7 AND day = 28 AND duration <= 60 ORDER BY phone_calls.duration")
#print("name | caller | duration")
caller = []
for i in range(len(clue3a)):
    #print(clue3a[i]['name']+": "+clue3a[i]['caller'],"|",clue3a[i]['duration'])
    caller.append(clue3a[i]['name'])
#print(clue3aName)

'finding reciever of calls'
clue3aa = database.execute("SELECT people.name, phone_calls.receiver, phone_calls.duration FROM phone_calls JOIN people ON people.phone_number = phone_calls.receiver WHERE people.phone_number = phone_calls.receiver AND month = 7 AND day = 28 AND duration <= 60 ORDER BY phone_calls.duration")
receiver = []
for i in range(len(clue3aa)):
    #print(clue3aa[i]['name'])
    receiver.append(clue3aa[i]['name'])
#print(receiver)

'finding earliest flight leaving fiftyville on 7/29'
clue3b = database.execute("SELECT id, origin_airport_id, destination_airport_id, month, day, hour, minute FROM flights WHERE origin_airport_id IN(SELECT id FROM airports WHERE city = 'Fiftyville') AND day = 29 ORDER BY hour, minute")
flight_id, destination = clue3b[0]['id'], clue3b[0]['destination_airport_id']
#print("origin | destination | hour | minute")
#for i in range(len(clue3b)):
    #print(clue3b)
    #print(clue3b[i]['origin_airport_id'],"->", clue3b[i]['destination_airport_id'],"|",clue3b[i]['hour'],":", clue3b[i]['minute'])

'finding the destination city'
des_city = database.execute("SELECT city FROM airports WHERE id = (?)", destination)
des_city = des_city[0]['city']
#print(des_city)

'all ppl on earliest flight'
clue3bb = database.execute("SELECT name FROM people WHERE passport_number IN(SELECT passport_number FROM passengers WHERE flight_id = (?)) ORDER BY name", flight_id)
flight_list = []
for i in range(len(clue3bb)):
    flight_list.append(clue3bb[i]['name'])
#print(flight_list)

'Finding the thief'
# set(a) & set(b)
thief = list(set(license_plates) & set(atm_withdrawal) & set(caller) & set(flight_list))
#print(f"The thief is {thief}")

'Finding the co-conspirator'
accomplice = database.execute("SELECT people.name FROM phone_calls JOIN people ON people.phone_number = phone_calls.receiver WHERE people.phone_number = phone_calls.receiver AND month = 7 AND day = 28 AND duration <= 60 AND phone_calls.duration IN( SELECT phone_calls.duration FROM phone_calls JOIN people ON people.phone_number = phone_calls.caller WHERE people.phone_number = phone_calls.caller AND month = 7 AND day = 28 AND people.name = (?))", thief)
accomplice = accomplice[0]['name']
#print(accomplice)

print(f"The thief, {thief[0]}, escaped to {des_city} with the help of {accomplice}.")
