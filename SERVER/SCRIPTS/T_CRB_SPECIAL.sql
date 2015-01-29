CREATE TABLE T_CRB_SPECIAL
(
	cUser		NVARCHAR(20) NOT NULL,
	cLocation	NVARCHAR(20) 		 ,
	cRoom		NVARCHAR(20) 		 ,
	UNIQUE(cUser, cLocation, cRoom)
)
INSERT INTO T_CRB_SPECIAL VALUES('530104', NULL, NULL);
INSERT INTO T_CRB_SPECIAL VALUES('530104', 'PBP', NULL);
INSERT INTO T_CRB_SPECIAL VALUES('530104', 'THANE', 'BOARDROOM');
INSERT INTO T_CRB_SPECIAL VALUES('531953', 'THANE', 'BOARDROOM');
INSERT INTO T_CRB_SPECIAL VALUES('530001', 'THANE', NULL);
INSERT INTO T_CRB_SPECIAL VALUES('530001', 'PBP', NULL);