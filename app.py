import json

# Function to check users eating habits
def food_check(ulist, vlist):
    match = False
    ulist = [x.lower() for x in ulist] # change incase of upper/lower case mismatch
    vlist = [x.lower() for x in vlist]
    for i in ulist: # wont eat list
        if i in vlist: # loop thru venue food list
            match = True
        else:
            match = False
    if match == True: # if match is still true then add to avoid list
        return match

# Function to check users drinking habits 
def drinks_check(ulist, vlist):
    match = False
    ulist = [x.lower() for x in ulist] # change incase of upper/lower case mismatch
    vlist = [x.lower() for x in vlist]
    for i in ulist: # loop thru users favourite drinks
        if i in vlist: # does venue serve drink
            match = True
            return match # exit once drink is on list
        else:
            match = False
    return match

# Open json files 
with open('users.json') as f:
  users = json.load(f)
with open('venues.json') as g:
  venues = json.load(g)

# Setup output dictionary
output = dict()
output = {"places_to_visit":[],"places_to_avoid":[]}

# Loop thru all venues
for venue in venues:
    venue_food = venue["food"]
    venue_drinks = venue["drinks"] 
    reason = []
    
    # Loop thru each user per venue
    for user in users:
        user_food = user["wont_eat"] 
        user_drinks = user["drinks"] 
        
        # This will build reasons for avoid list
        if len(user_drinks) > 0:
            result = drinks_check(user_drinks, venue_drinks) # check user drinks against venue drinks list
            if result == False:
                reason.append("There is nothing for " + user["name"] + " to drink") # build reason list
        if len(venue_food) <= len(user_food) and len(user_food) > 0:
            avoid = food_check(user_food, venue_food) # check users wont eat list against venues food list 
            if avoid == True:
                reason.append("There is nothing for " + user["name"] + " to eat") # build reason list
    
    if len(reason) == 0: # Good to go, no reasons found
        output["places_to_visit"].append(venue["name"])
    else: # places to avoid
        mydict = {"name": venue["name"], "reason": reason}
        output["places_to_avoid"].append(mydict)

with open('output.json', 'w') as fp:
    json.dump(output, fp,indent = 3)

        


