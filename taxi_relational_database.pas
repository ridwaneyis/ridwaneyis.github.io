program newbooking1;

USES
  CRT, SYSUTILS;
type
  ScheduleRecord = RECORD
   CustomerID : STRING[3];
   DriverID : STRING[3];
   Cost : REAL;
   PickupID : STRING[3];
   DestinationID : STRING[3];
   Date : TDATETIME;
   Time : TDATETIME;
   expectedArrival: TDATETIME;
  end;
ScheduleFiletype = FILE OF ScheduleRecord;

  LocationRecord = RECORD
    LocationID : STRING[3];
    Address : STRING[8];
    EstateName : STRING[35];
    StreetName : STRING[35];
    HouseNumber : STRING[3];
  end;
 LocationFiletype = FILE OF LocationRecord;

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

 ContractRecord = RECORD
   ContractID : STRING[3];
   Cost : STRING[5];
  end;
 ContractFiletype = FILE OF ContractRecord;

  DriverRecord = RECORD
    DriverID : STRING[3];
    Title : STRING[3];
    Surname : STRING[15];
    Forename : STRING[15];
    medicalCondition : STRING[10];
    Age : STRING[3];
    Contact : STRING[11];
   end;
  DriverFiletype = FILE OF DriverRecord;

VAR
  Schedule, newSchedule : ScheduleRecord;
  ScheduleFile : ScheduleFiletype;

  Location : LocationRecord;
  LocationFile : LocationFiletype;

  Customer : CustomerRecord;
  CustomerFile : CustomerFiletype;

  Driver : DriverRecord;
  DriverFile : DriverFiletype;

  Contract : ContractRecord;
  ContractFile : ContractFiletype;


  Selected : CHAR;

PROCEDURE Selection;
  BEGIN
    WRITE('Enter the Desired Drive: ');
    Selected:=UPCASE(READKEY);
  end;

