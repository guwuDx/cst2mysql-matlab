DELIMITER //

CREATE PROCEDURE genericunitsprmt_hashAdd(IN input_id INT)
BEGIN
    UPDATE genericunitsprmt
    SET hash = MD5(CONCAT(height, period, thickness))
    WHERE ID > input_id
    AND hash IS NULL;
END //

DELIMITER ;
