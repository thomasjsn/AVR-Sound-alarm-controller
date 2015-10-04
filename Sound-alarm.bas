'--------------------------------------------------------------
'                   Thomas Jensen | uCtrl.net
'--------------------------------------------------------------
'  file: AVR_Sound_Alarm
'  date: 22/07/2006
'--------------------------------------------------------------
$crystal = 4000000
Config Portd = Input
Config Portb = Output
Config Watchdog = 1024

'in
'1. Signal: Beep
'2. Signal: Siren pulse
'3. Signal: Buzzer pulse

'out
'1. Siren
'2. Buzzer
'4. Sound LED
'5. Lifesignal

Dim A As Byte , Lifesignal As Integer , Lydled As Integer
Dim S_timer As Integer , B_timer As Integer , Bipp_timer As Integer
Dim Inngang1 As Integer , Inngang2 As Integer , Inngang3 As Integer

Lifesignal = 21
Lydled = 0
S_timer = 0
B_timer = 0
Inngang1 = 0
Inngang2 = 0
Inngang3 = 0
Bipp_timer = 0

Portb = 0

For A = 1 To 20
    Portb.2 = Not Portb.2
    Portb.3 = Not Portb.3
    Waitms 200
Next A

Waitms 500

For A = 1 To 4
    Portb.0 = Not Portb.0
    Waitms 100
Next A

Waitms 1000

Start Watchdog
Portb = 0

Main:

'siren
If S_timer = 0 Then
   Portb.0 = 0
   End If
If S_timer > 0 Then
   S_timer = S_timer - 1
   Portb.0 = 1
   End If

'buzzer
If B_timer = 0 Then
   Portb.1 = 0
   End If
If B_timer > 0 Then
   B_timer = B_timer - 1
   Portb.1 = 1
   End If

'sound-led
If Lydled = 30 Or Lydled = 32 Or Lydled = 34 Then
   Portb.2 = 0
   End If
If Lydled = 31 Or Lydled = 33 Or Lydled = 35 Then
   Portb.2 = 1
   End If
If Lydled > 0 Then Lydled = Lydled - 1

If Inngang3 > 0 And Lydled = 0 Then Lydled = 35
If Inngang2 > 0 And Lydled = 0 Then Lydled = 33
If Inngang1 > 0 And Lydled = 0 Then Lydled = 31

'set siren, buzzer and input timers
If Pind.0 = 0 And Inngang1 = 0 Then S_timer = 1
If Pind.1 = 0 And Inngang2 = 0 Then S_timer = 10
If Pind.2 = 0 And Inngang3 = 0 Then B_timer = 30

If Inngang1 > 0 Then Inngang1 = Inngang1 - 1
If Inngang2 > 0 Then Inngang2 = Inngang2 - 1
If Inngang3 > 0 Then Inngang3 = Inngang3 - 1

If Pind.0 = 0 Then Inngang1 = 40
If Pind.1 = 0 Then Inngang2 = 40
If Pind.2 = 0 Then Inngang3 = 40

'periodic signal
If Bipp_timer > 0 Then Bipp_timer = Bipp_timer - 1
If Bipp_timer = 1 Then S_timer = 1
If Inngang1 = 0 And Inngang2 = 0 And Inngang3 = 0 Then Bipp_timer = 0
If Inngang1 > 0 Or Inngang2 > 0 Or Inngang3 > 0 And Bipp_timer = 0 Then Bipp_timer = 3600

'lifesignal
If Lifesignal > 0 Then Lifesignal = Lifesignal - 1
If Lifesignal = 6 Then Portb.3 = 1
If Lifesignal = 1 Then Portb.3 = 0
If Lifesignal = 0 Then Lifesignal = 21

'loop cycle
Reset Watchdog
Waitms 100
Goto Main
End