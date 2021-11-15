Attribute VB_Name = "Mod_Protocol_Dunkansdk"
Option Explicit

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

' Author: maTih

' - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

'Handles the packets of Client
Private Enum ClientDaoPacketID

   SendReto        ' - /Retos
   AcceptReto      ' - /Retas
   partystart      ' - Party exp
   ChangeExpParty  ' - Cambia los porcentajes de la party
   SendSoport      ' - Soporte
   SendSoportForm  ' - FrmSoport
   ReadSoport      ' - Leer soporte
   RespondSoport   ' - Responder soporte
   QuestAcept      ' - Aceptar Quest index
   QuestRequestInf ' - Requiere info de la quest actual
   BankGoldTrans   ' - Transfiere oro de un personaje a otro
   EventIngress    ' - Ingresa al evento actual
   DragObj         ' - Drag & Drop (Inventario)
   DragDropObj     ' - Drag & Drop (Target)
   RecoverAccount  ' - Recupera cuenta
   RequestTorneoF  ' - Admin form Torneo.
   CreateTorneo    ' - Crea un torneo.
   ActionTorneo    ' - Admin accion Torneo.
   IngressTorneo   ' - User ingresa al torneo
   
   'Accounts in developed
   CreateNewAccount
   LoginExistingAccount
   LoginCharAccount
   
   ' - - - - - - - - - - - - - - - - -
   
   OffertSubast    ' - Oferta subasta actual
   CreateSubast    ' - User crea una subast
   ScreenDenounce  ' - Foto denuncia area visión
   RequestScreen   ' - Admin requiere screen de un cliente
   
End Enum

'Handles the packets off server
Private Enum ServerDaoPacketID

   CreateParticle = 6 ' - Crea particula sobre el char y victimchar
   createproyectile ' - Crea Proyectiles (flechas) sobre chars
   CreateMeditation ' - Crea particula sobre el charindex (meditar)
   SendQuestForm    ' - Envía formulario de quest
   SendSoportFormS  ' - Envía formulario de soporte
   CreateDamageMap  ' - Crea daño en el mapa
   MovimentWeapon   ' - Movimiento del arma
   MovimentShield   ' - Movimiento del escudo
   ChangeHour       ' - Cambia hora del cliente (Noche, día, etc)
   SendTorneoF      ' - Envía form del panelTorneo.
   
   'Accounts in developed
   ReceivedAccount
   UpdateAccount
   
   ' - - - - - - - - - - - - - - - - -
   
   SendUserInventory  ' - Recibe los objetos del inventario
   UploadScreen
   SendRanking
   
   UpdateUsers        ' - Recibe usuarios onlines.
   
End Enum

' Declares
Public PuedeScreen      As Boolean
Public CounterScreen    As Byte

'ORDEN I N V I O L A B L E DE MANEJO DE RUTINAS Y FUNCIONES.
'HANDLE + PAQUETE (EN INGLES)
'WRITE + "DAO" + PAQUETE (EN INGLES)
'FUNCTION DUNKAN + PAQUETE (EN INGLES)

Public Sub HandleDAOProtocol()


' / Author: maTih
' / Note: Handling Dao Packet IDs sending by server.

'remove byte of memory
Call incomingData.ReadByte

Dim DAOPacketID As Byte

'WE READ THE FACT THAT USED TO REMOVE THE MEMORY

DAOPacketID = incomingData.PeekByte

Select Case DAOPacketID

