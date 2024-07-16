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

  LocationRecord =  RECORD
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

  Title1 : STRING[3];
  Surname1 : STRING[15];
  Forename1 : STRING[15];
  medicalCondition1 : STRING[10];
  Age1 : STRING[3];
  Contact1 : STRING[11];
  pickup, pickup1,destination, StreetPickup : STRING;

  Schedule, newSchedule : ScheduleRecord;
  ScheduleFile : ScheduleFiletype;

  Location : LocationRecord;
  LocationFile : LocationFiletype;

  Customer : CustomerRecord;
  CustomerFile : CustomerFiletype;

  Driver : DriverRecord;
  DriverFile : DriverFiletype;

  CustomerIDbooking, DriverIDbooking, newDriverID : STRING;
  Date10, Time10, expected10 : STRING;
  newDate, newTime, newExpectedArrival : TDATETIME;
  newDateSTR, newTimeSTR : STRING;
  newEstimatedarrival : TDATETIME;


  LastID, NextID, LastContractID, NextContractID : STRING;
  NextIDCHAR, LastIDCHAR, NextContractIDCHAR, LastContractIDCHAR : CHAR;
  NextIDNum, LastIDNum, NextContractIDNum, LastContractIDNum : INTEGER;
  Costfound : REAL;

  Answer, Answer1, Answer2, fname, Answer3, Contact, Answer4, Answer5,Answer6, verifyCustomerIDbooking, verifyCustomerIDbooking2 : STRING;
  found, found1  : BOOLEAN;
  Date, Time : TDATETIME;
  Selected : CHAR;
  Choice : CHAR;


// procedure to avoid crashing and return the user to the main menu
 
PROCEDURE PressKey;
  BEGIN
    WRITELN;
    WRITELN('Press any key to continue!');
    READKEY;
  END;

// initialising the files that are going to be used in the system
  
