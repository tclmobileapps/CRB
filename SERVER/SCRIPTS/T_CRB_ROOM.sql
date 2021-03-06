CREATE TABLE T_CRB_ROOM
(
	cLocation		NVARCHAR(20)		NOT NULL,
	cRoom 			NVARCHAR(20)		NOT NULL,
	cName 			NVARCHAR(100)		NOT NULL,
	nSeats 			DECIMAL(4,0)		NOT NULL,
	nMaxSeats 		DECIMAL(4,0)		NOT NULL,
	cHasProjector 	NVARCHAR(1) 		NOT NULL,
	cHasVC 			NVARCHAR(1) 		NOT NULL,
	cIsSpecial 		NVARCHAR(1) 		NOT NULL,
	PRIMARY KEY(cLocation, cRoom),
	FOREIGN KEY(cLocation) REFERENCES T_CRB_LOCATION(cLocation),
	CONSTRAINT C_CRB_ROOM_01 CHECK(cHasProjector IN('Y','N')),
	CONSTRAINT C_CRB_ROOM_02 CHECK(cHasVC IN('Y','N')),
	CONSTRAINT C_CRB_ROOM_03 CHECK(cIsSpecial IN('Y','N'))
)
INSERT INTO T_CRB_ROOM VALUES('THANE', '4C8', '4-C-8', 20, 30, 'Y', 'N', 'N')
INSERT INTO T_CRB_ROOM VALUES('THANE', '4C7', '4-C-7', 6, 8, 'Y', 'N', 'N')
INSERT INTO T_CRB_ROOM VALUES('THANE', '4C6', '4-C-6', 6, 8, 'Y', 'Y', 'N')
INSERT INTO T_CRB_ROOM VALUES('THANE', 'BOARDROOM', 'Boardroom 4th Floor', 25, 30, 'Y', 'Y', 'Y')
INSERT INTO T_CRB_ROOM VALUES('PBP', '11A1', '11-A-1', 12, 20, 'Y', 'Y', 'N')
INSERT INTO T_CRB_ROOM VALUES('PBP', '11A2', '11-A-2', 10, 16, 'Y', 'Y', 'N')
INSERT INTO T_CRB_ROOM VALUES('PBP', '12A1', '12-A-1', 12, 20, 'Y', 'Y', 'N')
INSERT INTO T_CRB_ROOM VALUES('PBP', '12A2', '12-A-2', 10, 16, 'Y', 'Y', 'N')
INSERT INTO T_CRB_ROOM VALUES('PBP', 'BOARDROOM', 'Boardroom 12th Floor', 25, 30, 'Y', 'Y', 'Y')