'WHAT PACKAGE RECEIVED?
   Case ServerDaoPacketID.CreateParticle
        Call HandleCreateParticle
    
    Case ServerDaoPacketID.createproyectile
        Call HandleCreateProyectile
        
   'CREA PARTICULA/FX SOBRE UN CHAR
   Case ServerDaoPacketID.CreateMeditation
        Call HandleCreateParticleMeditar
        
  'RECIBE LA ACCION PARA MOSTRAR EL FORMULARIO DE QUEST
   Case ServerDaoPacketID.SendQuestForm
        Call HandleSendQuestForm
        
   'RECIBE LA ACCION PARA MOSTRAR EL FORMULARIO DE SOPORTES
   Case ServerDaoPacketID.SendSoportFormS
        Call HandleSendSupportForm
        
   'CREA EL DAÑO DE UN CHAR SOBRE EL MAPA
   Case ServerDaoPacketID.CreateDamageMap
        Call HandleCreateDamageMap
        
   'CREA UN MOVIMIENTO DE ARMA SOBRE CHAR
   Case ServerDaoPacketID.MovimentWeapon
        Call HandleMovimentWeapon
        
   'CREA UN MOVIMIENTO DE ESCUDO SOBRE CHAR
   Case ServerDaoPacketID.MovimentShield
        Call HandleMovimentShield
        
   'RECIBE LA HORA DEL SERVIDOR
   Case ServerDaoPacketID.ChangeHour
        Call HandleChangeHour
        
   'RECIBE LA ACCION PARA MOSTRAR EL FORMULARIO DEL TORNEO
   Case ServerDaoPacketID.SendTorneoF
        Call HandleShowTorneoForm
        
   'RECIBE LA CUENTA ENTERA
   Case ServerDaoPacketID.ReceivedAccount
        Call HandleReceivedAccount
        
   'UPDATE X SLOT DE SU USERACCOUNT
   Case ServerDaoPacketID.UpdateAccount
        Call HandleUpdateAccount
   
   'RECIBE EL INVENTARIO Y LO AGREGA A UN LISTBOX(SUBASTA)
   Case ServerDaoPacketID.SendUserInventory
       Call HandleSendUserInventory
       
    'RECIBE EL PAQUETE Y SUBE UNA FOTO AL SERVIDOR FTP
    Case ServerDaoPacketID.UploadScreen
       Call HandleScreenUpload
       
    'RECIBE EL RANKING Y SUS PERSONAJES
    Case ServerDaoPacketID.SendRanking
       Call HandleSendRAnking
       
    Case ServerDaoPacketID.UpdateUsers
       Call handleUpdateUsers
    
   Case Else
   
        WriteDenounce UserName & "Rrecibió un paquete sin codear, packetID = " & DAOPacketID
   
End Select

End Sub

Private Sub HandleCreateParticle()
' / Author: maTih
' / Note: Sending particles from one char to another

Call incomingData.ReadByte

Dim SendChar        As Integer  'UserIndex
Dim ReceivedChar    As Integer  'Víctima
Dim ParticleID      As Byte     'Particle ID

SendChar = incomingData.ReadInteger()
ReceivedChar = incomingData.ReadInteger()
ParticleID = incomingData.ReadByte()

Debug.Print "Receivedchar : " & ReceivedChar & " sendchar : " & SendChar

create_ParticleChar SendChar, ReceivedChar, ParticleID

End Sub

Private Sub HandleCreateProyectile()

With incomingData

Call .ReadByte

Dim CharSending      As Integer
Dim CharRecieved     As Integer
Dim GrhIndex         As Integer

CharSending = .ReadInteger()
CharRecieved = .ReadInteger()
GrhIndex = .ReadInteger()

MsgBox CharSending & " : " & CharRecieved & " GRH : " & GrhIndex

Engine_Projectile_Create CharSending, CharRecieved, GrhIndex, 0

End With

End Sub

Private Sub HandleCreateParticleMeditar()

' / Author: maTih
' / Note: Creating particleID our FX ID , With CharINDEX

Call incomingData.ReadByte

Dim SendChar    As Integer  'Charindex
Dim EffectID    As Byte     'ID of FX/Particle
Dim Loops       As Integer  'Loops of FX

SendChar = incomingData.ReadInteger()
EffectID = incomingData.ReadByte()
Loops = incomingData.ReadInteger()

create_ParticleChar SendChar, SendChar, EffectID

End Sub



Private Sub HandleSendQuestForm()

' / Author: maTih
' / Note: Received by server data : quest recompense & Num of quests

Call incomingData.ReadByte

Dim NumQ            As Byte
Dim Recompense()    As String
Dim LoopC           As Long

NumQ = incomingData.ReadByte

ReDim Recompense(1 To NumQ)

    For LoopC = 1 To NumQ
        Recompense(LoopC) = incomingData.ReadASCIIString
    Next LoopC

End Sub

Private Sub HandleSendSupportForm()