PROCEDURE InitialiseFiles;
  BEGIN
    WRITE('Enter the Desired Drive: ');
    READLN(Selected);
    WRITELN;
    ASSIGN(CustomerFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Customer.dta');
    ASSIGN(ScheduleFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Schedule.dta');
    ASSIGN(DriverFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Driver.dta');
    ASSIGN(LocationFile, Selected +':\Computer Science\Mr Martin\Pascal\Coursework\Location.dta');
    RANDOMIZE;
  end;

// procedure to add a customer to the system’s database
PROCEDURE AddCustomer;
  BEGIN
    CLRSCR;
    WRITELN;
    RESET(CustomerFile);
    SEEK(CustomerFile, FILESIZE(CustomerFile)-1);
    READ(CustomerFile, Customer);
    LastID := Customer.CustomerID;
    LastIDChar := LastID[1];
    LastIDNum := STRTOINT(COPY(LastID,2,2));
    IF LastIDNum <= 99 THEN
      BEGIN
        NextIDNum := LastIDNum+1;
        NextIDChar := LastIDChar;
        IF NextIDNum >= 10 THEN
          BEGIN
            NextID := NextIDChar+INTTOSTR(NextIDNum);
            CustomerIDbooking := NextID;
          END
        ELSE
          BEGIN
            NextID := NextIDChar+'0'+INTTOSTR(NextIDNum);
            CustomerIDbooking := NextID;
          END;
       END

     ELSE
       BEGIN
         NextIDChar := CHR(ORD(LastIDChar)+1);
         NextID := NextIDChar+'00';
         CustomerIDbooking := NextID;
       END;
      WRITE('What is their Title? ');
      READLN(Title1);
      WRITE('Enter surname: ');
      READLN(Surname1);
      WRITE('Enter forename: ');
      READLN(Forename1);
      WRITE('Do they have any medical conditions(enter n if none): ');
      READLN(medicalCondition1);
      WRITE('What is their age: ');
      READLN(Age1);
      WRITE('Please enter their contact number: ');
      READLN(Contact1);
      IF LENGTH(Contact1) < 11 THEN
        BEGIN
          WRITE('Please enter a valid contact number: ');
          READLN(Contact1);
          IF LENGTH(Contact1) < 11 THEN
            BEGIN
              WRITELN('You have to enter a contact number for us to send you your booking confirmation and driver details.');
              WRITELN;
              WRITELN('Please restart your booking.');
              halt;
            END;
        END;
        SEEK(CustomerFile, FILESIZE(CustomerFile));
        With Customer DO
          BEGIN
            CustomerID := NextId;
            Title := Title1;
            Surname := Surname1;
            Forename := Forename1;
            medicalCondition := medicalCondition1;
            Age := Age1;
            Contact := Contact1;
            WRITE(CustomerFile, Customer);
          END;
        WRITELN('Customer added Successfully');
        PressKey;
  END;

// procedure to view all the customers in the database

PROCEDURE ViewCustomer;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITELN('Customers -');
    WRITELN;
    RESET(CustomerFile);
    WHILE NOT EOF(CustomerFile) DO
      BEGIN
        READ(CustomerFile, Customer);
        WITH Customer DO
          BEGIN
            WRITELN('Customer ID: ', CustomerID);
            WRITELN('Name: ', Forename,' ',Surname);
          END;
        WRITELN;
      END;
      PressKey;
  END;

// procedure to remove a customer from the system database

PROCEDURE RemoveCustomer;
  VAR 
    IDwanted : STRING;
    DesiredPos1 : INTEGER;
  BEGIN
    WRITELN;
    WRITE('Enter the Customer ID wanted to be removed from the Customer File: ');
    READLN(IDwanted);
    RESET(CustomerFile);
    WRITELN;
    REPEAT
      READ(CustomerFile, Customer);
    UNTIL (Customer.CustomerID = IDwanted) OR EOF(CustomerFile);
    IF EOF(CustomerFile) THEN
      BEGIN
        WRITELN('Customer specified does not exist');
        WRITELN;
        PressKey;        
      END
    ELSE
      BEGIN
        WHILE FILEPOS(CustomerFile) <> FILESIZE(CustomerFile) DO
          BEGIN
            READ(CustomerFile, Customer);
            SEEK(CustomerFile, FILEPOS(CustomerFile)-2);
            WRITE(CustomerFile, Customer);
            SEEK(CustomerFile, FILEPOS(CustomerFile)+1);
          END;
        SEEK(CustomerFile, FILESIZE(CustomerFile)-1);
        TRUNCATE(CustomerFile);
        WRITELN('Customer ', IDwanted,' has been successfully removed! ');
        PressKey;         
      END;
  END;

// sub menu for the customers 

PROCEDURE CustomerMenu;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITELN(' -- CUSTOMER SECTION -- ');
    WRITELN;
    WRITELN('Options Available ');
    WRITELN;
    WRITELN('1 - Add a Customer');
    WRITELN('2 - View Customers');
    WRITELN('3 - Remove a Customer');
    WRITELN;
    WRITE('Please select an option: ');
    Choice := READKEY;
    READLN(Choice);
    CASE Choice OF
      '1' : AddCustomer;
      '2' : ViewCustomer;
      '3' : RemoveCustomer;
    END
  END;

// procedure to add a driver to the system’s database

PROCEDURE AddDriver;
  BEGIN
    CLRSCR;
    WRITELN;
    RESET(DriverFile);
    SEEK(DriverFile, FILESIZE(DriverFile)-1);
    READ(DriverFile, Driver);
    LastID := Driver.DriverID;
    LastIDChar := LastID[1];
    LastIDNum := STRTOINT(COPY(LastID,2,2));
    IF LastIDNum <= 99 THEN
      BEGIN
        NextIDNum := LastIDNum+1;
        NextIDChar := LastIDChar;
        IF NextIDNum >= 10 THEN
          BEGIN
            NextID := NextIDChar+INTTOSTR(NextIDNum);
            DriverIDbooking := NextID;
          END
        ELSE
          BEGIN
            NextID := NextIDChar+'0'+INTTOSTR(NextIDNum);
            DriverIDbooking := NextID;
          END;
       END

     ELSE
       BEGIN
         NextIDChar := CHR(ORD(LastIDChar)+1);
         NextID := NextIDChar+'00';
         DriverIDbooking := NextID;
       END;
      WRITE('What is their Title? ');
      READLN(Title1);
      WRITE('Enter surname: ');
      READLN(Surname1);
      WRITE('Enter forename: ');
      READLN(Forename1);
      WRITE('Do they have any medical conditions(enter n if none): ');
      READLN(medicalCondition1);
      WRITE('What is their age: ');
      READLN(Age1);
      WRITE('Please enter their contact number: ');
      READLN(Contact1);
      IF LENGTH(Contact1) < 11 THEN
        BEGIN
          WRITE('Please enter a valid contact number: ');
          READLN(Contact1);
          IF LENGTH(Contact1) < 11 THEN
            BEGIN
              WRITELN('You have to enter a contact number for us to send you your booking confirmation and driver details.');
              WRITELN;
              WRITELN('Please restart your booking.');
              halt;
            END;
        END;
        SEEK(DriverFile, FILESIZE(DriverFile));
        With Driver DO
          BEGIN
            DriverID := NextId;
            Title := Title1;
            Surname := Surname1;
            Forename := Forename1;
            medicalCondition := medicalCondition1;
            Age := Age1;
            Contact := Contact1;
            WRITE(DriverFile, Driver);
          END;
        WRITELN('Driver added Successfully');
        PressKey;
  END;

// procedure to view all the drivers in the system’s database

PROCEDURE ViewDriver;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITELN('Drivers -');
    WRITELN;
    RESET(DriverFile);
    WHILE NOT EOF(DriverFile) DO
      BEGIN
        READ(DriverFile, Driver);
        WITH Driver DO
          BEGIN
            WRITELN('Driver ID: ', DriverID);
            WRITELN('Name: ', Forename,' ',Surname);
          END;
        WRITELN;
      END;
      PressKey;
  END;

// procedure to remove a driver from the system database 

PROCEDURE RemoveDriver;
  VAR 
    IDwanted : STRING;
    DesiredPos1 : INTEGER;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITE('Enter the driver ID wanted to be removed from the driver File: ');
    READLN(IDwanted);
    RESET(DriverFile);
    WRITELN;
    REPEAT
      READ(DriverFile, Driver);
    UNTIL (Driver.DriverID = IDwanted) OR EOF(DriverFile);
    IF EOF(DriverFile) THEN
      BEGIN
        WRITELN('Driver specified does not exist');
        WRITELN;
        PressKey;        
      END
    ELSE
      BEGIN
        WHILE FILEPOS(DriverFile) <> FILESIZE(DriverFile) DO
          BEGIN
            READ(DriverFile, Driver);
            SEEK(DriverFile, FILEPOS(DriverFile)-2);
            WRITE(DriverFile, Driver);
            SEEK(DriverFile, FILEPOS(DriverFile)+1);
          END;
        SEEK(DriverFile, FILESIZE(DriverFile)-1);
        TRUNCATE(DriverFile);
        WRITELN('Driver ', IDwanted,' has been successfully removed! ');
        PressKey;         
      END;
  END;

PROCEDURE DriverAbsence;
  BEGIN
    // CREATE A PROCEDURE TO BOOK A PART OFA DRIVERS BOOKING AND LABEL PICKUP/DESTINATION ID AS HO(HOLIDAY) OR IL(SICK)
  END;

// sub menu for the drivers
  
PROCEDURE DriverMenu;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITELN(' -- Driver SECTION -- ');
    WRITELN;
    WRITELN('Options Available ');
    WRITELN;
    WRITELN('1 - Add a Driver');
    WRITELN('2 - View Drivers');
    WRITELN('3 - Remove a Driver');
    WRITELN;
    WRITE('Please select an option: ');
    Choice := READKEY;
    READLN(Choice);
    CASE Choice OF
      '1' : AddDriver;
      '2' : ViewDriver;
      '3' : RemoveDriver;
    END
  END;

// procedure to view all the locations in the system’s database 

PROCEDURE ViewLocation;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITELN('Locations -');
    WRITELN;
    RESET(LocationFile);
    WHILE NOT EOF(LocationFile) DO
      BEGIN
        READ(LocationFile, Location);
        WITH Location DO
          BEGIN
            WRITELN('Location ID: ', LocationID);
            WRITELN('Post Code: ', Address);
            WRITELN('Estate Name: ', EstateName);            
          END;
        WRITELN;
      END;
      PressKey;
  END;
  

PROCEDURE FindPos;
    VAR
      desiredpos, desiredposplus1 : LONGINT;
      mark: BOOLEAN;
      prevDate, prevEndTime : TDATETIME;
      prevDriverID : STRING;
      nextDate, nextTime : TDATETIME;
    BEGIN
      RESET(ScheduleFile); 
      SEEK(ScheduleFile, FILESIZE(ScheduleFile)-1); // SEEK LASTREC
      READ(ScheduleFile, Schedule);
      newDriverID := Schedule.DriverID;
      // TEMPORARY METHOD TO GET A DRIVER ID
      IF (Schedule.Date + Schedule.Time) <= (newDate + newTime) THEN // IF ALL DRIVERS ARE AVAILABLE
        BEGIN
          WITH Schedule DO     // SIMPLE ADD TO END OF FILE
            BEGIN
              CustomerID := CustomerIDbooking;
              DriverID := newDriverID;
              Cost:= Costfound;
              PickupID := pickup;
              DestinationID := destination;
              Date := newDate;
              Time := newTime;
              expectedArrivaL := newExpectedArrival;
              WRITE(ScheduleFile, Schedule)
            END;
            WRITELN('Booking added successfully! 1');
            PressKey;
        END;

      // Checking if the new booking ends before first booking commences
      SEEK(ScheduleFile, 0);
      READ(ScheduleFile, Schedule);
      IF (Schedule.Date+Schedule.Time) >= (newDate + newExpectedArrival) THEN   // condition if start of first booking is greater or same as than end of new booking
        BEGIN
          SEEK(ScheduleFile, FILESIZE(ScheduleFile)-1);
          REPEAT        // Creating a duplicate of the record at desired pos
            READ(ScheduleFile, Schedule);
            WRITE(ScheduleFile, Schedule);
            SEEK(ScheduleFile, FILEPOS(ScheduleFile)-3);
            UNTIL FILEPOS(ScheduleFile) = 0;
            SEEK(ScheduleFile, 0);
            READ(ScheduleFile, Schedule);
            WRITE(ScheduleFile, Schedule);
            SEEK(ScheduleFile, 0);
            writeln('here2');
            readkey;
            prevDriverID := Driver.DriverID;
            WITH Schedule DO     // SIMPLE ADD BOOKING INTO THE DESIRED POSITION's duplicate
              BEGIN
                CustomerID := CustomerIDbooking;
                DriverID := prevDriverID;
                Cost:= Costfound;
                PickupID := pickup;
                DestinationID := destination;
                Date := newDate;
                Time := newTime;
                expectedArrivaL := newExpectedArrival;
                WRITE(ScheduleFile, Schedule);
              END;
              WRITELN('Booking added successfully! 3');
              PressKey;
          END

      // if first booking starts same time as new booking
      ELSE IF (Schedule.Date+Schedule.Time) >= (newDate + newTime) THEN
        BEGIN
          RESET(DriverFile);
          REPEAT
              READ(DriverFile, Driver);
          UNTIL Schedule.DriverID <> Driver.DriverID;
          prevDriverID := Driver.DriverID;
          REPEAT        // Creating a duplicate of the record at desired pos
            READ(ScheduleFile, Schedule);
            WRITE(ScheduleFile, Schedule);
            SEEK(ScheduleFile, FILEPOS(ScheduleFile)-3);
          UNTIL FILEPOS(ScheduleFile) = 0;
          SEEK(ScheduleFile, 0);
          READ(ScheduleFile, Schedule);
          WRITE(ScheduleFile, Schedule);
          SEEK(ScheduleFile, 0);
          WITH Schedule DO     // SIMPLE ADD BOOKING INTO THE DESIRED POSITION's duplicate
            BEGIN
              CustomerID := CustomerIDbooking;
              DriverID := prevDriverID;
              Cost:= Costfound;
              PickupID := pickup;
              DestinationID := destination;
              Date := newDate;
              Time := newTime;
              expectedArrivaL := newExpectedArrival;
              WRITE(ScheduleFile, Schedule);
            END;
            WRITELN('Booking added successfully! 2');
            PressKey;
        END

      // IF NOT ALL DRIVERS ARE FREE
      ELSE
        BEGIN
          //WRITELN('HERE1');
          RESET(DriverFile);
          mark := FALSE;
          REPEAT
            READ(DriverFile, Driver);
            RESET(ScheduleFile);
            REPEAT
              READ(ScheduleFile, Schedule);
            UNTIL ((Schedule.DriverID = Driver.DriverID) AND ((Schedule.Date + Schedule.Time) > (newDate + newTime))) OR EOF(ScheduleFile); // loop until a booking is found thats taken by the driver wanted and also starts later than the newbooking
            WRITELN('HERE2');
            IF EOF(ScheduleFile) THEN
              BEGIN
                RESET(ScheduleFile);
                REPEAT
                  READ(ScheduleFile, Schedule);
                UNTIL (Schedule.Time + Schedule.Date) > (newTime + newDate);   // loop until a booking later than the new booking is found
                SEEK(ScheduleFile, FILEPOS(ScheduleFile)-1);
                REPEAT
                  READ(ScheduleFile, Schedule);
                  SEEK(ScheduleFile, FILEPOS(ScheduleFile)-2);
                UNTIL Schedule.DriverID = Driver.DriverID;    // searches for the drivers previous booking
                WRITELN('HERE3');
                IF (Schedule.expectedArrival + Schedule.Date) < (newTime + newDate) THEN  // ensures that the drivers prev booking does not eat into the new booking
                  BEGIN
                    RESET(ScheduleFile);
                    REPEAT
                      READ(ScheduleFile, Schedule);
                    UNTIL ((Schedule.Date + Schedule.Time) > (newDate + newTime));
                    SEEK(ScheduleFile, FILEPOS(ScheduleFile)-1);
                    prevDriverID := Driver.DriverID;
                    WITH Schedule DO     // SIMPLE ADD BOOKING INTO THE DESIRED POSITION's duplicate
                     BEGIN
                         CustomerID := CustomerIDbooking;
                         DriverID := prevDriverID;
                         Cost:= Costfound;
                         PickupID := pickup;
                         DestinationID := destination;
                         Date := newDate;
                         Time := newTime;
                         expectedArrivaL := newExpectedArrival;
                         WRITE(ScheduleFile, Schedule);
                     END;
                     mark := TRUE;
                     WRITELN('You''re booking has been entered successfully!');
                     PressKey;
                  END;
                  WRITELN('HERE4');
              END
            ELSE IF (Schedule.Time + Schedule.Date)  > (newDate + newExpectedArrival) THEN    // ensures that the booking doesnt go into the drivers next booking
              BEGIN
                SEEK(ScheduleFile, FILEPOS(ScheduleFile)-1);
                REPEAT
                  READ(ScheduleFile, Schedule);
                  SEEK(ScheduleFile, FILEPOS(ScheduleFile)-2);
                UNTIL Schedule.DriverID = Driver.DriverID; // Finding his prev booking
                WRITELN('HERE5');
                IF (Schedule.expectedArrival) < (newDate + newTime) THEN   // ensures that drivers prev booking does not eat into new booking
                  BEGIN
                    RESET(ScheduleFile);
                    REPEAT
                      READ(ScheduleFile, Schedule);
                    UNTIL ((Schedule.Date + Schedule.Time) > (newDate + newTime));
                    SEEK(ScheduleFile, FILEPOS(ScheduleFile)-1);
                    prevDriverID := Driver.DriverID;
                    WITH Schedule DO     // SIMPLE ADD BOOKING INTO THE DESIRED POSITION's duplicate
                     BEGIN
                         CustomerID := CustomerIDbooking;
                         DriverID := prevDriverID;
                         Cost:= Costfound;
                         PickupID := pickup;
                         DestinationID := destination;
                         Date := newDate;
                         Time := newTime;
                         expectedArrivaL := newExpectedArrival;
                         WRITE(ScheduleFile, Schedule);
                     END;
                    WRITELN('You''re booking has been entered successfully!');
                    PressKey;
                  END;
              END;
          UNTIL mark = TRUE OR EOF(DriverFile);
          IF EOF(DriverFile) THEN
            BEGIN
              WRITELN('You''re booking cannot be completed as all drivers are unavailable...');
              WRITELN;
              WRITELN('Please enter a different booking date');
            END;
        END;
    END;

// procedure to add a booking into the system’s schedule 

PROCEDURE AddBooking;
    BEGIN
          CLRSCR;
          WRITE('Do they know their customer ID(Y/N)? ');
          READLN(Answer1);
          IF LOWERCASE(Answer1) = 'n' THEN
            BEGIN
              WRITE('Do they know the contact information they intially entered(mobile num) Y/N: ');
              READLN(Answer2);
              IF LOWERCASE(Answer2) = 'n' THEN
                BEGIN
                  WRITE('Enter their forename: ');
                  READLN(fname);
                  RESET(CustomerFile);
                  found := FALSE;
                  WHILE NOT EOF(CustomerFile) AND found = FALSE DO
                    BEGIN
                      READ(CustomerFile, Customer);
                      IF Customer.forename = fname THEN
                        BEGIN
                          WRITELN('Forename: ',Customer.Forename,', Surname: ',Customer.Surname,', Age: ',Customer.Age);
                          WRITE('Is this them(Y/N)? ');
                          READLN(Answer3);
                          IF LOWERCASE(Answer3) = 'y' THEN
                            BEGIN
                              found := TRUE;
                              SEEK(CustomerFile, FILEPOS(CustomerFile)-1);
                              CustomerIDbooking := Customer.CustomerID;
                              WRITE('What is the location ID they are being picked up from? ');
                              READLN(pickup);
                              WRITE('What is their desired destination''s ID? ');
                              READLN(destination);
                            END;
                        END;
                    END;
                END
              ELSE IF LOWERCASE(Answer2) = 'y' THEN
                BEGIN
                  WRITE('Enter their contact number: ');
                  READLN(Contact);
                  RESET(CustomerFile);
                  found := FALSE;
                  WHILE NOT EOF(CustomerFile) AND found = FALSE DO
                    BEGIN
                      READ(CustomerFile, Customer);
                      IF Customer.Contact = Contact THEN
                        BEGIN
                          WRITELN('Forename: ',Customer.forename,', Surname: ',Customer.Surname);
                          WRITE('Is this them(Y/N)? ');
                          READLN(Answer4);
                          IF LOWERCASE(Answer4) = 'y' THEN
                            BEGIN
                              found := TRUE;
                              SEEK(CustomerFile, FILEPOS(CustomerFile)-1);
                              CustomerIDbooking := Customer.CustomerID;
                              WRITE('What is the location ID they are being picked up from? ');
                              READLN(pickup);
                              WRITE('What is their desired destination''s ID? ');
                              READLN(destination);
                              WRITE('What is the date of this pickup? ');
                              READLN(Date10);
                              newDate := STRTODATE(Date10);
                              WRITE('What is the time of this pickup? ');
                              READLN(Time10);
                              newTime := STRTOTIME(Time10);
                              WRITE('Enter the Estimated Arrival Time: ');
                              READLN(expected10);
                              newExpectedArrival := STRTOTIME(expected10);
                              WRITE(‘Enter the cost of this booking: ‘);
                              READLN(Costfound);
                            END;
                       END;
                    END;
                END

              ELSE
                BEGIN
                  WRITELN('Answers must be in ''y'' or ''n'' unless you''re instructed otherwise.');
                  WRITELN('Booking will be cancelled, please restart.');
                  halt;
                END;
            END
          ELSE IF LOWERCASE(Answer1) = 'y' THEN
            BEGIN
              WRITE('Enter their CustomerID: ');
              READLN(verifyCustomerIDbooking);
              WRITELN;
              WRITELN(verifyCustomerIDbooking);
              WRITE('Are you sure this is their customerID(Y/N)? ');
              READLN(Answer5);
              IF LOWERCASE(Answer5) = 'y' THEN
                BEGIN
                  CustomerIDbooking := verifyCustomerIDbooking;
                  WRITE('What is the location ID they are being picked up from? ');
                  READLN(pickup);
                  WRITE('What is their desired destination''s ID? ');
                  READLN(destination);
                  WRITE('What is the date of this pickup? ');
                  READLN(Date10);
                  newDate := STRTODATE(Date10);
                  WRITE('What is the time of this pickup? ');
                  READLN(Time10);
                  newTime := STRTOTIME(Time10);
                  WRITE('Enter the Estimated Arrival Time: ');
                  READLN(expected10);
                  newExpectedArrival := STRTOTIME(expected10);
                  WRITE(‘Enter the cost of this booking: ‘);
                  READLN(Costfound);

                END

              ELSE IF LOWERCASE(Answer5) = 'n' THEN
                BEGIN
                  WRITE('Enter their CustomerID: ');
                  READLN(verifyCustomerIDbooking2);
                  WRITELN;
                  WRITELN(verifyCustomerIDbooking2);
                  WRITE('Are you sure this is their customerID(Y/N)? ');
                  READLN(Answer6);
                  IF LOWERCASE(Answer6) = 'y' THEN
                    BEGIN
                      CustomerIDbooking := verifyCustomerIDbooking2;
                      WRITE('What is the location ID they are being picked up from? ');
                      READLN(pickup);
                      WRITE('What is their desired destination''s ID? ');
                      READLN(destination);
                      WRITE('What is the date of this pickup? ');
                      READLN(Date10);
                      newDate := STRTODATE(Date10);
                      WRITE('What is the time of this pickup? ');
                      READLN(Time10);
                      newTime := STRTOTIME(Time10);
                      WRITE('Enter the Estimated Arrival Time: ');
                      READLN(expected10);
                      newExpectedArrival := STRTOTIME(expected10);
                      WRITE(‘Enter the cost of this booking: ‘);
                      READLN(Costfound);

                    END

                ELSE
                  BEGIN
                    WRITELN('Please restart your booking.');
                    halt;
                  END;
                END
              ELSE
                BEGIN
                  WRITELN('Please restart your booking.');
                  halt;
                END;
            END;
            FindPos; //procedure to find the position to enter the new booking
        END;

// procedure to view all bookings in the system database

PROCEDURE RemoveBooking;
VAR
  DeleteDateStr, DeleteTimeStr: STRING;
  DeleteDate, DeleteTime : TDATETIME;
  Found: BOOLEAN;
  TempFile: ScheduleFileType;
BEGIN
  RESET(ScheduleFile);
  Found := FALSE;
  ASSIGN(TempFile, SelectedDrive + ':\Computer Science\Mr Martin\Pascal\Coursework\temp.dta');
  REWRITE(TempFile);


  WRITELN('Enter the date of booking to delete: ');
  READLN(DeleteDateStr);
  DeleteDate := STRTODATE(DeleteDateStr);
  WRITELN('Enter the time of booking to delete: ');
  READLN(DeleteTimeStr);
  DeleteTime := STRTOTIME(DeleteTimeStr);




  Found:=FALSE;
  RESET(ScheduleFile);
  WHILE NOT EOF(ScheduleFile) DO
  BEGIN
    READ(ScheduleFile, Schedule);
    IF (Schedule.Date+Schedule.Time) <> (DeleteDate+DeleteTime) THEN
      WRITE(TempFile, Schedule)
    ELSE
      Found := TRUE;
  END;


  IF Found THEN
  BEGIN
    REWRITE(ScheduleFile);
    RESET(TempFile);


    // Copy all bookings from the temp file back to the original file
    WHILE NOT EOF(TempFile) DO
    BEGIN
      READ(TempFile, Schedule);
      WRITE(ScheduleFile, Schedule);
    END;


    CLOSE(TempFile);


    WRITELN('Booking deleted successfully!');
  END
  ELSE
  BEGIN
    CLOSE(TempFile);
    WRITELN('Booking not found!');
  END;
  PressKey;
END;
  
      
PROCEDURE ViewSchedule;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITELN('Bookings -');
    WRITELN;
    RESET(ScheduleFile);
    WHILE NOT EOF(ScheduleFile) DO
      BEGIN
        READ(ScheduleFile, Schedule);
        WITH Schedule DO
          BEGIN
            WRITELN('CID: ', CustomerID);
            WRITELN('DID: ',DriverID);
            WRITELN('Date: ',DATETOSTR(Date));
            WRITELN('Time: ',TIMETOSTR(Time));
            WRITELN('Exp A: ',TIMETOSTR(expectedArrival));
            WRITELN(‘Cost: ‘,Cost);
          END;
        WRITELN;
      END;
      PressKey;
  END;

// procedure to show an individual drivers schedule

PROCEDURE IndividualBooking;
  VAR
    DriverIDwanted : STRING;
    Count : LONGINT;
  BEGIN
    WRITELN;
    WRITE('Enter the ID of the driver: ');
    READLN(DriverIDwanted);
    CLRSCR;
    WRITELN;
    WRITELN(' -- Driver ',DriverIDwanted,'''s Bookings --');
    WRITELN;
    RESET(ScheduleFile);
    Count := 0;
    
    WHILE NOT EOF(ScheduleFile) DO
      BEGIN
        READ(ScheduleFile, Schedule);
        IF Schedule.DriverID = DriverIDwanted THEN
          BEGIN
            Count := Count + 1;
            With Schedule DO
              BEGIN
                WRITELN('CID: ', CustomerID);
                WRITELN('DID: ',DriverID);
                WRITELN('Date: ',DATETOSTR(Date));
                WRITELN('Time: ',TIMETOSTR(Time));
                WRITELN('Exp A: ',TIMETOSTR(expectedArrival));
                WRITELN(‘Cost: ‘,Cost);
              END;
              WRITELN;
          END;
      END;
      WRITELN('This driver has ',Count,' bookings. ');
      WRITELN;
      PressKey;
  END;
 
// Sub menu for the Bookings being Edited and viewed
 
PROCEDURE BookingMenu;
  BEGIN
    CLRSCR;
    WRITELN;
    WRITELN(' -- Booking SECTION -- ');
    WRITELN;
    WRITELN('Options Available ');
    WRITELN;
    WRITELN('1 - Add a Booking');
    WRITELN('2 - View Schedule');
    WRITELN('3 - View Individual Driver Schedules');
    WRITELN('4 - Remove a Booking');
    WRITELN;
    WRITE('Please select an option: ');
    Choice := READKEY;
    READLN(Choice);
    CASE Choice OF
      '1' : AddBooking;
      '2' : ViewSchedule;
      '3' : IndividualBooking;
      '4' : RemoveBooking;
    END
  END;  

  // Main Menu for the system

  PROCEDURE Menu;
    BEGIN
      REPEAT
        CLRSCR;
        WRITELN;
        WRITELN('-- Welcome to our Taxi Booking System --');
        WRITELN;
        WRITELN('1 – Bookings Section');
        WRITELN('2 – Customers Section');
        WRITELN('3 – Drivers Section');
        WRITELN('4 - View Locations');
        WRITELN('5 - Exit');
        WRITELN;
        WRITE('Please Select an Option: ');
        Choice := READKEY;
        WRITELN(Choice);
        CASE Choice OF
           '1' : BookingMenu;
           '2' : CustomerMenu;
           '3' : DriverMenu;
           '4' : ViewLocation; 
        END;
      UNTIL Choice = '5';
    END;
