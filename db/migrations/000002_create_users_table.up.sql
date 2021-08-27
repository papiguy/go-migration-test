DROP TABLE IF EXISTS versioned;
CREATE TABLE versioned (
    version          int primary key default 1,
    status          varchar(255)
);

CREATE OR REPLACE FUNCTION process_emp_audit() RETURNS TRIGGER AS $$
    BEGIN
	NEW.VERSION = OLD.VERSION + 1;
	RETURN NEW.VERSION;
    END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS emp_audit ON versioned;
CREATE TRIGGER emp_audit
AFTER INSERT OR UPDATE OR DELETE ON versioned
    FOR EACH ROW EXECUTE PROCEDURE process_emp_audit();
