DROP TABLE IF EXISTS versioned;
CREATE TABLE versioned (
    version          int primary key default 1,
    status          varchar(255)
);

CREATE OR REPLACE FUNCTION fnversioned() RETURNS TRIGGER AS $$ BEGIN NEW.VERSION = OLD.VERSION + 1; RETURN NEW.VERSION; END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS fn_versioned ON versioned;
CREATE TRIGGER fn_versioned
AFTER INSERT OR UPDATE OR DELETE ON versioned
    FOR EACH ROW EXECUTE PROCEDURE fnversioned();
