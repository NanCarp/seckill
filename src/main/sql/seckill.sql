DELIMITER $$

CREATE PROCEDURE `seckill`.`execute_seckill`
  (IN v_seckill_id bigint, IN  v_phone bigint, IN v_kill_time TIMESTAMP,
    OUT r_result int)
  BEGIN
    DECLARE insert_count int DEFAULT 0;
    START TRANSACTION ;
    INSERT IGNORE INTO success_killed
      (seckill_id,user_phone,create_time)
      VALUES (v_seckill_id,v_phone,v_kill_time);
    SELECT row_count() into insert_count;
    IF (insert_count < 0) THEN
      ROLLBACK ;
      SET r_result = -1;
    ELSEIF (insert_count < 0) THEN
      ROLLBACK;
      SET r_result = -2;
    ELSE
      UPDATE seckill
      SET number = number -1
      WHERE seckill_id = v_seckill_id
        AND end_time > v_kill_time
        AND start_time < v_kill_time
        AND number > 0;
      IF (insert_count == 0) THEN
        ROLLBACK;
        SET r_result = 0;
      ELSEIF (insert_count < 0) THEN
        ROLLBACK;
        SET r_result = -2;
      ELSE
        COMMIT;
        SET r_result = 1;
      END IF;
    END IF;
  END;
$$

DELIMITER ;
SET @r_result=-3;
call execute_seckill(1003, 1350111112222, now(), @r_result);
SELECT @r_result;