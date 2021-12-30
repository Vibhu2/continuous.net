[Home](../README.md)

# ChildSmiles Group, LLC

- **Address**:-
- **PhoneNo**:-
- **OfficeTimings**:-

## Point of Contact if any / CTO information

    **In case of Major Outages Jeff Ayes must be notified:**

    **Jeff Ayes**: 201-207-3231

    * NRK: (973) 578-8788

    * Office Manager: Daniela Borges
    * ELZ: (908) 469-9100

    * Office Manager: Erika Teixeira
    * Orange: (973) 481-5000

    * Office Manager: Daniela Teixeira
    * Pearly BKH: (908) 464-6789

    * Office Manager: Evelyn Ferrera
    * Pearly WHP: (973) 532-6222

    * Office Manger: Kate Rodriguez
    * Fair Lawn ASC(FLASC): (201) 791-0100

    * Office Manager: Jacqueline Cleary
    * Washington Park Pediatrics(WPP): (973) 622-3890
    * Office Manager: Emely Torres
    * Columbus Hospital Kids Care(CHOS): (973) 268-5862

    * Office Manager: Evelis Baez

## Network / Infrastructure Diagram


## Emails info
    Emails are configured on O365

## Important Servers / Functions

There are total **47 servers** in Connectwise for this client (Update later in january in fracture is upgrading)

* **App01** – Front End Server: Brokers User connections to MIDDLE TIER SERVER

* **App02** – Middle Tier Server: Used to connect users to Open Dental Database

* **App03** – Open Dental Database. Ran on Linux Server running MySQL 5.6

* **App03-r** – Open Dental Report Server. This server is running as a SLAVE to the Master Open Dental Server(APP03). All database information is copied for Reporting purposes.

## Printer Info


## File-share Info


## Backups info

    NRK: BK01(10.10.101.250)

    ELZ: BK01(10.10.103.250)

    Orange: BK01(10.100.40.250)

    Pearly(BKH and WHP): BK01(10.10.102.250)

## AV Software info


## Firewall info

## Virtual Environment

    Hyper-V management can be accessed via the following Servers:

    NRK: MON01(10.10.101.249)

    ELZ: MON01(10.10.103.249)

    Orange: MON01(10.100.40.249)

    Pearly(BKH and WHP): MON01(10.10.102.249)


## Important Notes

  * For Flex issues, see this page: https://continuousnet.itglue.com/1946577/docs/5371135#version=published&documentMode=view
  * Printers use SMTP2GO to send Scanned Documents via Email
  * Email utilizes Office 365 + Barracuda Email Security
  * Static IP Assignments for Printers can be found in IT Glue
  * Fair Lawn(FLASC) and Bleeker St(BKR) both use NRK for Domain Authentication
  * BKR and FLASC use ALL Open Dentals from All locations via Red Tunnels and direct Connection to the IP ADRESS of the APP03 Server
  * BKR and FLASC use ALL EZ Dent servers via Red Tunnels and Direct connection to the IP ADDRESS of APP01 Server
  * DHCP is handled on MON01 servers for all large Clinic sites. For FLASC and BKR, SOPHOS handles DHCP
  * Some users have ScreenConnect Logins for Remote Desktop Capabilities. These logins are located in 1Pass.
    
  ### EZdent-i: Pano and 3D Xray Software

  If there is an issue with PANO, 3D imaging, EZ Sensor, or EZdent-I, call VATECH Support

  VATECH Support: 1-888-396-6872 Option 2

  Servers/Port Settings: (Example Below. Same PORT and PORT SETTINGS Will be used by all sites.

   IP of Database must change for each site)
  ![Pano](https://user-images.githubusercontent.com/25838247/147770056-5a5bbb3f-ad9d-42b9-851d-a0d30df7608d.png)

  NRK: 192.168.201.10

  Orange: 10.100.41.10

  ELZ: 192.168.203.10

  ### ROMEXIS(ONLY USED IN BKH AND WHP for 3D/Xray Imaging)

  Romexis Support: Imaging Support – 630-529-2300

  Viewing Software: DEXIS – Installed on local computer and points to 192.168.202.10

  ### Open Dental: Practice Management Software

  Open Dental Install located on \\app01\OpenDentImages\SetupFiles\**InsertLatestVersion** for every location. Current Version: 20.1.49

  If there is an issue with Open Dental Servers, Call Open Dental Support:

  Open Dental Support: 503-363-5432

  Hours of operation (Pacific time)
  Support Hours:
  Monday - Thursday 5:00 am to 5:25 pm
  Friday 5:00 am to 5:00 pm
  Saturday 7:00 am to 3:00 pm
  Sunday 7:00am to 11:00 am

  ### Orange:

  App01: 10.10.41.10

  App02: 10.100.41.11

  App03: 10.100.41.26

  Middle Tier - http://APP02.orange.smiles.com/OpenDentalServer/ServiceMain.asmx

  ![orange](https://user-images.githubusercontent.com/25838247/147773271-c3e50c54-fb94-466c-b6a0-853a19392707.png)

  Direct to server: (Only use in cases where Middle Tier is not working)

   App03 OR 10.100.41.26. Password can be found in 1Pass

  ![orange2](https://user-images.githubusercontent.com/25838247/147773331-7708366f-8539-4d4e-a170-8e23a4c44ff9.png)

  ### NRK

  Connection: opendental.nrk.smiles.com

  Direct connection to App03/192.168.201.26 Is also a viable solution for connection.
  ![NRK](https://user-images.githubusercontent.com/25838247/147773517-5e52b303-1ecb-42a9-8f9f-b8cda91e171b.png)

  Direct connection to App03/192.168.201.26 Is also a viable solution for connection.

  App01: 192.168.201.10

  App02: 192.168.201.11

  App03: 192.168.201.26

  App03-r: 192.168.201.25

  ### ELZ

  Connection: opendental.nrk.smiles.com

  Direct connection to App03/192.168.201.26 Is also a viable solution for connection.

  ![ELZ](https://user-images.githubusercontent.com/25838247/147774225-02f77d61-c0af-426d-ae50-cffe400a0fa9.png)

  App01: 192.168.203.10

  App02: 192.168.203.11

  App03: 192.168.203.26

  App03-r: 192.168.203.25

  **Pearly BKH + Pearly WHP**(servers shared by both locations)

  **Middle Tier**: http://APP02.bkh.pearly.com/OpenDentalServer/ServiceMain.asmx

  Direct connection to App03/192.168.202.26 Is also a viable solution for connection.

  ![PearlyBHK](https://user-images.githubusercontent.com/25838247/147774366-9ea2ee83-1356-4011-a20b-64085614797f.png)

  App01: 192.168.202.10

  App02: 192.168.202.11

  App03: 192.168.202.26

  App03-r: 192.168.202.25

