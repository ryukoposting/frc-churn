ALL_REGIONS:=\
output/regions/arizona.json \
output/regions/australia.json \
output/regions/brazil.json \
output/regions/california.json \
output/regions/cal-bayarea.json \
output/regions/canada.json \
output/regions/canpac.json \
output/regions/centralgulf.json \
output/regions/chesapeke.json \
output/regions/china.json \
output/regions/colorado.json \
output/regions/eastasia.json \
output/regions/florida.json \
output/regions/hawaii.json \
output/regions/illinois.json \
output/regions/indiana.json \
output/regions/israel.json \
output/regions/mexico.json \
output/regions/michigan.json \
output/regions/michigan-detroit.json \
output/regions/fma.json \
output/regions/minnesota.json \
output/regions/twincities.json \
output/regions/mokan.json \
output/regions/ne.json \
output/regions/ny.json \
output/regions/nyc.json \
output/regions/nc.json \
output/regions/northland.json \
output/regions/ontario.json \
output/regions/peachtree.json \
output/regions/pennsylvania.json \
output/regions/pnw.json \
output/regions/quebec.json \
output/regions/southcentral.json \
output/regions/taiwan.json \
output/regions/texas.json \
output/regions/turkey.json \
output/regions/usa.json \
output/regions/utah.json \
output/regions/wisconsin.json

ALL_CSVS:=$(patsubst output/regions/%.json,output/csv/%.csv,$(ALL_REGIONS))

OUTPUT_ZIP:=output/churnrate-$(shell date '+%y%m%d').zip