' / Author: maTih
' / Note: Received by server data : support numbers and names

Call incomingData.ReadByte

Dim idName          As Byte
Dim SupportsSends() As String
Dim LoopC           As Long

idName = incomingData.ReadByte()

ReDim SupportsSends(1 To idName)

    For LoopC = 1 To idName
        SupportsSends(LoopC) = incomingData.ReadASCIIString()
    Next LoopC

End Sub

Private Sub HandleCreateDamageMap()

' / Author: maTih
' / Note: Received by server data : X , Y & Damage.

Call incomingData.ReadByte

Dim X       As Byte
Dim Y       As Byte
Dim Damage  As Integer

X = incomingData.ReadByte
Y = incomingData.ReadByte
Damage = incomingData.ReadInteger

Engine_Damage_Create X, Y, Damage, 255, 0, 0

End Sub

Private Sub HandleMovimentWeapon()

' / Author: maTih

Call incomingData.ReadByte

Dim charIndex As Integer          'Char Index

charIndex = incomingData.ReadInteger

With charlist(charIndex)
    .InMoviment = True
    .Arma.WeaponWalk(.Heading).Started = 1
    .Escudo.ShieldWalk(.Heading).Started = 1
End With

End Sub

Private Sub HandleMovimentShield()

Call incomingData.ReadByte

Dim charIndex As Integer          'CHAR INDEX

charIndex = incomingData.ReadInteger

With charlist(charIndex)
    .InMoviment = True
    .Escudo.ShieldWalk(.Heading).Started = 1
End With

End Sub

Private Sub HandleShowTorneoForm()

' / Author: maTih
' / Note: Received package it form show !

'Remove byte of memory
Call incomingData.ReadByte

'This loop users will go
Dim i               As Long

'Number of users to add to list
Dim NumUsers        As Byte
Dim ArrayUsers()    As String

'We read the amount and generate the loop
NumUsers = incomingData.ReadByte

'Resize the matrix and loop start!
ReDim ArrayUsers(1 To NumUsers)

    'Now let's walk to one and adding to the list
    For i = 1 To NumUsers
        ArrayUsers(i) = incomingData.ReadASCIIString
    Next i

End Sub

Private Sub HandleChangeHour()

' / Author: maTih
' / Note: Time received sent by server to handle the state of the day

'Otra ves sopa, kill of memory 1 byte .
Call incomingData.ReadByte

'**** | Received Info for handling state of day | ****'
Dim HourReceived        As Byte
Dim MinutesReceiveds    As Byte

HourReceived = incomingData.ReadByte
MinutesReceiveds = incomingData.ReadByte

Debug.Print "Hora: " & HourReceived
Debug.Print "Minutos: " & MinutesReceiveds

'Ema maneja esto ah como lo tenías hecho vos, ahora
'La hora la controla el servidor ^^
End Sub

Private Sub HandleUpdateAccount()

' / Author: maTih
' / Note: Update slot of account.

Call incomingData.ReadByte

'VARIABLES OF HANDLING DATA
Dim slotR   As Byte    'received slot .
Dim Name    As String
Dim Clase   As String
Dim Nivel   As Byte
Dim Cuerpo  As Integer
Dim Cabeza  As Integer
Dim Arma    As Byte
Dim Escudo  As Byte
Dim Casco   As Byte