PROCEDURE CreateCustomer;
  BEGIN
    ASSIGN(CustomerFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Customer.dta');
    REWRITE(CustomerFile);

    WITH Customer DO
    BEGIN
      CustomerID := 'A01';
      Title := 'Mr';
      Surname := 'Ali';
      Forename := 'Ridwan';
      medicalCondition := 'None';
      Age := '17';
      Contact := '07938444928';
      WRITE(CustomerFile, Customer);

      CustomerID := 'A02';
      Title := 'Mr';
      Surname := 'Baker';
      Forename := 'John';
      medicalCondition := 'None';
      Age := '22';
      Contact := '0759824928';
      WRITE(CustomerFile, Customer);

      CustomerID := 'A03';
      Title := 'Mrs';
      Surname := 'Muhammad';
      Forename := 'Ragith';
      medicalCondition := 'Tourettes';
      Age := '33';
      Contact := '07985927638';
      WRITE(CustomerFile, Customer);

      CustomerID := 'A04';
      Title := 'Mr';
      Surname := 'Campbell';
      Forename := 'Joseph';
      medicalCondition := 'Diabetes';
      Age := '19';
      Contact := '07933748298';
      WRITE(CustomerFile, Customer);

      CustomerID := 'A05';
      Title := 'Mrs';
      Surname := 'Smith';
      Forename := 'Jeniffer';
      medicalCondition := 'None';
      Age := '21';
      Contact := '07930412578';
      WRITE(CustomerFile, Customer);
    END;
  END;

PROCEDURE CreateDriver;
  BEGIN
    ASSIGN(DriverFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Driver.dta');
    REWRITE(DriverFile);

    WITH Driver DO
    BEGIN
      DriverID := 'A01';
      Title := 'Mr';
      Surname := 'Ali';
      Forename := 'Munn';
      medicalCondition := 'None';
      Age := '32';
      Contact := '07933244428';
      WRITE(DriverFile, Driver);

      DriverID := 'A02';
      Title := 'Mr';
      Surname := 'Bakr';
      Forename := 'Gohf';
      medicalCondition := 'None';
      Age := '22';
      Contact := '0759822958';
      WRITE(DriverFile, Driver);

      DriverID := 'A03';
      Title := 'Mrs';
      Surname := 'Muhammad';
      Forename := 'Abdi';
      medicalCondition := 'Tourettes';
      Age := '33';
      Contact := '07937849138';
      WRITE(DriverFile, Driver);

      DriverID := 'A04';
      Title := 'Mrs';
      Surname := 'Campbell';
      Forename := 'Jeniffer';
      medicalCondition := 'Diabetes';
      Age := '19';
      Contact := '07599918298';
      WRITE(DriverFile, Driver);

      DriverID := 'A05';
      Title := 'Mrs';
      Surname := 'Smooth';
      Forename := 'Jenny';
      medicalCondition := 'None';
      Age := '21';
      Contact := '07998111578';
      WRITE(DriverFile, Driver);
    END;
  END;

PROCEDURE CreateSchedule;
  BEGIN
    ASSIGN(ScheduleFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Schedule.dta');
    REWRITE(ScheduleFile);

    WITH Schedule DO
      BEGIN
        CustomerID := 'A01';
        DriverID := 'A01';
        Cost := 7.99;
        PickupID := 'A01';
        DestinationID := 'A02';
        Date := STRTODATE('17/02/2023');
        Time := STRTOTIME('15:30');
        ExpectedArrival := STRTOTIME('15:40');
        WRITE(ScheduleFile, Schedule);

        CustomerID := 'A01';
        DriverID := 'A03';
        Cost := 13.99;
        PickupID := 'A02';
        DestinationID := 'A01';
        Date := STRTODATE('26/03/2023');
        Time := STRTOTIME('17:30');
        ExpectedArrival := STRTOTIME('18:00');
        WRITE(ScheduleFile, Schedule);

        CustomerID := 'A02';
        DriverID := 'A02';
        Cost := 8.99;
        PickupID := 'A03';
        DestinationID := 'A01';
        Date := STRTODATE('26/03/2023');
        Time := STRTOTIME('20:45');
        ExpectedArrival := STRTOTIME('21:00');
        WRITE(ScheduleFile, Schedule);

        CustomerID := 'A03';
        DriverID := 'A02';
        Cost := 13.99;
        PickupID := 'A04';
        DestinationID := 'A02';
        Date := STRTODATE('27/03/2023');
        Time := STRTOTIME('10:30');
        ExpectedArrival := STRTOTIME('11:00');
        WRITE(ScheduleFile, Schedule);
    END;
  END;

PROCEDURE CreateContract;
  BEGIN
    ASSIGN(ContractFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Contract.dta');
    REWRITE(ContractFile);

    With Contract DO
      BEGIN
        ContractID := 'A01';
        Cost := '7.99';
        WRITE(ContractFile, Contract);

        ContractID := 'A02';
        Cost := '19.99';
        WRITE(ContractFile, Contract);

        ContractID := 'A03';
        Cost := '11.99';
        WRITE(ContractFile, Contract);

        ContractID := 'A04';
        Cost := '19.99';
        WRITE(ContractFile, Contract);
      END;
  END;

PROCEDURE CreateLocation;
  BEGIN
    ASSIGN(LocationFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Location.dta');
    REWRITE(LocationFile);

    With Location DO
      BEGIN
        LocationID := 'A01';
        Address := 'MK14 7AX';
        EstateName := 'Conniburrow';
        StreetName := 'Yarrow Place';
        HouseNumber := 'n/a';
        WRITE(LocationFile, Location);

        LocationID := 'A02';
        Address := 'MK14 7PJ';
        EstateName := 'Downs Barn';
        StreetName := 'Farrier Place';
        HouseNumber := 'n/a';
        WRITE(LocationFile, Location);

        LocationID := 'A03';
        Address := 'MK7 7WH';
        EstateName := 'Walton High';
        StreetName := 'Fyfield Barrow';
        HouseNumber := 'n/a';
        WRITE(LocationFile, Location);

        LocationID := 'A04';
        Address := 'MK5 7ZT';
        EstateName := 'Shenley Brook End';
        StreetName := 'Walbank Grove';
        HouseNumber := 'n/a';
        WRITE(LocationFile, Location);

        LocationID := 'A05';
        Address := 'MK4 4TA';
        EstateName := 'Oxley Park';
        StreetName := 'Redgrave Drive';
        HouseNumber := 'n/a';
        WRITE(LocationFile, Location);
      END;
  END;

BEGIN
  Selection;
  CreateCustomer;
  CreateDriver;
  CreateSchedule;
  CreateContract;
  CreateLocation;
END.