$(OUTPUT_ZIP): $(ALL_CSVS) output/report.md | output
	zip -r "$@" output/1280x800/* output/csv/ output/report.md

output/report.md: $(ALL_CSVS) $(ALL_REGIONS) generate-report.rb | output
	ruby generate-report.rb $(ALL_REGIONS)

output/csv/%.csv: output/regions/%.json calculate-churn-rate.rb | output/csv output/1280x800/teams output/1280x800/churn
	ruby calculate-churn-rate.rb $<

output/regions/arizona.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa arizona \
    'Arizona' \
    'Arizona'

output/regions/australia.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb australia \
    'Australia' \
    'Australia'

output/regions/brazil.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb brazil \
    'Brazil' \
    'Brazil'

output/regions/california.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa california \
    'California' \
    'California'

# San Francisco, Alameda, San Mateo, Contra Costa,
# Santa Clara, Marin, Solano, Sonoma, Napa counties
output/regions/cal-bayarea.json: output/all-teams.json fetch-city.rb | output/regions
	ruby fetch-city.rb --region usa cal-bayarea \
    'California Bay Area' \
    'Alameda' 'California' \
    'Albany' 'California' \
    'American Canyon' 'California' \
    'Antioch' 'California' \
    'Atherton' 'California' \
    'Belmont' 'California' \
    'Belvedere' 'California' \
    'Benicia' 'California' \
    'Berkeley' 'California' \
    'Brentwood' 'California' \
    'Brisbane' 'California' \
    'Burlingame' 'California' \
    'Calistoga' 'California' \
    'Campbell' 'California' \
    'Clayton' 'California' \
    'Cloverdale' 'California' \
    'Colma' 'California' \
    'Concord' 'California' \
    'Corte Madera' 'California' \
    'Cotati' 'California' \
    'Cupertino' 'California' \
    'Daly City' 'California' \
    'Danville' 'California' \
    'Dixon' 'California' \
    'Dublin' 'California' \
    'East Palo Alto' 'California' \
    'El Cerrito' 'California' \
    'Emeryville' 'California' \
    'Fairfax' 'California' \
    'Fairfield' 'California' \
    'Foster City' 'California' \
    'Fremont' 'California' \
    'Gilroy' 'California' \
    'Half Moon Bay' 'California' \
    'Hayward' 'California' \
    'Healdsburg' 'California' \
    'Hercules' 'California' \
    'Hillsborough' 'California' \
    'Lafayette' 'California' \
    'Larkspur' 'California' \
    'Livermore' 'California' \
    'Los Altos Hills' 'California' \
    'Los Altos' 'California' \
    'Los Gatos' 'California' \
    'Martinez' 'California' \
    'Menlo Park' 'California' \
    'Mill Valley' 'California' \
    'Millbrae' 'California' \
    'Milpitas' 'California' \
    'Monte Sereno' 'California' \
    'Moraga' 'California' \
    'Morgan Hill' 'California' \
    'Mountain View' 'California' \
    'Napa' 'California' \
    'Newark' 'California' \
    'Novato' 'California' \
    'Oakland' 'California' \
    'Oakley' 'California' \
    'Orinda' 'California' \
    'Pacifica' 'California' \
    'Palo Alto' 'California' \
    'Petaluma' 'California' \
    'Piedmont' 'California' \
    'Pinole' 'California' \
    'Pittsburg' 'California' \
    'Pleasant Hill' 'California' \
    'Pleasanton' 'California' \
    'Portola Valley' 'California' \
    'Redwood City' 'California' \
    'Richmond' 'California' \
    'Rio Vista' 'California' \
    'Rohnert Park' 'California' \
    'Ross' 'California' \
    'San Anselmo' 'California' \
    'San Bruno' 'California' \
    'San Carlos' 'California' \
    'San Francisco' 'California' \
    'San Jose' 'California' \
    'San Leandro' 'California' \
    'San Mateo' 'California' \
    'San Pablo' 'California' \
    'San Rafael' 'California' \
    'San Ramon' 'California' \
    'Santa Clara' 'California' \
    'Santa Rosa' 'California' \
    'Saratoga' 'California' \
    'Sausalito' 'California' \
    'Sebastopol' 'California' \
    'Sonoma' 'California' \
    'South San Francisco' 'California' \
    'St. Helena' 'California' \
    'Suisun City' 'California' \
    'Sunnyvale' 'California' \
    'Tiburon' 'California' \
    'Union City' 'California' \
    'Vacaville' 'California' \
    'Vallejo' 'California' \
    'Walnut Creek' 'California' \
    'Windsor' 'California' \
    'Woodside' 'California' \
    'Yountville' 'California'

output/regions/canada.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb canada \
    'Canada' \
    'Canada'

output/regions/canpac.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region canada canpac \
    'Canada Pacific (AB, BC)' \
    'British Columbia' 'Alberta'

output/regions/centralgulf.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa centralgulf \
    'Central Gulf Coast (AL, MS, LA)' \
    'Alabama' 'Mississippi' 'Louisiana'

output/regions/chesapeke.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa chesapeke \
    'Chesapeke' \
    'DC' 'Maryland' 'Virginia'

output/regions/china.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb china \
    'China' \
    'China'

output/regions/colorado.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa colorado \
    'Colorado' \
    'Colorado'

output/regions/eastasia.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb eastasia \
    'East Asia' \
    'Chinese Taipei' 'China' 'Japan' 'South Korea' 'Vietnam' 'Philippines' 'Malaysia'

output/regions/florida.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa florida \
    'Florida' \
    'Florida'

output/regions/hawaii.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa hawaii \
    'Hawaii' \
    'Hawaii'

output/regions/illinois.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa illinois \
    'Illinois' \
    'Illinois'

output/regions/indiana.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa indiana \
    'Indiana' \
    'Indiana'

output/regions/israel.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb israel \
    'Israel' \
    'Israel'

output/regions/mexico.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb mexico \
    'Mexico' \
    'Mexico'

output/regions/michigan.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa michigan \
    'Michigan' \
    'Michigan'

# Wayne, Washtenaw, Oakland, Monroe, Macomb counties
output/regions/michigan-detroit.json: output/all-teams.json fetch-city.rb | output/regions
	ruby fetch-city.rb --region usa michigan-detroit \
    'Detroit Metro' \
    'Allen Park' 'Michigan' \
    'Ann Arbor' 'Michigan' \
    'Armada' 'Michigan' \
    'Auburn Hills' 'Michigan' \
    'Azalia' 'Michigan' \
    'Belleville' 'Michigan' \
    'Berkley' 'Michigan' \
    'Birmingham' 'Michigan' \
    'Bloomfield Hills' 'Michigan' \
    'Bridgewater' 'Michigan' \
    'Canton' 'Michigan' \
    'Carleton' 'Michigan' \
    'Center Line' 'Michigan' \
    'Chelsea' 'Michigan' \
    'Clarkston' 'Michigan' \
    'Clawson' 'Michigan' \
    'Clinton Township' 'Michigan' \
    'Commerce Township' 'Michigan' \
    'Davisburg' 'Michigan' \
    'Dearborn Heights' 'Michigan' \
    'Dearborn' 'Michigan' \
    'Detroit' 'Michigan' \
    'Dexter' 'Michigan' \
    'Dundee' 'Michigan' \
    'Eastpointe' 'Michigan' \
    'Ecorse' 'Michigan' \
    'Erie' 'Michigan' \
    'Farmington' 'Michigan' \
    'Ferndale' 'Michigan' \
    'Flat Rock' 'Michigan' \
    'Franklin' 'Michigan' \
    'Fraser' 'Michigan' \
    'Garden City' 'Michigan' \
    'Grosse Ile' 'Michigan' \
    'Grosse Pointe' 'Michigan' \
    'Hamtramck' 'Michigan' \
    'Harper Woods' 'Michigan' \
    'Harrison Township' 'Michigan' \
    'Hazel Park' 'Michigan' \
    'Highland Park' 'Michigan' \
    'Highland' 'Michigan' \
    'Holly' 'Michigan' \
    'Huntington Woods' 'Michigan' \
    'Ida' 'Michigan' \
    'Inkster' 'Michigan' \
    'Keego Harbor' 'Michigan' \
    'La Salle' 'Michigan' \
    'Lake Orion' 'Michigan' \
    'Lakeville' 'Michigan' \
    'Lambertville' 'Michigan' \
    'Leonard' 'Michigan' \
    'Lincoln Park' 'Michigan' \
    'Livonia' 'Michigan' \
    'Luna Pier' 'Michigan' \
    'Macomb' 'Michigan' \
    'Madison Heights' 'Michigan' \
    'Manchester' 'Michigan' \
    'Maybee' 'Michigan' \
    'Melvindale' 'Michigan' \
    'Milan' 'Michigan' \
    'Milford' 'Michigan' \
    'Monroe' 'Michigan' \
    'Mount Clemens' 'Michigan' \
    'New Baltimore' 'Michigan' \
    'New Boston' 'Michigan' \
    'New Haven' 'Michigan' \
    'New Hudson' 'Michigan' \
    'Newport' 'Michigan' \
    'Northville' 'Michigan' \
    'Novi' 'Michigan' \
    'Oak Park' 'Michigan' \
    'Oakland' 'Michigan' \
    'Ortonville' 'Michigan' \
    'Ottawa Lake' 'Michigan' \
    'Oxford' 'Michigan' \
    'Petersburg' 'Michigan' \
    'Pleasant Ridge' 'Michigan' \
    'Plymouth' 'Michigan' \
    'Pontiac' 'Michigan' \
    'Ray' 'Michigan' \
    'Redford' 'Michigan' \
    'Richmond' 'Michigan' \
    'River Rouge' 'Michigan' \
    'Riverview' 'Michigan' \
    'Rochester' 'Michigan' \
    'Rockwood' 'Michigan' \
    'Romeo' 'Michigan' \
    'Romulus' 'Michigan' \
    'Roseville' 'Michigan' \
    'Royal Oak' 'Michigan' \
    'Saint Clair Shores' 'Michigan' \
    'Salem' 'Michigan' \
    'Saline' 'Michigan' \
    'Samaria' 'Michigan' \
    'South Lyon' 'Michigan' \
    'South Rockwood' 'Michigan' \
    'Southfield' 'Michigan' \
    'Southgate' 'Michigan' \
    'Sterling Heights' 'Michigan' \
    'Taylor' 'Michigan' \
    'Temperance' 'Michigan' \
    'Trenton' 'Michigan' \
    'Troy' 'Michigan' \
    'Union Lake' 'Michigan' \
    'Utica' 'Michigan' \
    'Walled Lake' 'Michigan' \
    'Warren' 'Michigan' \
    'Washington' 'Michigan' \
    'Waterford' 'Michigan' \
    'Wayne' 'Michigan' \
    'West Bloomfield' 'Michigan' \
    'Westland' 'Michigan' \
    'White Lake' 'Michigan' \
    'Whitmore Lake' 'Michigan' \
    'Whittaker' 'Michigan' \
    'Willis' 'Michigan' \
    'Wixom' 'Michigan' \
    'Wyandotte' 'Michigan' \
    'Ypsilanti' 'Michigan'

output/regions/fma.json: output/all-teams.json fetch-district.rb | output/regions
	ruby fetch-district.rb --region usa fma \
    'Mid-Atlantic District'

output/regions/minnesota.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa minnesota \
    'Minnesota' \
    'Minnesota'

# Ramsey, Hennepin, and parts of Dakota and Washington County
output/regions/twincities.json: output/all-teams.json fetch-city.rb | output/regions
	ruby fetch-city.rb --region usa twincities \
    'Twin Cities Metro' \
    'Apple Valley' 'Minnesota' \
    'Arden Hills' 'Minnesota' \
    'Blaine' 'Minnesota' \
    'Bloomington' 'Minnesota' \
    'Brooklyn Center' 'Minnesota' \
    'Brooklyn Park' 'Minnesota' \
    'Burnsville' 'Minnesota' \
    'Champlin' 'Minnesota' \
    'Chanhassen' 'Minnesota' \
    'Corcoran' 'Minnesota' \
    'Crystal' 'Minnesota' \
    'Dayton' 'Minnesota' \
    'Deephaven' 'Minnesota' \
    'Eagan' 'Minnesota' \
    'Eden Prairie' 'Minnesota' \
    'Edina' 'Minnesota' \
    'Excelsior' 'Minnesota' \
    'Falcon Heights' 'Minnesota' \
    'Gem Lake' 'Minnesota' \
    'Golden Valley' 'Minnesota' \
    'Greenfield' 'Minnesota' \
    'Greenwood' 'Minnesota' \
    'Hanover' 'Minnesota' \
    'Hopkins' 'Minnesota' \
    'Independence' 'Minnesota' \
    'Inver Grove Heights' 'Minnesota' \
    'Lakeville' 'Minnesota' \
    'Lauderdale' 'Minnesota' \
    'Lilydale' 'Minnesota' \
    'Little Canada' 'Minnesota' \
    'Long Lake' 'Minnesota' \
    'Loretto' 'Minnesota' \
    'Maple Grove' 'Minnesota' \
    'Maple Plain' 'Minnesota' \
    'Maplewood' 'Minnesota' \
    'Medicine Lake' 'Minnesota' \
    'Medina' 'Minnesota' \
    'Minneapolis' 'Minnesota' \
    'Minneapolis' 'Minnesota' \
    'Minnetonka Beach' 'Minnesota' \
    'Minnetonka' 'Minnesota' \
    'Minnetrista' 'Minnesota' \
    'Mound' 'Minnesota' \
    'Mounds View' 'Minnesota' \
    'New Brighton' 'Minnesota' \
    'New Hope' 'Minnesota' \
    'North Oaks' 'Minnesota' \
    'North Saint Paul' 'Minnesota' \
    'North St. Paul' 'Minnesota' \
    'Oakdale' 'Minnesota' \
    'Orono' 'Minnesota' \
    'Osseo' 'Minnesota' \
    'Plymouth' 'Minnesota' \
    'Richfield' 'Minnesota' \
    'Robbinsdale' 'Minnesota' \
    'Rockford' 'Minnesota' \
    'Rogers' 'Minnesota' \
    'Rosemount' 'Minnesota' \
    'Roseville' 'Minnesota' \
    'Saint Anthony' 'Minnesota' \
    'Saint Bonifacius' 'Minnesota' \
    'Saint Louis Park' 'Minnesota' \
    'Saint Paul' 'Minnesota' \
    'Shakopee' 'Minnesota' \
    'Shoreview' 'Minnesota' \
    'Shorewood' 'Minnesota' \
    'South Saint Paul' 'Minnesota' \
    'South St. Paul' 'Minnesota' \
    'Spring Lake Park' 'Minnesota' \
    'Spring Park' 'Minnesota' \
    'St. Anthony' 'Minnesota' \
    'St. Bonifacius' 'Minnesota' \
    'St. Louis Park' 'Minnesota' \
    'St. Paul' 'Minnesota' \
    'Sunfish Lake' 'Minnesota' \
    'Tonka Bay' 'Minnesota' \
    'Vadnais Heights' 'Minnesota' \
    'Wayzata' 'Minnesota' \
    'West Saint Paul' 'Minnesota' \
    'West St. Paul' 'Minnesota' \
    'White Bear Lake' 'Minnesota' \
    'Woodbury' 'Minnesota' \
    'Woodland' 'Minnesota'

output/regions/mokan.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa mokan \
    'Missouri-Kansas' \
    'Missouri' 'Kansas'

output/regions/ne.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa ne \
    'New England' \
    'Massachusetts' 'Maine' 'New Hampshire' 'Vermont' 'Connecticut' 'Rhode Island'

output/regions/ny.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa ny \
    'New York' \
    'New York'

# Nassau, Suffolk, Essex, Union, Passaic, Bergen, Westchester, Rockland,
# Morris, Somerset, Middlesex, Monmouth counties
output/regions/nyc.json: output/all-teams.json fetch-city.rb | output/regions
	ruby fetch-city.rb --region usa nyc \
    'New York City' \
    'Adelphia' 'New Jersey' \
    'Albertson' 'New York' \
    'Allendale' 'New Jersey' \
    'Allenhurst' 'New Jersey' \
    'Allentown' 'New Jersey' \
    'Allenwood' 'New Jersey' \
    'Alpine' 'New Jersey' \
    'Amagansett' 'New York' \
    'Amawalk' 'New York' \
    'Amityville' 'New York' \
    'Aquebogue' 'New York' \
    'Ardsley On Hudson' 'New York' \
    'Ardsley' 'New York' \
    'Armonk' 'New York' \
    'Asbury Park' 'New Jersey' \
    'Atlantic Beach' 'New York' \
    'Atlantic Highlands' 'New Jersey' \
    'Avenel' 'New Jersey' \
    'Avon By The Sea' 'New Jersey' \
    'Babylon' 'New York' \
    'Baldwin Place' 'New York' \
    'Baldwin' 'New York' \
    'Basking Ridge' 'New Jersey' \
    'Bay Shore' 'New York' \
    'Bayport' 'New York' \
    'Bayville' 'New York' \
    'Bear Mountain' 'New York' \
    'Bedford Hills' 'New York' \
    'Bedford' 'New York' \
    'Bedminster' 'New Jersey' \
    'Belford' 'New Jersey' \
    'Belle Mead' 'New Jersey' \
    'Belleville' 'New Jersey' \
    'Bellmore' 'New York' \
    'Bellport' 'New York' \
    'Belmar' 'New Jersey' \
    'Bergenfield' 'New Jersey' \
    'Berkeley Heights' 'New Jersey' \
    'Bernardsville' 'New Jersey' \
    'Bethpage' 'New York' \
    'Blauvelt' 'New York' \
    'Blawenburg' 'New Jersey' \
    'Bloomfield' 'New Jersey' \
    'Bloomingdale' 'New Jersey' \
    'Blue Point' 'New York' \
    'Bogota' 'New Jersey' \
    'Bohemia' 'New York' \
    'Boonton' 'New Jersey' \
    'Bound Brook' 'New Jersey' \
    'Bradley Beach' 'New Jersey' \
    'Brentwood' 'New York' \
    'Briarcliff Manor' 'New York' \
    'Bridgehampton' 'New York' \
    'Bridgewater' 'New Jersey' \
    'Brielle' 'New Jersey' \
    'Brightwaters' 'New York' \
    'Bronxville' 'New York' \
    'Brookhaven' 'New York' \
    'Brookside' 'New Jersey' \
    'Buchanan' 'New York' \
    'Budd Lake' 'New Jersey' \
    'Butler' 'New Jersey' \
    'Caldwell' 'New Jersey' \
    'Calverton' 'New York' \
    'Carle Place' 'New York' \
    'Carlstadt' 'New Jersey' \
    'Carteret' 'New Jersey' \
    'Cedar Grove' 'New Jersey' \
    'Cedar Knolls' 'New Jersey' \
    'Cedarhurst' 'New York' \
    'Center Moriches' 'New York' \
    'Centereach' 'New York' \
    'Centerport' 'New York' \
    'Central Islip' 'New York' \
    'Chappaqua' 'New York' \
    'Chatham' 'New Jersey' \
    'Chester' 'New Jersey' \
    'Clark' 'New Jersey' \
    'Cliffside Park' 'New Jersey' \
    'Cliffwood' 'New Jersey' \
    'Clifton' 'New Jersey' \
    'Closter' 'New Jersey' \
    'Cold Spring Harbor' 'New York' \
    'Colonia' 'New Jersey' \
    'Colts Neck' 'New Jersey' \
    'Commack' 'New York' \
    'Congers' 'New York' \
    'Convent Station' 'New Jersey' \
    'Copiague' 'New York' \
    'Coram' 'New York' \
    'Cortlandt Manor' 'New York' \
    'Cranbury' 'New Jersey' \
    'Cranford' 'New Jersey' \
    'Cream Ridge' 'New Jersey' \
    'Cresskill' 'New Jersey' \
    'Crompond' 'New York' \
    'Cross River' 'New York' \
    'Croton Falls' 'New York' \
    'Croton On Hudson' 'New York' \
    'Cutchogue' 'New York' \
    'Dayton' 'New Jersey' \
    'Deal' 'New Jersey' \
    'Deer Park' 'New York' \
    'Demarest' 'New Jersey' \
    'Denville' 'New Jersey' \
    'Dobbs Ferry' 'New York' \
    'Dover' 'New Jersey' \
    'Dumont' 'New Jersey' \
    'Dunellen' 'New Jersey' \
    'East Brunswick' 'New Jersey' \
    'East Hampton' 'New York' \
    'East Hanover' 'New Jersey' \
    'East Islip' 'New York' \
    'East Marion' 'New York' \
    'East Meadow' 'New York' \
    'East Moriches' 'New York' \
    'East Northport' 'New York' \
    'East Norwich' 'New York' \
    'East Orange' 'New Jersey' \
    'East Quogue' 'New York' \
    'East Rockaway' 'New York' \
    'East Rutherford' 'New Jersey' \
    'East Setauket' 'New York' \
    'Eastchester' 'New York' \
    'Eastport' 'New York' \
    'Eatontown' 'New Jersey' \
    'Edgewater' 'New Jersey' \
    'Edison' 'New Jersey' \
    'Elizabeth' 'New Jersey' \
    'Elizabethport' 'New Jersey' \
    'Elmont' 'New York' \
    'Elmsford' 'New York' \
    'Elmwood Park' 'New Jersey' \
    'Emerson' 'New Jersey' \
    'Englewood Cliffs' 'New Jersey' \
    'Englewood' 'New Jersey' \
    'Englishtown' 'New Jersey' \
    'Essex Fells' 'New Jersey' \
    'Fair Haven' 'New Jersey' \
    'Fair Lawn' 'New Jersey' \
    'Fairfield' 'New Jersey' \
    'Fairview' 'New Jersey' \
    'Fanwood' 'New Jersey' \
    'Far Hills' 'New Jersey' \
    'Farmingdale' 'New Jersey' \
    'Farmingdale' 'New York' \
    'Farmingville' 'New York' \
    'Fishers Island' 'New York' \
    'Flagtown' 'New Jersey' \
    'Flanders' 'New Jersey' \
    'Floral Park' 'New York' \
    'Florham Park' 'New Jersey' \
    'Fords' 'New Jersey' \
    'Fort Lee' 'New Jersey' \
    'Fort Monmouth' 'New Jersey' \
    'Franklin Lakes' 'New Jersey' \
    'Franklin Park' 'New Jersey' \
    'Franklin Square' 'New York' \
    'Freehold' 'New Jersey' \
    'Freeport' 'New York' \
    'Garden City' 'New York' \
    'Garfield' 'New Jersey' \
    'Garnerville' 'New York' \
    'Garwood' 'New Jersey' \
    'Gillette' 'New Jersey' \
    'Gladstone' 'New Jersey' \
    'Glen Cove' 'New York' \
    'Glen Head' 'New York' \
    'Glen Ridge' 'New Jersey' \
    'Glen Rock' 'New Jersey' \
    'Glenwood Landing' 'New York' \
    'Goldens Bridge' 'New York' \
    'Granite Springs' 'New York' \
    'Great Neck' 'New York' \
    'Great River' 'New York' \
    'Green Village' 'New Jersey' \
    'Greenlawn' 'New York' \
    'Greenport' 'New York' \
    'Greenvale' 'New York' \
    'Hackensack' 'New Jersey' \
    'Haledon' 'New Jersey' \
    'Hampton Bays' 'New York' \
    'Harrington Park' 'New Jersey' \
    'Harrison' 'New York' \
    'Hartsdale' 'New York' \
    'Hasbrouck Heights' 'New Jersey' \
    'Haskell' 'New Jersey' \
    'Hastings On Hudson' 'New York' \
    'Hauppauge' 'New York' \
    'Haverstraw' 'New York' \
    'Haworth' 'New Jersey' \
    'Hawthorne' 'New Jersey' \
    'Hawthorne' 'New York' \
    'Hazlet' 'New Jersey' \
    'Helmetta' 'New Jersey' \
    'Hempstead' 'New York' \
    'Hewitt' 'New Jersey' \
    'Hewlett' 'New York' \
    'Hibernia' 'New Jersey' \
    'Hicksville' 'New York' \
    'Highland Park' 'New Jersey' \
    'Highlands' 'New Jersey' \
    'Hillburn' 'New York' \
    'Hillsborough' 'New Jersey' \
    'Hillsdale' 'New Jersey' \
    'Hillside' 'New Jersey' \
    'Ho Ho Kus' 'New Jersey' \
    'Holbrook' 'New York' \
    'Holmdel' 'New Jersey' \
    'Holtsville' 'New York' \
    'Howell' 'New Jersey' \
    'Huntington Station' 'New York' \
    'Huntington' 'New York' \
    'Imlaystown' 'New Jersey' \
    'Inwood' 'New York' \
    'Ironia' 'New Jersey' \
    'Irvington' 'New Jersey' \
    'Irvington' 'New York' \
    'Iselin' 'New Jersey' \
    'Island Park' 'New York' \
    'Islandia' 'New York' \
    'Islip Terrace' 'New York' \
    'Islip' 'New York' \
    'Jamesport' 'New York' \
    'Jefferson Valley' 'New York' \
    'Jericho' 'New York' \
    'Katonah' 'New York' \
    'Keansburg' 'New Jersey' \
    'Keasbey' 'New Jersey' \
    'Kendall Park' 'New Jersey' \
    'Kenilworth' 'New Jersey' \
    'Kenvil' 'New Jersey' \
    'Keyport' 'New Jersey' \
    'Kings Park' 'New York' \
    'Kingston' 'New Jersey' \
    'Lake Grove' 'New York' \
    'Lake Hiawatha' 'New Jersey' \
    'Lake Hopatcong' 'New Jersey' \
    'Landing' 'New Jersey' \
    'Larchmont' 'New York' \
    'Laurel' 'New York' \
    'Lawrence' 'New York' \
    'Ledgewood' 'New Jersey' \
    'Leonardo' 'New Jersey' \
    'Leonia' 'New Jersey' \
    'Levittown' 'New York' \
    'Liberty Corner' 'New Jersey' \
    'Lincoln Park' 'New Jersey' \
    'Lincolndale' 'New York' \
    'Lincroft' 'New Jersey' \
    'Linden' 'New Jersey' \
    'Lindenhurst' 'New York' \
    'Little Falls' 'New Jersey' \
    'Little Ferry' 'New Jersey' \
    'Little Silver' 'New Jersey' \
    'Livingston' 'New Jersey' \
    'Locust Valley' 'New York' \
    'Lodi' 'New Jersey' \
    'Long Beach' 'New York' \
    'Long Branch' 'New Jersey' \
    'Long Valley' 'New Jersey' \
    'Lynbrook' 'New York' \
    'Lyndhurst' 'New Jersey' \
    'Lyons' 'New Jersey' \
    'Madison' 'New Jersey' \
    'Mahwah' 'New Jersey' \
    'Malverne' 'New York' \
    'Mamaroneck' 'New York' \
    'Manasquan' 'New Jersey' \
    'Manhasset' 'New York' \
    'Manorville' 'New York' \
    'Manville' 'New Jersey' \
    'Maplewood' 'New Jersey' \
    'Marlboro' 'New Jersey' \
    'Martinsville' 'New Jersey' \
    'Maryknoll' 'New York' \
    'Massapequa Park' 'New York' \
    'Massapequa' 'New York' \
    'Mastic Beach' 'New York' \
    'Mastic' 'New York' \
    'Matawan' 'New Jersey' \
    'Mattituck' 'New York' \
    'Maywood' 'New Jersey' \
    'Medford' 'New York' \
    'Melville' 'New York' \
    'Mendham' 'New Jersey' \
    'Merrick' 'New York' \
    'Metuchen' 'New Jersey' \
    'Middle Island' 'New York' \
    'Middlesex' 'New Jersey' \
    'Middletown' 'New Jersey' \
    'Midland Park' 'New Jersey' \
    'Mill Neck' 'New York' \
    'Millburn' 'New Jersey' \
    'Miller Place' 'New York' \
    'Millington' 'New Jersey' \
    'Millstone Township' 'New Jersey' \
    'Milltown' 'New Jersey' \
    'Millwood' 'New York' \
    'Mine Hill' 'New Jersey' \
    'Mineola' 'New York' \
    'Mohegan Lake' 'New York' \
    'Monmouth Beach' 'New Jersey' \
    'Monmouth Junction' 'New Jersey' \
    'Monroe Township' 'New Jersey' \
    'Monsey' 'New York' \
    'Montauk' 'New York' \
    'Montclair' 'New Jersey' \
    'Montrose' 'New York' \
    'Montvale' 'New Jersey' \
    'Montville' 'New Jersey' \
    'Moonachie' 'New Jersey' \
    'Morganville' 'New Jersey' \
    'Moriches' 'New York' \
    'Morris Plains' 'New Jersey' \
    'Morristown' 'New Jersey' \
    'Mount Arlington' 'New Jersey' \
    'Mount Freedom' 'New Jersey' \
    'Mount Kisco' 'New York' \
    'Mount Sinai' 'New York' \
    'Mount Tabor' 'New Jersey' \
    'Mount Vernon' 'New York' \
    'Mountain Lakes' 'New Jersey' \
    'Mountainside' 'New Jersey' \
    'Nanuet' 'New York' \
    'Navesink' 'New Jersey' \
    'Neptune' 'New Jersey' \
    'Nesconset' 'New York' \
    'Neshanic Station' 'New Jersey' \
    'Netcong' 'New Jersey' \
    'New Brunswick' 'New Jersey' \
    'New City' 'New York' \
    'New Hyde Park' 'New York' \
    'New Milford' 'New Jersey' \
    'New Providence' 'New Jersey' \
    'New Rochelle' 'New York' \
    'New Suffolk' 'New York' \
    'New Vernon' 'New Jersey' \
    'New York City' 'New York' \
    'New York' 'New York' \
    'Newark' 'New Jersey' \
    'Newfoundland' 'New Jersey' \
    'North Arlington' 'New Jersey' \
    'North Babylon' 'New York' \
    'North Brunswick' 'New Jersey' \
    'North Salem' 'New York' \
    'Northport' 'New York' \
    'Northvale' 'New Jersey' \
    'Norwood' 'New Jersey' \
    'Nutley' 'New Jersey' \
    'Nyack' 'New York' \
    'Oak Ridge' 'New Jersey' \
    'Oakdale' 'New York' \
    'Oakhurst' 'New Jersey' \
    'Oakland' 'New Jersey' \
    'Ocean Beach' 'New York' \
    'Ocean Grove' 'New Jersey' \
    'Oceanport' 'New Jersey' \
    'Oceanside' 'New York' \
    'Old Bethpage' 'New York' \
    'Old Bridge' 'New Jersey' \
    'Old Westbury' 'New York' \
    'Oradell' 'New Jersey' \
    'Orange' 'New Jersey' \
    'Orangeburg' 'New York' \
    'Orient' 'New York' \
    'Ossining' 'New York' \
    'Oyster Bay' 'New York' \
    'Palisades Park' 'New Jersey' \
    'Palisades' 'New York' \
    'Paramus' 'New Jersey' \
    'Park Ridge' 'New Jersey' \
    'Parlin' 'New Jersey' \
    'Parsippany' 'New Jersey' \
    'Passaic' 'New Jersey' \
    'Patchogue' 'New York' \
    'Paterson' 'New Jersey' \
    'Peapack' 'New Jersey' \
    'Pearl River' 'New York' \
    'Peconic' 'New York' \
    'Peekskill' 'New York' \
    'Pelham' 'New York' \
    'Pequannock' 'New Jersey' \
    'Perth Amboy' 'New Jersey' \
    'Picatinny Arsenal' 'New Jersey' \
    'Piermont' 'New York' \
    'Pine Brook' 'New Jersey' \
    'Piscataway' 'New Jersey' \
    'Plainfield' 'New Jersey' \
    'Plainsboro' 'New Jersey' \
    'Plainview' 'New York' \
    'Pleasantville' 'New York' \
    'Point Lookout' 'New York' \
    'Pomona' 'New York' \
    'Pompton Lakes' 'New Jersey' \
    'Pompton Plains' 'New Jersey' \
    'Port Chester' 'New York' \
    'Port Jefferson Station' 'New York' \
    'Port Jefferson' 'New York' \
    'Port Monmouth' 'New Jersey' \
    'Port Reading' 'New Jersey' \
    'Port Washington' 'New York' \
    'Pound Ridge' 'New York' \
    'Purchase' 'New York' \
    'Purdys' 'New York' \
    'Quogue' 'New York' \
    'Rahway' 'New Jersey' \
    'Ramsey' 'New Jersey' \
    'Randolph' 'New Jersey' \
    'Raritan' 'New Jersey' \
    'Red Bank' 'New Jersey' \
    'Remsenburg' 'New York' \
    'Ridge' 'New York' \
    'Ridgefield Park' 'New Jersey' \
    'Ridgefield' 'New Jersey' \
    'Ridgewood' 'New Jersey' \
    'Ringwood' 'New Jersey' \
    'River Edge' 'New Jersey' \
    'Riverdale' 'New Jersey' \
    'Riverhead' 'New York' \
    'Rochelle Park' 'New Jersey' \
    'Rockaway' 'New Jersey' \
    'Rockville Centre' 'New York' \
    'Rocky Hill' 'New Jersey' \
    'Rocky Point' 'New York' \
    'Ronkonkoma' 'New York' \
    'Roosevelt' 'New Jersey' \
    'Roosevelt' 'New York' \
    'Roseland' 'New Jersey' \
    'Roselle Park' 'New Jersey' \
    'Roselle' 'New Jersey' \
    'Roslyn Heights' 'New York' \
    'Roslyn' 'New York' \
    'Rumson' 'New Jersey' \
    'Rutherford' 'New Jersey' \
    'Rye' 'New York' \
    'Saddle Brook' 'New Jersey' \
    'Saddle River' 'New Jersey' \
    'Sag Harbor' 'New York' \
    'Sagaponack' 'New York' \
    'Saint James' 'New York' \
    'Sayreville' 'New Jersey' \
    'Sayville' 'New York' \
    'Scarsdale' 'New York' \
    'Schooleys Mountain' 'New Jersey' \
    'Scotch Plains' 'New Jersey' \
    'Sea Cliff' 'New York' \
    'Sea Girt' 'New Jersey' \
    'Seaford' 'New York' \
    'Selden' 'New York' \
    'Sewaren' 'New Jersey' \
    'Shelter Island Heights' 'New York' \
    'Shelter Island' 'New York' \
    'Shenorock' 'New York' \
    'Shirley' 'New York' \
    'Shoreham' 'New York' \
    'Short Hills' 'New Jersey' \
    'Shrewsbury' 'New Jersey' \
    'Shrub Oak' 'New York' \
    'Skillman' 'New Jersey' \
    'Sloatsburg' 'New York' \
    'Smithtown' 'New York' \
    'Somers' 'New York' \
    'Somerset' 'New Jersey' \
    'Somerville' 'New Jersey' \
    'Sound Beach' 'New York' \
    'South Amboy' 'New Jersey' \
    'South Bound Brook' 'New Jersey' \
    'South Hackensack' 'New Jersey' \
    'South Jamesport' 'New York' \
    'South Orange' 'New Jersey' \
    'South Plainfield' 'New Jersey' \
    'South River' 'New Jersey' \
    'South Salem' 'New York' \
    'Southampton' 'New York' \
    'Southold' 'New York' \
    'Sparkill' 'New York' \
    'Speonk' 'New York' \
    'Spotswood' 'New Jersey' \
    'Spring Lake' 'New Jersey' \
    'Spring Valley' 'New York' \
    'Springfield' 'New Jersey' \
    'Stirling' 'New Jersey' \
    'Stony Brook' 'New York' \
    'Stony Point' 'New York' \
    'Succasunna' 'New Jersey' \
    'Suffern' 'New York' \
    'Summit' 'New Jersey' \
    'Syosset' 'New York' \
    'Tallman' 'New York' \
    'Tappan' 'New York' \
    'Tarrytown' 'New York' \
    'Teaneck' 'New Jersey' \
    'Tenafly' 'New Jersey' \
    'Teterboro' 'New Jersey' \
    'Thiells' 'New York' \
    'Thornwood' 'New York' \
    'Tomkins Cove' 'New York' \
    'Totowa' 'New Jersey' \
    'Towaco' 'New Jersey' \
    'Township of Washington' 'New Jersey' \
    'Tuckahoe' 'New York' \
    'Union' 'New Jersey' \
    'Uniondale' 'New York' \
    'Upton' 'New York' \
    'Valhalla' 'New York' \
    'Valley Cottage' 'New York' \
    'Valley Stream' 'New York' \
    'Vauxhall' 'New Jersey' \
    'Verona' 'New Jersey' \
    'Verplanck' 'New York' \
    'Waccabuc' 'New York' \
    'Wading River' 'New York' \
    'Wainscott' 'New York' \
    'Waldwick' 'New Jersey' \
    'Wallington' 'New Jersey' \
    'Wanaque' 'New Jersey' \
    'Wantagh' 'New York' \
    'Warren' 'New Jersey' \
    'Watchung' 'New Jersey' \
    'Water Mill' 'New York' \
    'Wayne' 'New Jersey' \
    'West Babylon' 'New York' \
    'West Harrison' 'New York' \
    'West Haverstraw' 'New York' \
    'West Hempstead' 'New York' \
    'West Islip' 'New York' \
    'West Long Branch' 'New Jersey' \
    'West Milford' 'New Jersey' \
    'West Nyack' 'New York' \
    'West Orange' 'New Jersey' \
    'West Sayville' 'New York' \
    'Westbury' 'New York' \
    'Westfield' 'New Jersey' \
    'Westhampton Beach' 'New York' \
    'Westhampton' 'New York' \
    'Westwood' 'New Jersey' \
    'Wharton' 'New Jersey' \
    'Whippany' 'New Jersey' \
    'White Plains' 'New York' \
    'Wickatunk' 'New Jersey' \
    'Williston Park' 'New York' \
    'Wood Ridge' 'New Jersey' \
    'Woodbridge' 'New Jersey' \
    'Woodbury' 'New York' \
    'Woodcliff Lake' 'New Jersey' \
    'Woodmere' 'New York' \
    'Wyandanch' 'New York' \
    'Wyckoff' 'New Jersey' \
    'Yaphank' 'New York' \
    'Yonkers' 'New York' \
    'Yorktown Heights' 'New York' \
    'Zarephath' 'New Jersey'

output/regions/nc.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa nc \
    'North Carolina' \
    'North Carolina'

output/regions/northland.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa northland \
    'Northland (MN, ND, SD)' \
    'Minnesota' 'North Dakota' 'South Dakota'

output/regions/ontario.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region canada ontario \
    'Ontario' \
    'Ontario'

output/regions/peachtree.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa peachtree \
    'Peachtree' \
    'Georgia'

output/regions/pennsylvania.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa pennsylvania \
    'Pennsylvania' \
    'Pennsylvania'

output/regions/pnw.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa pnw \
    'Pacific Northwest' \
    'Oregon' 'Washington'

output/regions/quebec.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region canada quebec \
    'Québec' \
    'Québec' 'Quebec'

output/regions/southcentral.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa southcentral \
    'South Central (TN, AR, KY)' \
    'Tennessee' 'Arkansas' 'Kentucky'

output/regions/taiwan.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb taiwan \
    'Taiwan' \
    'Chinese Taipei'

output/regions/texas.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa texas \
    'Texas' \
    'Texas'

output/regions/turkey.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb turkey \
    'Türkiye' \
    'Türkiye' 'Turkey'

output/regions/usa.json: output/all-teams.json fetch-country.rb | output/regions
	ruby fetch-country.rb usa \
    'USA' \
    'USA'

output/regions/utah.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa utah \
    'Utah' \
    'Utah'

output/regions/wisconsin.json: output/all-teams.json fetch-state.rb | output/regions
	ruby fetch-state.rb --region usa wisconsin \
    'Wisconsin' \
    'Wisconsin'

output/all-teams.json: fetch-all-teams.rb | output cache
	ruby fetch-all-teams.rb

output:
	mkdir -p $@

output/regions:
	mkdir -p $@

output/csv:
	mkdir -p $@

output/1280x800/teams:
	mkdir -p $@

output/1280x800/churn:
	mkdir -p $@

cache:
	mkdir -p $@

clean:
	rm -rf output/regions output/csv output/1280x800 output/*.md
