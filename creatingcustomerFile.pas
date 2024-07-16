program creatingcustomerFile;

USES
  CRT, SYSUTILS;
type
  CustomerRecord = RECORD
   CustomerID : STRING[3];
   Title : STRING[3];
   Surname : STRING[15];
   Forename : STRING[15];
   medicalCondition : STRING[10];
   Age : STRING[3];
   Contact : STRING[11];
  end;
  CustomerFiletype = FILE OF CustomerRecord;

var
  Customer : CustomerRecord;
  CustomerFile : CustomerFiletype;

PROCEDURE CreateFile;
 BEGIN
   ASSIGN(CustomerFile,'C:\Computer Science\Mr Martin\Pascal\Coursework\Customer.dta');
   REWRITE(CustomerFile);

   With Customer DO
    BEGIN
      CustomerID := 'AA1';
      Title := 'Mr';
      Surname := 'Joshua';
      Forename := 'Mattheus';
      medicalCondition := 'None';
      Age := '21';
      Contact := '07599144167';
      WRITE(CustomerFile, Customer);

      CustomerID := 'AA2';
      Title := 'Mrs';
      Surname := 'Smith';
      Forename := 'Amelia';
      medicalCondition := 'None';
      Age := '19';
      Contact := '07942349867';
      WRITE(CustomerFile, Customer);

      CustomerID := 'AA3';
      Title := 'Mr';
      Surname := 'Lobongo';
      Forename := 'Ephraim';
      medicalCondition := 'Tourettes';
      Age := '18';
      Contact := '07567322196';
      WRITE(CustomerFile, Customer);

      CustomerID := 'AA4';
      Title := 'Mrs';
      Surname := 'Roberts';
      Forename := 'Jessica';
      medicalCondition := 'ADHD';
      Age := '20';
      Contact := '07930555182';
      WRITE(CustomerFile, Customer);

      CustomerID := 'AA5';
      Title := 'Mr';
      Surname := 'Khalid';
      Forename := 'Muhammad';
      medicalCondition := 'None';
      Age := '26';
      Contact := '07513920664';
      WRITE(CustomerFile, Customer);

      CLOSE(CustomerFile);
    end;
 end;
BEGIN
  CreateFile;

end.

