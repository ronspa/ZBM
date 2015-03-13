<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio Version=4.1.4.402?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="Shiftregis" Source="MainControlUnit.Shiftregister.prg" Memory="UserROM" Description="Control for chain sensor" Language="IEC" Debugging="true" />
    <Task Name="Simulation" Source="MainControlUnit.Simulation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Main" Source="MainControlUnit.Main.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="IOpolling" Source="IOHandling.IOpolling.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3">
    <Task Name="BU_1" Source="BunchUnits.BU_1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SC_1" Source="BunchUnits.SC_1.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BeltContro" Source="MainBeltUnit.BeltControl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="RS_I" Source="BunchUnits.RS_I.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BU_2" Source="BunchUnits.BU_2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#4">
    <Task Name="ErrorHandl" Source="Exceptionhandling.ErrorHandling.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="can_diag" Source="Exceptionhandling.can_diag.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SC_2" Source="BunchUnits.SC_2.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5">
    <Task Name="Init" Source="BunchUnits.Init.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Sender" Source="Lichtkrant.Sender.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6" />
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8" />
  <VcDataObjects>
    <VcDataObject Name="BU_Gui" Source="Visualisation.BU_Gui_Resized.dob" Memory="UserROM" Language="Vc" Disabled="true" WarningLevel="2" Compress="false" />
    <VcDataObject Name="Mobile" Source="Visualisation.Mobile.dob" Memory="UserROM" Language="Vc" WarningLevel="2" Compress="false" />
  </VcDataObjects>
  <Binaries>
    <BinaryObject Name="vccnum" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arialbd" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsloc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfntttf" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsint" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcshared" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcrt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcbclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfile" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbtn" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcresman" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcalarm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpdsw" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arial" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccovl" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcgclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Mobile02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Mobile03" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccddbox" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccpopup" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccdt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcctext" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccshape" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbmp" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcctrend" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="BU_Gui02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="BU_Gui03" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccslider" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asnxdb1" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="vcpfx20" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpdvnc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="BU_Gui01" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vctcal" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpkat" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcnet" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcmgr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcchspot" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbar" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcclbox" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcchtml" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccstr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccline" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccscale" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccalarm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccgauge" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccurl" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcxml" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asnxdb2" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="OpcUaMap" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Runtime" Source="Libraries.Runtime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="astime" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asieccon" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsTCP" Source="Libraries.AsTCP.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="brsystem" Source="Libraries.brsystem.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asstring" Source="Libraries.asstring.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="standard" Source="Libraries.standard.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="PulsGen" Source="libraries_hav.PulsGen.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="AsNxCoM" Source="Libraries.AsNxCoM.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Inverter" Source="libraries_hav.Inverter.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="BULib" Source="libraries_hav.BULib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="Servo" Source="libraries_hav.Servo.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="SDO" Source="libraries_hav.SDO.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="dvframe" Source="Libraries.dvframe.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Lichtkrant" Source="libraries_hav.Lichtkrant.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="Chain" Source="libraries_hav.Chain.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="hex2dec" Source="libraries_hav.hex2dec.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="Serial" Source="libraries_hav.Serial.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="SensContr" Source="libraries_hav.SensContr.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="MBU_lib" Source="libraries_hav.MBU_lib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="IecCheck" Source="Libraries.IecCheck.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="dataobj" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="fileio" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsArLog" Source="Libraries.AsArLog.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ashw" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Hardware" Source="libraries_hav.Hardware.lby" Memory="UserROM" Language="IEC" Debugging="true" />
  </Libraries>
</SwConfiguration>