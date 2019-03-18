set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           AODV                     ;# ad-hoc routing protocol 
set val(nn)           4 
set val(energymodel)    EnergyModel

set ns_    [new Simulator]

set tracefd     [open simple_aodv.tr w]
$ns_ trace-all $tracefd

set nf [open wireless2-out.nam w]           ;# for nam tracing
$ns_ namtrace-all-wireless $nf 500 500

set topo	[new Topography]

$topo load_flatgrid 500 500

create-god $val(nn)

# Configure nodes

        $ns_ node-config -adhocRouting $val(rp) \
                         -llType $val(ll) \
                         -macType $val(mac) \
                         -ifqType $val(ifq) \
                         -ifqLen $val(ifqlen) \
                         -antType $val(ant) \
                         -propType $val(prop) \
                         -phyType $val(netif) \
                         -topoInstance $topo \
                         -channelType $val(chan) \
			-energyModel $val(energymodel) \
			 -initialEnergy 15 \
                   	-rxPower 0.5 \
			 -txPower 1.0 \
           	        -idlePower 0.0 \
			-sensePower 0.3 \
                         -agentTrace OFF \
                         -routerTrace ON \
                         -macTrace OFF \
                         -movementTrace OFF   

set energy(0) 5

#$ns_ node-config -initialEnergy 5 \
 #               -rxPower 0.5 \
#		    -txPower 1.0 \
  #              -idlePower 0.0 \
#		    -sensePower 0.3 

	set node_(0) [$ns_ node]
	$node_(0) color black
	
set energy(1) 5

#$ns_ node-config -initialEnergy 5 \
 #               -rxPower 0.5 \
#		    -txPower 1.0 \
 #               -idlePower 0.0 \
#		    -sensePower 0.3 

	set node_(1) [$ns_ node]
	$node_(1) color black
	
#
# Provide initial (X,Y, for now Z=0) co-ordinates for node_(0) and node_(1)
#

set energy(2) 5

set node_(2) [$ns_ node]
	$node_(2) color black

$ns_ node-config -adhocRouting $val(rp) \
                         -llType $val(ll) \
                         -macType $val(mac) \
                         -ifqType $val(ifq) \
                         -ifqLen $val(ifqlen) \
                         -antType $val(ant) \
                         -propType $val(prop) \
                         -phyType $val(netif) \
                         -topoInstance $topo \
                         -channelType $val(chan) \
			-energyModel $val(energymodel) \
			 -initialEnergy 1000000 \
                   	-rxPower 0.5 \
			 -txPower 1.0 \
           	        -idlePower 0.0 \
			-sensePower 0.3 \
                         -agentTrace OFF \
                         -routerTrace ON \
                         -macTrace OFF \
                         -movementTrace OFF   

set energy(3) 5
 
set node_(3) [$ns_ node]
	$node_(3) color black


$node_(0) set X_ 400.0
$node_(0) set Y_ 250.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 300.0
$node_(1) set Y_ 300.0
$node_(1) set Z_ 0.0


$node_(2) set X_ 450.0
$node_(2) set Y_ 300.0
$node_(2) set Z_ 0.0


$node_(3) set X_ 400.0
$node_(3) set Y_ 400.0
$node_(3) set Z_ 0.0

#
# Node_(1) starts to move towards node_(0)

##$ns_ at 5.0 "$node_(1) setdest 50.0 50.0 40.0"
##$ns_ at 5.0 "$node_(0) setdest 450.0 450.0 10.0"

# Node_(1) then starts to move away from node_(0)
##$ns_ at 100.0 "$node_(1) setdest 490.0 480.0 15.0"

$ns_ initial_node_pos $node_(0) 20
$ns_ initial_node_pos $node_(1) 20
$ns_ initial_node_pos $node_(2) 20
$ns_ initial_node_pos $node_(3) 20
# TCP connections between node_(0) and node_(1)

set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 0.0 "$ftp start"

set tcp [new Agent/TCP]
$tcp set class_ 3
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 0.0 "$ftp start" 

set tcp [new Agent/TCP]
$tcp set class_ 4
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(3) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 0.0 "$ftp start"

set tcp [new Agent/TCP]
$tcp set class_ 5
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(1) $tcp
$ns_ attach-agent $node_(3) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 0.0 "$ftp start"

set tcp [new Agent/TCP]
$tcp set class_ 5
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp
$ns_ attach-agent $node_(3) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 0.0 "$ftp start"
#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0001 "stop"
$ns_ at 150.0002 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd nf
    close $tracefd
	close $nf
	 
}
puts "Starting Simulation..."
$ns_ run

