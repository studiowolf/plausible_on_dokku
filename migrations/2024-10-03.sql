
-- Migrate the data to our new page/events structure

--- 1 add viewtype meta key for embeds
ALTER TABLE events_v2
UPDATE `meta.key` = arrayConcat(meta.key, ['view_type']),
`meta.value` = arrayConcat(`meta.value`, ['embed'])
WHERE startsWith(pathname, '/embed')

--- 2 Remove /embed/ from all embed pageviews pathnames
ALTER TABLE events_v2
UPDATE pathname = replace(pathname, '/embed', '')
WHERE startsWith(pathname, '/embed/')

--- 3 Remove /embed from all embed pageviews pathnames
ALTER TABLE events_v2
UPDATE pathname = '/'
WHERE pathname = '/embed'

--- 4 migrate meta.value form embedded to embed
ALTER TABLE events_v2
UPDATE 
    `meta.value` = arrayMap(x -> if(x = 'embedded', 'embed', x), `meta.value`)
WHERE 
    arrayExists(x -> x = 'embedded', `meta.value`);

--- 5 migrate map_view to view_type
ALTER TABLE events_v2
UPDATE 
    `meta.key` = arrayMap(x -> if(x = 'map_view', 'view_type', x), `meta.key`)
WHERE 
    arrayExists(x -> x = 'map_view', `meta.key`);

--- 7 add map loads to / that are maploads
ALTER TABLE events_v2
UPDATE `meta.key` = arrayConcat(`meta.key`, ['map_load']), `meta.value` = arrayConcat(`meta.value`, ['true'])
WHERE NOT arrayExists(x -> x = 'map_load', `meta.key`) AND pathname = '/'

--- Add map_load is false if mapload is not there
ALTER TABLE events_v2
UPDATE `meta.key` = arrayConcat(`meta.key`, ['map_load']), `meta.value` = arrayConcat(`meta.value`, ['false'])
WHERE NOT arrayExists(x -> x = 'map_load', `meta.key`)

--- Add standalone map_view to all other views
ALTER TABLE events_v2
UPDATE `meta.key` = arrayConcat(`meta.key`, ['view_type']), `meta.value` = arrayConcat(`meta.value`, ['standalone'])
WHERE NOT arrayExists(x -> x = 'view_type', `meta.key`)

---- SESSIONS TABLE
--- Added referrer_source embed to all old embeds
ALTER TABLE sessions_v2
UPDATE referrer_source = 'embed'
WHERE startsWith(entry_page, '/embed')

--- 3 Remove /embed/ from all entry pages
ALTER TABLE sessions_v2
UPDATE entry_page = replace(entry_page, '/embed', '')
WHERE startsWith(entry_page, '/embed/')

--- 4 Remove /embed/ from all entry pages
ALTER TABLE sessions_v2
UPDATE entry_page = '/'
WHERE entry_page = '/embed'

--- 6 Remove /embed/ from all entry pages
ALTER TABLE sessions_v2
UPDATE exit_page = replace(exit_page, '/embed', '')
WHERE startsWith(exit_page, '/embed/')

--- 6 Remove /embed/ from all entry pages
ALTER TABLE sessions_v2
UPDATE exit_page = '/'
WHERE exit_page = '/embed'

---- 7 migrate qr to source
ALTER TABLE sessions_v2
UPDATE referrer_source = 'qr', utm_medium = ''
WHERE utm_medium = 'qr'