slotR = incomingData.ReadByte
Name = incomingData.ReadASCIIString
Clase = incomingData.ReadASCIIString
Nivel = incomingData.ReadByte
Cuerpo = incomingData.ReadInteger
Cabeza = incomingData.ReadInteger
Arma = incomingData.ReadByte
Escudo = incomingData.ReadByte
Casco = incomingData.ReadByte

    If Cuentas.CantidadPersonajes = 0 Then
        ReDim Cuentas.charInfo(1 To 1) As CharData
            Cuentas.CantidadPersonajes = 1
            Cuentas.charInfo(1).Head = Cabeza
            Cuentas.charInfo(1).Body = Cuerpo
            Cuentas.charInfo(1).Weapon = Arma
            Cuentas.charInfo(1).Shield = Escudo
            Cuentas.charInfo(1).Helmet = Casco
            Cuentas.charInfo(1).Name = Name
            Cuentas.charInfo(1).Nivel = Nivel
    Else
        If Cuentas.charInfo(slotR).Name <> "NothingPJ" Then
            Cuentas.CantidadPersonajes = Cuentas.CantidadPersonajes + 1
            ReDim Cuentas.charInfo(1 To Cuentas.CantidadPersonajes) As CharData
                Cuentas.charInfo(slotR).Head = Cabeza
                Cuentas.charInfo(slotR).Body = Cuerpo
                Cuentas.charInfo(slotR).Weapon = Arma
                Cuentas.charInfo(slotR).Shield = Escudo
                Cuentas.charInfo(slotR).Helmet = Casco
                Cuentas.charInfo(slotR).Name = Name
                Cuentas.charInfo(slotR).Nivel = Nivel
        Else
            Cuentas.charInfo(slotR).Head = Cabeza
            Cuentas.charInfo(slotR).Body = Cuerpo
            Cuentas.charInfo(slotR).Weapon = Arma
            Cuentas.charInfo(slotR).Shield = Escudo
            Cuentas.charInfo(slotR).Helmet = Casco
            Cuentas.charInfo(slotR).Name = Name
            Cuentas.charInfo(slotR).Nivel = Nivel
        End If
        
    End If

End Sub

Private Sub HandleReceivedAccount()

' / Author: maTih
' / Note: Receive data for charfile and the characters of the account

Dim Buffer As New clsByteQueue

Call Buffer.CopyBuffer(incomingData)

Call Buffer.ReadByte

'VARIABLES OF HANDLING DATA
Dim CantPj      As Byte
Dim slotR()     As Byte    'received slot .
Dim Names()     As String
Dim Clase()     As String
Dim Nivel()     As Byte
Dim Cuerpo()    As Integer
Dim Cabeza()    As Integer
Dim Arma()      As Byte
Dim Escudo()    As Byte
Dim Casco()     As Byte
Dim i           As Long

CantPj = Buffer.ReadByte

    If CantPj > 0 Then
        For i = 1 To CantPj
            slotR(i) = Buffer.ReadByte
            Names(i) = Buffer.ReadASCIIString
            Clase(i) = Buffer.ReadASCIIString
            Nivel(i) = Buffer.ReadByte
            Cuerpo(i) = Buffer.ReadInteger
            Cabeza(i) = Buffer.ReadInteger
            Arma(i) = Buffer.ReadByte
            Escudo(i) = Buffer.ReadByte
            Casco(i) = Buffer.ReadByte
        Next i
    Else
        slotR(0) = Buffer.ReadByte
        Names(0) = Buffer.ReadASCIIString
        Clase(0) = Buffer.ReadASCIIString
        Nivel(0) = Buffer.ReadByte
        Cuerpo(0) = Buffer.ReadInteger
        Cabeza(0) = Buffer.ReadInteger
        Arma(0) = Buffer.ReadByte
        Escudo(0) = Buffer.ReadByte
        Casco(0) = Buffer.ReadByte
    End If

    Call incomingData.CopyBuffer(Buffer)

End Sub

Private Sub HandleSendUserInventory()
' / Author : maTih
' / Note: Received obj names of userinventory.

'Is not an interface, so it is NEW
'Use the Auxiliary buffer
Dim Buffer As New clsByteQueue

Call Buffer.CopyBuffer(incomingData)

Call Buffer.ReadByte   'remove packetID

'THE NUMBER OF ITEMS THAT HAVE IN YOUR INVENTORY
Dim amountItems As Byte
Dim tmpS()      As String
Dim i           As Long

amountItems = Buffer.ReadByte

ReDim tmpS(1 To amountItems) As String

    'declares one bucle, This will bucle through the objects.
    For i = 1 To amountItems
        tmpS(i) = Buffer.ReadASCIIString
    'Pending of modification
    'FALTA HACERLO, LO GUARDO EN UN STRING PARA NO ROMPER TODO
    Next i

    'cerramos y destruimos el buffer auxiliar, ya tenemos nuestros datos
    Call incomingData.CopyBuffer(Buffer)

End Sub

Private Sub HandleScreenUpload()

' / Author: maTih

