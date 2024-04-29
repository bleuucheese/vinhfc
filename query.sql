-- Authentication function
FUNCTION user_aut    (
    
 p_username IN VARCHAR2, --User_Name
 p_password IN VARCHAR2 -- Password    
)
 RETURN BOOLEAN
AS
 lc_pwd_exit VARCHAR2 (1);
BEGIN
 -- Validate whether the user exits or not
 SELECT 'Y'
 INTO lc_pwd_exit
 FROM users
 WHERE upper(LOG_IN) = UPPER (p_username) AND LOG_PAS = p_password and status='Y' 
;
RETURN TRUE;
EXCEPTION
 WHEN NO_DATA_FOUND
 THEN
 RETURN FALSE;
END user_aut;

-- Authorization 
SELECT user_role FROM MY_USERS 
WHERE UPPER(LOG_IN)=V('APP USER') AND USER_ROLE IN ('ADMIN');

SELECT user_role FROM MY_USERS 
WHERE UPPER(LOG_IN)=V('APP USER') AND USER_ROLE IN ('LIBRARIAN');

SELECT user_role FROM MY_USERS 
WHERE UPPER(LOG_IN)=V('APP USER') AND USER_ROLE IN ('STUDENT', 'STAFF');
