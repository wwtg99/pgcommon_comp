-- Common components
-- tags
-- comments
-- accessories


----------
--tables--
----------

--tags
CREATE TABLE tags (
	tag_id SERIAL PRIMARY KEY,
	tag_name TEXT UNIQUE NOT NULL,
	descr TEXT,
	created_by TEXT,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE TABLE object_tags (
	id SERIAL PRIMARY KEY,
	object_table TEXT NOT NULL,
	object_id TEXT NOT NULL,
	tag_id BIGINT REFERENCES tags (tag_id) ON DELETE CASCADE NOT NULL,
	created_by TEXT,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
	UNIQUE (object_table, object_id, tag_id)
);

CREATE INDEX ON object_tags (object_table, object_id);

--comments
CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	object_table TEXT NOT NULL,
	object_id TEXT NOT NULL,
	comment TEXT NOT NULL,
	created_by TEXT,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX ON comments (object_table, object_id);

--accessories
CREATE TABLE accessories (
	accessory_id SERIAL PRIMARY KEY,
	label TEXT,
	mime TEXT,
	content BYTEA,
	file_path TEXT,
	params JSONB,
	md5 TEXT,
	sha1 TEXT,
	created_by TEXT,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE TABLE object_accessories (
	id SERIAL PRIMARY KEY,
	object_table TEXT NOT NULL,
	object_id TEXT NOT NULL,
	accessory_id BIGINT REFERENCES public.accessories (accessory_id) ON DELETE CASCADE NOT NULL,
	label TEXT NOT NULL,
	descr TEXT,
	params JSONB,
	created_by TEXT,
	created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
	UNIQUE (object_table, object_id, accessory_id)
);

CREATE INDEX ON object_accessories (object_table, object_id);


---------
--views--
---------

CREATE OR REPLACE VIEW view_accessories AS 
SELECT o.id, object_table, object_id, a.accessory_id, 
o.label, mime, descr, a.params AS accessory_params, o.params AS params, md5, sha1, 
o.created_by, o.created_at 
FROM accessories AS a JOIN object_accessories AS o  
ON a.accessory_id = o.accessory_id;

CREATE OR REPLACE VIEW view_tags AS 
SELECT o.id, object_table, object_id, t.tag_id, tag_name, descr,  
o.created_by, o.created_at 
FROM tags AS t JOIN object_tags AS o ON t.tag_id = o.tag_id;