With incomingData

    Call .ReadByte
    
    Dim lastscren As Byte
    
    lastscren = .ReadByte
    
    'funcion para subir la foto al servidor ftp..
    
    'uploadfoto lastscren + 1

End With

End Sub

Private Sub handleUpdateUsers()

' / Author : maTih

'not used auxilliarbuffer , used only package containg strings

Call incomingData.ReadByte

  'Stored in this variable the amount received

 UsuariosOnline = incomingData.ReadInteger()
 MsgBox UsuariosOnline
 
End Sub

Private Sub HandleSendRAnking()

' / Author: maTih

Dim buff As New clsByteQueue

Call buff.CopyBuffer(incomingData)

With buff

'remove packetID for memory (1 byte)
Call .ReadByte

'here loop for 1 to 10.
Dim i As Long
For i = 1 To 10

tRAnk.UserNames(i) = .ReadASCIIString
tRAnk.UserLevels(i) = .ReadByte
tRAnk.UserFrags(i) = .ReadInteger
tRAnk.UserClases(i) = .ReadASCIIString

Next i
End With

Call incomingData.CopyBuffer(buff)
End Sub

Public Sub WriteDAOSendReto(ByVal RetoMode As Byte, ByVal Opponent As String, ByVal OpponentTwo As String, ByVal Couple As String, ByVal GLD As Long, ByVal itemDrop As Byte)

' / Author: maTih
' / Note: Send Package of Retos to server .
' / Parameters sends: RetoMode, Opponent, OpponentTwo, GLD & itemDrop(boolean)

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.SendReto)
    Call .WriteByte(RetoMode)
    Call .WriteASCIIString(Opponent)
    Call .WriteASCIIString(OpponentTwo)
    Call .WriteASCIIString(Couple)
    Call .WriteLong(GLD)
   ' Call .WriteBoolean(CBool(itemDrop))
End With

End Sub

Public Sub WriteDAOAcceptReto(ByVal targetName As String)

' / Author: maTih
' / Note: Send package of accept Reto to server.
' / Parameters sends: TargetName.

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.AcceptReto)
    Call .WriteASCIIString(targetName)
End With

End Sub

Public Sub WriteDAOPartyStart()

' / Author: maTih
' / Note: Send Package Of start party
' Null arguments to server, handle of targetUser in server.

Call outgoingData.WriteByte(1)
Call outgoingData.WriteByte(ClientDaoPacketID.partystart)
End Sub

Public Sub WriteDAOChangeExpParty(ByVal tSlot As Byte, ByVal tSLot2, ByVal NewExp As Byte, ByVal NewExp2 As Byte)

' / Author: maTih
' / Note: send package of change exp of actuality party.
' / Parameters sends: tslot 1 and 2(used by handling array) , newexp & newexp2, is new experencie.

With outgoingData
    Call .WriteByte(1)  'HARDCODED :D
    Call .WriteByte(ClientDaoPacketID.ChangeExpParty)
    Call .WriteByte(tSlot)
    Call .WriteByte(tSLot2)
    Call .WriteByte(NewExp)
    Call .WriteByte(NewExp2)
End With

End Sub

Public Sub WriteDAOSendSupport(ByVal SupportMessage As String)

' / Author  -  maTih
' / Note:  Send package of send support.
' / Parameters sends: SupportMessage .

With outgoingData
    Call .WriteByte(1) 'HARDCODED :D
    Call .WriteByte(ClientDaoPacketID.SendSoport)
    Call .WriteASCIIString(SupportMessage)
End With

End Sub

Public Sub WriteDAOSupportForm()

' / Author: maTih
' / Note: Send package is admin received form and show.
'Null arguments send of server.

Call outgoingData.WriteByte(1) 'Hardcoded ! :D
Call outgoingData.WriteByte(ClientDaoPacketID.SendSoportForm)
End Sub

Public Sub WriteDAOSupportRead(ByVal SlotS As Byte)

' / Author: maTih
' / Note: Send package of read support by slot (is privilegies of user , NO LE PASAMOS KBIDA XD)
' / Parameters sends: Slot , byte.

