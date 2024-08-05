USE docker;

-- 전체 수를 구하는 사용자 함수 (대상 테이블은 t_menu)
delimiter $$
CREATE FUNCTION f_event1() RETURNS INT 
BEGIN 
DECLARE f_out int;
SELECT COUNT(가격) INTO f_out FROM t_menu;
RETURN f_out;
END;
$$
delimiter ;

-- 두개의 수를 받아서 합한 수를 받는 사용자 함수
CREATE FUNCTION f_event2(IN a INT, IN b INT) RETURNS INT
RETURN (a + b);


CREATE TABLE u (
	nm VARCHAR(10),
	gender BOOLEAN 

);

INSERT INTO u VALUES ('홍길동', 1);
INSERT INTO u VALUES ('홍길동', 0);
COMMIT;

SELECT * FROM u;

delimiter $$
CREATE FUNCTION f_event3(IN f_gender BOOLEAN) RETURNS VARCHAR(20)
BEGIN
	if(f_gender = 0) then
		RETURN '여성';
	ELSE 
		RETURN '남성';
	END if;
END;
$$
delimiter ;

SELECT nm, gender, f_event3(gender) FROM u;

SELECT NOW(), DATE_FORMAT(NOW(), '%Y년%m월%d일') AS 한국식날짜;

SELECT f_event4(NOW()) AS 현재날짜, 
         f_event4(STR_TO_DATE('2023-07-29', '%Y-%m-%d')) AS 작년날짜,
         f_event4(STR_TO_DATE('2024-06-09', '%Y-%m-%d')) AS 지난달날짜;

CREATE FUNCTION f_event4(IN f_date datetime) RETURNS VARCHAR(30)
RETURN DATE_FORMAT(f_date, '%Y년%m월%d일');

delimiter $$
CREATE FUNCTION f_event5(IN f_a BOOLEAN) RETURNS VARCHAR(20)
BEGIN
	if(f_a = 0) then
		RETURN '불가능';
	ELSE 
		RETURN '가능';
	END if;
END;
$$
delimiter ;


--프로시저
CREATE OR REPLACE PROCEDURE p_event1()
SELECT *, f_event5(양조절유무) AS 한글양조절유무 FROM t_menu;

CALL p_event1();

CREATE PROCEDURE p_event2(IN a INT, IN b INT, OUT c INT)
set c = a + b;

CALL p_event2(1, 2, @r);
SELECT @r;

-- 프로시저를 이용하여 u 테이블에 데이터를 입력하기
delimiter $$
CREATE PROCEDURE p_u_insert(IN p_nm VARCHAR(10), IN p_gender BOOLEAN, OUT state INT)

BEGIN 
	INSERT INTO u VALUES (p_nm, p_gender);
	SET state = 1;
END;
$$
delimiter ;

CALL p_u_insert('이순신',FALSE, @state);

SELECT @state;

delimiter $$
CREATE PROCEDURE p_u_i_s(IN p_nm VARCHAR(10), IN p_gender BOOLEAN)

BEGIN 
	INSERT INTO u VALUES (p_nm, p_gender);
	SELECT * FROM u;
END;
$$
delimiter ;

CALL p_u_i_s('둘리',TRUE);

-- u2 테이블에 데이터를 입력 후 해당 데이터의 식별자인 기본키 값을 받아오기
CREATE TABLE u2(
	no INT NOT NULL NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nm VARCHAR(50) NOT NULL,
	gender boolean

);

SELECT * FROM u2;

delimiter $$
CREATE PROCEDURE p_u2(IN p_nm VARCHAR(50), IN p_gender BOOLEAN, OUT p_no INT)
BEGIN 
	INSERT INTO u2 (nm, gender) VALUES (p_nm, p_gender);
	SELECT LAST_INSERT_ID() INTO p_no;
	COMMIT;
END;
$$
delimiter ;

CALL p_u2('참치', TRUE, @NO);
SELECT @NO;

CREATE PROCEDURE p_u2_list()
SELECT * FROM u2;

CALL p_u2_list();

CREATE PROCEDURE p_u2_insert(IN p_nm VARCHAR(50), IN p_gender BOOLEAN)
INSERT INTO u2 (nm, gender) VALUES (p_nm, p_gender);

CALL p_u2_insert('미역', FALSE);

SELECT * FROM u2;

CREATE PROCEDURE p_u2_delete2(IN p_nm VARCHAR(50), IN p_gender BOOLEAN)
DELETE FROM u2 WHERE nm = p_nm AND gender = p_gender;

CALL p_u2_delete2('미역', FALSE);



delimiter $$
CREATE PROCEDURE p_u2_delete(IN p_no INT)
BEGIN 
DELETE FROM u2 WHERE NO = p_no;
COMMIT;
END;
$$
delimiter ;
CALL p_u2_delete(1);

CREATE PROCEDURE p_u2_selectOne(IN p_no INT)
SELECT * FROM u2 WHERE NO = p_no;

CALL p_u2_selectOne(3);

CALL p_u2_insert('짜짜', FALSE);

CALL p_u2_update(2,'고등어',TRUE);

COMMIT;


CREATE PROCEDURE p_u2_update(IN p_no INT, IN p_nm VARCHAR(50), IN p_gender BOOLEAN)
UPDATE u2 SET nm = p_nm, gender = p_gender WHERE no = p_no;


delimiter $$
CREATE PROCEDURE p_u2_cntGenderList()
BEGIN
	SELECT 
	case when gender = TRUE then '남자' ELSE '여자' END AS gender,
	COUNT(*) AS cnt FROM u2 GROUP BY gender;
END;
$$
delimiter ;

CALL p_u2_cntGenderList();

CALL p_u2_cntGenderList2();

