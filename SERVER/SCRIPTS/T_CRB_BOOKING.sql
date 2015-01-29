CREATE TABLE T_CRB_BOOKING
(
	cBookingID 			NVARCHAR(32)	NOT NULL,
	cLocation			NVARCHAR(20)	NOT NULL,
	cRoom 				NVARCHAR(20) 	NOT NULL,
	cDate 				NVARCHAR(8) 	NOT NULL,
	cFromTime 			NVARCHAR(4) 	NOT NULL,
	cUptoTime 			NVARCHAR(4) 	NOT NULL,
	cUser 				NVARCHAR(20) 	NOT NULL,
	cUserName			NVARCHAR(200)	NOT NULL,
	cStatus 			NVARCHAR(1)		NOT NULL,
	cCreateUser 		NVARCHAR(20) 	NOT NULL,
	cCreateDate 		NVARCHAR(8) 	NOT NULL,
	cCreateTime 		NVARCHAR(6) 	NOT NULL,
	cLastUpdateUser 	NVARCHAR(20) 	NOT NULL,
	cLastUpdateDate 	NVARCHAR(8) 	NOT NULL,
	cLastUpdateTime 	NVARCHAR(6) 	NOT NULL,
	PRIMARY KEY(cBookingID),
	FOREIGN KEY(cLocation, cRoom) REFERENCES T_CRB_ROOM(cLocation, cRoom),
	CONSTRAINT C_CRB_BOOKING_01 CHECK(cStatus IN('A','C', 'R'))
)
CREATE INDEX X_CRB_BOOKING_1 ON T_CRB_BOOKING(cLocation, cRoom, cDate, cStatus, cFromTime, cUptoTime);
CREATE INDEX X_CRB_BOOKING_2 ON T_CRB_BOOKING(cUser, cDate, cStatus, cFromTime, cUptoTime);