With outgoingData
    Call .WriteByte(1)   'Como el enum ahora empieza desde 1, todo HARDCODEADO Y FEO :D
    Call .WriteByte(ClientDaoPacketID.ReadSoport)
    Call .WriteByte(SlotS)
End With

End Sub

Public Sub WriteDAOResponseSupport(ByVal slot As Byte, ByVal ResponseMessage As String)

' / Author: maTih
' / Parameters send: Slot , responseMessage.

With outgoingData

    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.RespondSoport)
    Call .WriteByte(slot)
    Call .WriteASCIIString(ResponseMessage)
    
End With

End Sub

Public Sub WriteDAOAcceptQuestByIndex(ByVal slot As Byte)

' / Author: maTih
' / Note: Send package of acept quest by QuestIndex(slot)

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.QuestAcept)
    Call .WriteByte(slot)
End With

End Sub

'System of accounts in developed
Public Sub WriteDAOCreateNewAccount(ByVal AccountName As String, ByVal AccountPassword As String, ByVal AccountEmail As String, ByVal AccountPIN As Byte)

' / Author: maTih

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.CreateNewAccount)
    Call .WriteASCIIString(AccountName)
    Call .WriteASCIIString(AccountPassword)
    Call .WriteASCIIString(AccountEmail)
    Call .WriteByte(AccountPIN)
End With

End Sub

Public Sub WriteDAOLoginExistingAccount(ByVal AccountName As String, ByVal AccountPass As String)

' / Author: maTih

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.LoginExistingAccount)
    Call .WriteASCIIString(AccountName)
    Call .WriteASCIIString(AccountPass)
End With
    
End Sub

Public Sub WriteDAOLoginCharAccount(ByVal charSlot As Byte)

' / Author: maTih

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.LoginCharAccount)
    Call .WriteByte(charSlot)
End With

End Sub

Public Sub WriteDAOCreateSubast(ByVal slot As Byte, ByVal Amount As Integer, ByVal MInime As Long)

' / Author: maTih

With outgoingData
    Call .WriteByte(1) 'hardcoding feo.
    Call .WriteByte(ClientDaoPacketID.CreateSubast)
    Call .WriteByte(slot)
    Call .WriteInteger(Amount)
    Call .WriteLong(MInime)
End With

End Sub

Public Sub WriteDAOOffertSubast(ByVal SendOff As Long)

' / Author: maTih

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.OffertSubast)
    Call .WriteLong(SendOff)
End With

End Sub

Public Sub WriteDAOCreateTorneo(ByVal Cupos As Byte, ByVal TIPO As Byte, ByVal PrecioInscripcion As Long)

' / Author: maTih

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.CreateTorneo)
    Call .WriteByte(Cupos)
    Call .WriteByte(TIPO)
    Call .WriteLong(PrecioInscripcion)
End With

End Sub

Public Sub WriteDAODragObj(ByVal tSlot As Byte, ByVal tSLot2 As Byte)

' / Author: maTih

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.DragObj)
    Call .WriteByte(tSlot)
    Call .WriteByte(tSLot2)
End With

End Sub

Public Sub WriteDAODragObjTarget(ByVal X As Byte, ByVal Y As Byte, ByVal slot As Byte, ByVal Cant As Integer)


' / Author: maTih
' / Note  : Drag InventObj for TargetX - TargetY , and Amount

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.DragDropObj)
    Call .WriteByte(slot)
    Call .WriteByte(X)
    Call .WriteByte(Y)
    Call .WriteInteger(Cant)
End With

End Sub

Public Sub WriteScreenDenounce()

' / Author: maTih

    If PuedeScreen = False Then ShowConsoleMsg "Debes esperar 2 minutos para enviar cada foto denuncia.": Exit Sub
    
    PuedeScreen = False
    CounterScreen = 2
    
    With outgoingData
        Call .WriteByte(1)
        Call .WriteByte(ClientDaoPacketID.ScreenDenounce)
    End With
    
End Sub

Public Sub WriteDAOScreenForClient(ByVal UserName As String)

' / Author: maTih

With outgoingData
    Call .WriteByte(1)
    Call .WriteByte(ClientDaoPacketID.RequestScreen)
    Call .WriteASCIIString(UserName)
End With

End Sub
