create table users
(
userId int identity(1,1) primary key,
username varchar(100) not null unique,
email varchar(100) not null unique,
pwd  varchar(10) not null, 
password_encrypted varbinary(max),
phone int not null
)
drop table users
insert into users values
(
'abc123',
'abc123@gmail.com',
'123456',
null,
1213132
)
select * from users

--We use CREATE MASTER KEY statement for creating a database master key:
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SQLShack@1';

--Create a self-signed certificate for Column level SQL Server encryption
CREATE CERTIFICATE Certificate_test WITH SUBJECT = 'Protect my data';

--Configure a symmetric key for column level SQL Server encryption
CREATE SYMMETRIC KEY SymKey_test WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Certificate_test;


--open the symmetric key and decrypt using the certificate. 
--We need to use the same symmetric key and certificate name that we created earlier
OPEN SYMMETRIC KEY SymKey_test DECRYPTION BY CERTIFICATE Certificate_test;

--Data encryption
UPDATE users SET password_encrypted = ENCRYPTBYKEY(KEY_GUID('SymKey_test'), pwd) from users;

--Close the symmetric key using the CLOSE SYMMETRIC KEY statement. If we do not close the key, it remains open until the session is terminated
CLOSE SYMMETRIC KEY SymKey_test;


--DECRYPTION PROCESS
OPEN SYMMETRIC KEY SymKey_test DECRYPTION BY CERTIFICATE Certificate_test;
select username, CONVERT(varchar, DecryptByKey(password_encrypted)) as 'decrypted' from users
CLOSE SYMMETRIC KEY SymKey_test;