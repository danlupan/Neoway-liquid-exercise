###create a function to clean corp names
##logic: to avoid different abbreviations and functional names--extract actrual names of these corps
##consider the complexity of names--choose simple replace and substring function to unify names
DROP FUNCTION IF EXISTS clean_name;

DELIMITER //

CREATE FUNCTION clean_name
  (premise_name varchar(100))
  RETURNS varchar(100)
BEGIN
  IF RIGHT(premise_name,3)='THE' THEN
    SET premise_name = REPLACE(REPLACE(premise_name,',THE',''),', THE','') ;
    END IF;
###unify 'CO'
    IF SUBSTRING_INDEX(premise_name, ' ', -1)= 'CORP' OR SUBSTRING_INDEX(premise_name, ' ', -1)= 'CORPORATION' THEN
  SET premise_name=REPLACE(REPLACE(premise_name,'CORP','CO '),'CORPORATION','CO ');
  END IF;
###extract names
    SET premise_name=substring_index(premise_name,' CO ',1);
    SET premise_name=substring_index(premise_name,' LLC',1);
    SET premise_name=substring_index(premise_name,' INC',1);
  SET premise_name=substring_index(premise_name,' OPERATING',1);
  SET premise_name=substring_index(premise_name,' COMPANY',1);
  SET premise_name=substring_index(premise_name,' RESTAURANT',1);
  SET premise_name=substring_index(premise_name,' ENTERPRISES',1);
  SET premise_name=substring_index(premise_name,' SERVICE',1);
  SET premise_name=substring_index(premise_name,' LTD',1);
  SET premise_name=substring_index(premise_name,' LIQUORS',1);
  SET premise_name=substring_index(premise_name,' WINE',1);
  SET premise_name=substring_index(premise_name,' GRILL',1);
  SET premise_name=substring_index(premise_name,' INC',1);
  SET premise_name=substring_index(premise_name,' AT ',1);
  SET premise_name=substring_index(premise_name,' OF ',1);
  RETURN premise_name;
END//

##create a function to clean corp address
##unify street by using regular expression and substring
DROP FUNCTION IF EXISTS clean_address;

DELIMITER //
CREATE FUNCTION clean_address
  (Address varchar(100))
  RETURNS varchar(100) 
BEGIN
###extract street
    SET Address=PREG_CAPTURE(
           '/[\\d(\\-\\w)?]{0,4}([\\s\\w+\\b]{1,20})?((\\sStreet\\b)|(\\sSTREET\\b)|(\\sAVE\\b)|(\\sST\\b)|(\\sRD\\b)|(\\sROAD\\b)|(\\sAVE?NUE\\b)|(\\sMALL\\b)|(\\sBROADWAY\\b)|(\\sDR\\b)|(\\sBOULEVARD\\b)|(\\sBLVD\\b)|(\\sLANE\\b)|(\\sCENTER\\b)|(ROUTE\\b)|(\\sPARK\\b)|(\\sRD\\b)|(\\sROUTE\\b)|(\\sLN\\b)|(\\sPL\\b)|(\\sBRG\\b)|(\\sCT\\b)|(\\sCIR\\b)|(\\sGATE\\b)|(\\sWAY\\b)|(\\sTPKE\\b)|(\\sPKWY\\b)|(\\sVLG\\b)|(\\sSQ\\b)|(\\sSAGE EST\\b)|(\\sHL\\b))[\\s\\d]{0,10}/',
           SUBSTRING_INDEX(Address, CHAR(13), 1), 0);
###unify street
    SET Address=REPLACE(Address,'AVENUE','AVE');
    SET Address=REPLACE(Address,'STREET','ST');
    SET Address=REPLACE(Address,'ROAD','RD');
    SET Address=REPLACE(Address,'LANE','LD');
  SET Address=REPLACE(Address,'BOULEVARD','BLVD');
  SET Address=REPLACE(Address,'DRRIVE','DR');
  SET Address=REPLACE(Address,'NEW KARNER','KARNER');
      RETURN Address;
END//

##match query by inner join street and match fuzzy names using soudex function
SELECT premises_name,address,license_class,license_type,expiration_date,license_status,name,street,city,state,zip_code,unique_ID 
FROM (SELECT *, clean_name(premises_name) AS name1, soundex(clean_address(address)) AS address1,REPLACE(LEFT(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(address, CHAR(13), -1),',',-1),' ',-1),5),' ','') AS zipcodematched,
replace(SUBSTRING_INDEX(SUBSTRING_INDEX(address, CHAR(13), -1),',',1),' ','') as citymatched
FROM liquor_license) AS a INNER JOIN 
(SELECT *,
soundex(clean_address(street)) AS address2, clean_name(Name) AS name2 FROM business_record) AS b 
ON a.address1 = b.address2
WHERE soundex(name1) LIKE soundex(name2) AND zip_code=zipcodematched and soundex(city)=soundex(citymatched);