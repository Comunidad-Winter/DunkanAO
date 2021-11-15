VERSION 5.00
Begin VB.Form f_Mountain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Mountain Form"
   ClientHeight    =   2175
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   4680
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2175
   ScaleWidth      =   4680
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton Command1 
      Caption         =   "Reset"
      Height          =   360
      Left            =   0
      TabIndex        =   10
      Top             =   1800
      Width           =   990
   End
   Begin VB.Frame FraInformation 
      Caption         =   "Information"
      Height          =   1575
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4455
      Begin VB.CommandButton cmdGenerateMountain 
         Caption         =   "Generate Mountain"
         Height          =   240
         Left            =   2280
         TabIndex        =   9
         Top             =   1200
         Width           =   1815
      End
      Begin VB.TextBox txtaltura 
         Appearance      =   0  'Flat
         Height          =   285
         Left            =   2280
         TabIndex        =   8
         Top             =   360
         Width           =   855
      End
      Begin VB.TextBox txtradio 
         Appearance      =   0  'Flat
         Height          =   285
         Left            =   960
         TabIndex        =   7
         Top             =   1080
         Width           =   855
      End
      Begin VB.TextBox txtY 
         Appearance      =   0  'Flat
         Height          =   285
         Left            =   600
         TabIndex        =   6
         Top             =   720
         Width           =   855
      End
      Begin VB.TextBox txtx 
         Appearance      =   0  'Flat
         Height          =   285
         Left            =   600
         TabIndex        =   5
         Top             =   360
         Width           =   855
      End
      Begin VB.Label lblRadioY 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Y:"
         Height          =   195
         Left            =   360
         TabIndex        =   4
         Top             =   720
         Width           =   150
      End
      Begin VB.Label altura 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Altura:"
         Height          =   195
         Left            =   1680
         TabIndex        =   3
         Top             =   360
         Width           =   495
      End
      Begin VB.Label Radio 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Radio:"
         Height          =   195
         Left            =   360
         TabIndex        =   2
         Top             =   1080
         Width           =   465
      End
      Begin VB.Label lblX 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "X:"
         Height          =   195
         Left            =   360
         TabIndex        =   1
         Top             =   360
         Width           =   150
      End
   End
End
Attribute VB_Name = "f_Mountain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdGenerateMountain_Click()
    Call createmontañita(txtx, txtY, txtradio, txtaltura)
    Unload Me
End Sub

Private Sub Command1_Click()
f_Mountain.txtradio = 0
f_Mountain.txtaltura = 0
f_Mountain.txtx = 0
f_Mountain.txtY = 0
End Sub

