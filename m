From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 6/8] infiniband-diags: move
 man/perfquery,sminfo,smpdump,smpquery to rst documentation
Date: Wed, 9 May 2012 18:45:08 -0700
Message-ID: <20120509184508.ff493292.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                |    7 +-
 configure.in               |    4 +
 doc/rst/perfquery.8.in.rst |  176 +++++++++++++++++++++++++++++++++++++++++
 doc/rst/sminfo.8.in.rst    |  101 +++++++++++++++++++++++
 doc/rst/smpdump.8.in.rst   |  104 ++++++++++++++++++++++++
 doc/rst/smpquery.8.in.rst  |  112 ++++++++++++++++++++++++++
 man/perfquery.8            |  189 --------------------------------------------
 man/sminfo.8               |  107 -------------------------
 man/smpdump.8              |   99 -----------------------
 man/smpquery.8             |  122 ----------------------------
 10 files changed, 502 insertions(+), 519 deletions(-)
 create mode 100644 doc/rst/perfquery.8.in.rst
 create mode 100644 doc/rst/sminfo.8.in.rst
 create mode 100644 doc/rst/smpdump.8.in.rst
 create mode 100644 doc/rst/smpquery.8.in.rst
 delete mode 100644 man/perfquery.8
 delete mode 100644 man/sminfo.8
 delete mode 100644 man/smpdump.8
 delete mode 100644 man/smpquery.8

diff --git a/Makefile.am b/Makefile.am
index 16a8fd8..3aa47bf 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,8 +40,7 @@ sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
 		scripts/set_nodedesc.sh scripts/ibclearerrors scripts/ibclearcounters
 endif
 
-man_MANS = man/perfquery.8 man/sminfo.8 \
-		man/smpdump.8 man/smpquery.8 man/saquery.8 man/vendstat.8 \
+man_MANS = man/saquery.8 man/vendstat.8 \
 		man/ibsysstat.8 \
 		man/ibfindnodesusing.8 \
 		man/check_lft_balance.8 man/ibcacheedit.8 \
@@ -63,6 +62,10 @@ man_MANS = man/perfquery.8 man/sminfo.8 \
 		doc/man/ibstat.8 \
 		doc/man/ibswitches.8 \
 		doc/man/ibtracert.8 \
+		doc/man/perfquery.8 \
+		doc/man/sminfo.8 \
+		doc/man/smpdump.8 \
+		doc/man/smpquery.8 \
 		doc/man/infiniband-diags.8 \
 		man/ibidsverify.8
 
diff --git a/configure.in b/configure.in
index 67d3031..66b7fef 100644
--- a/configure.in
+++ b/configure.in
@@ -223,6 +223,10 @@ AC_CONFIG_FILES([\
 	doc/man/ibstat.8 \
 	doc/man/ibswitches.8 \
 	doc/man/ibtracert.8 \
+	doc/man/perfquery.8 \
+	doc/man/sminfo.8 \
+	doc/man/smpdump.8 \
+	doc/man/smpquery.8 \
 	doc/man/infiniband-diags.8 \
 	libibnetdisc/Makefile \
 ])
diff --git a/doc/rst/perfquery.8.in.rst b/doc/rst/perfquery.8.in.rst
new file mode 100644
index 0000000..f5d0e61
--- /dev/null
+++ b/doc/rst/perfquery.8.in.rst
@@ -0,0 +1,176 @@
+=========
+PERFQUERY
+=========
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+-----------------------------------------------
+query InfiniBand port counters on a single port
+-----------------------------------------------
+
+
+SYNOPSIS
+========
+
+perfquery [options] [<lid|guid> [[port] [reset_mask]]]
+
+DESCRIPTION
+===========
+
+perfquery uses PerfMgt GMPs to obtain the PortCounters (basic performance and
+error counters), PortExtendedCounters, PortXmitDataSL, PortRcvDataSL,
+PortRcvErrorDetails, PortXmitDiscardDetails, PortExtendedSpeedsCounters, or
+PortSamplesControl from the PMA at the node/port specified. Optionally shows
+aggregated counters for all ports of node.  Finally it can, reset after read,
+or just reset the counters.
+
+Note: In PortCounters, PortCountersExtended, PortXmitDataSL, and PortRcvDataSL,
+components that represent Data (e.g. PortXmitData and PortRcvData) indicate
+octets divided by 4 rather than just octets.
+
+Note: Inputting a port of 255 indicates an operation be performed on all ports.
+
+
+OPTIONS
+=======
+
+**-x, --extended**
+	show extended port counters rather than (basic) port counters.
+	Note that extended port counters attribute is optional.
+
+**-X, --xmtsl**
+	show transmit data SL counter. This is an optional counter for QoS.
+
+**-S, --rcvsl**
+	show receive data SL counter. This is an optional counter for QoS.
+
+**-D, --xmtdisc**
+	show transmit discard details. This is an optional counter.
+
+**-E, --rcverr**
+	show receive error details. This is an optional counter.
+
+**-D, --xmtdisc**
+	show transmit discard details. This is an optional counter.
+
+**-T, --extended_speeds**
+	show extended speeds port counters. This is an optional counter.
+
+**--oprcvcounters**
+	show Rcv Counters per Op code. This is an optional counter.
+
+**--flowctlcounters**
+	show flow control counters. This is an optional counter.
+
+**--vloppackets**
+	show packets received per Op code per VL. This is an optional counter.
+
+**--vlopdata**
+	show data received per Op code per VL. This is an optional counter.
+
+**--vlxmitflowctlerrors**
+	show flow control update errors per VL. This is an optional counter.
+
+**--vlxmitcounters**
+	show ticks waiting to transmit counters per VL. This is an optional counter.
+
+**--swportvlcong**
+	show sw port VL congestion. This is an optional counter.
+
+**--rcvcc**
+	show Rcv congestion control counters. This is an optional counter.
+
+**--slrcvfecn**
+	show SL Rcv FECN counters. This is an optional counter.
+
+**--slrcvbecn**
+	show SL Rcv BECN counters. This is an optional counter.
+
+**--xmitcc**
+	show Xmit congestion control counters. This is an optional counter.
+
+**--vlxmittimecc**
+	show VL Xmit Time congestion control counters. This is an optional counter.
+
+**-c, --smplctl**
+	show port samples control.
+
+**-a, --all_ports**
+	show aggregated counters for all ports of the destination lid or reset
+	all counters for all ports.  If the destination lid does not support
+	the AllPortSelect flag, all ports will be iterated through to emulate
+	AllPortSelect behavior.
+
+**-l, --loop_ports**
+	If all ports are selected by the user (either through the **-a** option
+	or port 255) iterate through each port rather than doing than aggregate
+	operation.
+
+**-r, --reset_after_read**
+	reset counters after read
+
+**-R, --Reset_only**
+	only reset counters
+
+
+Addressing Flags
+----------------
+
+.. include:: common/opt_G.rst
+.. include:: common/opt_L.rst
+.. include:: common/opt_s.rst
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_t.rst
+.. include:: common/opt_z-config.rst
+
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+EXAMPLES
+========
+
+::
+	perfquery                # read local port performance counters
+	perfquery 32 1           # read performance counters from lid 32, port 1
+	perfquery -x 32 1        # read extended performance counters from lid 32, port 1
+	perfquery -a 32          # read perf counters from lid 32, all ports
+	perfquery -r 32 1        # read performance counters and reset
+	perfquery -x -r 32 1     # read extended performance counters and reset
+	perfquery -R 0x20 1      # reset performance counters of port 1 only
+	perfquery -x -R 0x20 1   # reset extended performance counters of port 1 only
+	perfquery -R -a 32       # reset performance counters of all ports
+	perfquery -R 32 2 0x0fff # reset only error counters of port 2
+	perfquery -R 32 2 0xf000 # reset only non-error counters of port 2
+
+AUTHOR
+======
+
+Hal Rosenstock
+	< hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/doc/rst/sminfo.8.in.rst b/doc/rst/sminfo.8.in.rst
new file mode 100644
index 0000000..1d7e69f
--- /dev/null
+++ b/doc/rst/sminfo.8.in.rst
@@ -0,0 +1,101 @@
+======
+SMINFO
+======
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+---------------------------------
+query InfiniBand SMInfo attribute
+---------------------------------
+
+SYNOPSIS
+========
+
+sminfo [options] sm_lid | sm_dr_path [modifier]
+
+DESCRIPTION
+===========
+
+Optionally set and display the output of a sminfo query in human readable
+format. The target SM is the one listed in the local port info, or the SM
+specified by the optional SM lid or by the SM direct routed path.
+
+Note: using sminfo for any purposes other then simple query may be very
+dangerous, and may result in a malfunction of the target SM.
+
+OPTIONS
+=======
+
+**-s, --state <state>** set SM state
+        0 not active
+
+        1 discovering
+
+        2 standby
+
+        3 master
+
+**-p, --priority <priority>** set priority (0-15)
+
+**-a, --activity <val>** set activity count
+
+Addressing Flags
+----------------
+
+.. include:: common/opt_D.rst
+.. include:: common/opt_G.rst
+.. include:: common/opt_L.rst
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_t.rst
+.. include:: common/opt_z-config.rst
+
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+
+EXAMPLES
+========
+
+::
+        sminfo                  # local port\'s sminfo
+        sminfo 32               # show sminfo of lid 32
+        sminfo  -G 0x8f1040023  # same but using guid address
+
+
+SEE ALSO
+========
+
+smpdump (8)
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/smpdump.8.in.rst b/doc/rst/smpdump.8.in.rst
new file mode 100644
index 0000000..38460de
--- /dev/null
+++ b/doc/rst/smpdump.8.in.rst
@@ -0,0 +1,104 @@
+=======
+SMPDUMP
+=======
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+--------------------------------------------
+dump InfiniBand subnet management attributes
+--------------------------------------------
+
+
+SYNOPSIS
+========
+
+smpdump [options] <dlid|dr_path> <attribute> [attribute_modifier]
+
+DESCRIPTION
+===========
+
+smpdump is a general purpose SMP utility which gets SM attributes from a
+specified SMA. The result is dumped in hex by default.
+
+OPTIONS
+=======
+
+**dlid|drpath**
+        LID or DR path to SMA
+
+**attribute**
+        IBA attribute ID for SM attribute
+
+**attribute_modifier**
+        IBA modifier for SM attribute
+
+**-s, --string**
+        Print strings in packet if possible
+
+
+Addressing Flags
+----------------
+
+.. include:: common/opt_D.rst
+.. include:: common/opt_L.rst
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_t.rst
+.. include:: common/opt_z-config.rst
+
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+
+EXAMPLES
+========
+
+Direct Routed Examples
+
+::
+        smpdump -D 0,1,2,3,5 16 # NODE DESC
+        smpdump -D 0,1,2 0x15 2 # PORT INFO, port 2
+
+LID Routed Examples
+
+::
+        smpdump 3 0x15 2        # PORT INFO, lid 3 port 2
+        smpdump 0xa0 0x11       # NODE INFO, lid 0xa0
+
+SEE ALSO
+========
+
+smpquery (8)
+
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/smpquery.8.in.rst b/doc/rst/smpquery.8.in.rst
new file mode 100644
index 0000000..3b249df
--- /dev/null
+++ b/doc/rst/smpquery.8.in.rst
@@ -0,0 +1,112 @@
+========
+SMPQUERY
+========
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+---------------------------------------------
+query InfiniBand subnet management attributes
+---------------------------------------------
+
+
+SYNOPSIS
+========
+
+smpquery [options] <op> <dest dr_path|lid|guid> [op params]
+
+DESCRIPTION
+===========
+
+smpquery allows a basic subset of standard SMP queries including the following:
+node info, node description, switch info, port info. Fields are displayed in
+human readable format.
+
+OPTIONS
+=======
+
+Current supported operations and their parameters:
+
+::
+        nodeinfo <addr>
+        nodedesc <addr>
+        portinfo <addr> [<portnum>]     # default port is zero
+        switchinfo <addr>
+        pkeys <addr> [<portnum>]
+        sl2vl <addr> [<portnum>]
+        vlarb <addr> [<portnum>]
+        guids <addr>
+        mlnxextportinfo <addr> [<portnum>]  # default port is zero
+
+**-c, --combined**
+        Use Combined route address argument ``<lid> <DR_Path>``
+
+**-x, --extended**
+        Set SMSupportsExtendedSpeeds bit 31 in AttributeModifier
+        (only impacts PortInfo queries).
+
+
+Addressing Flags
+----------------
+
+.. include:: common/opt_D.rst
+.. include:: common/opt_G.rst
+.. include:: common/opt_L.rst
+.. include:: common/opt_s.rst
+
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_t.rst
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_z-config.rst
+
+
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+.. include:: common/sec_node-name-map.rst
+
+
+EXAMPLES
+========
+
+::
+        smpquery portinfo 3 1                     # portinfo by lid, with port modifier
+        smpquery -G switchinfo 0x2C9000100D051 1  # switchinfo by guid
+        smpquery -D nodeinfo 0                    # nodeinfo by direct route
+        smpquery -c nodeinfo 6 0,12               # nodeinfo by combined route
+
+SEE ALSO
+========
+
+smpdump (8)
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
diff --git a/man/perfquery.8 b/man/perfquery.8
deleted file mode 100644
index 8635e41..0000000
--- a/man/perfquery.8
+++ /dev/null
@@ -1,189 +0,0 @@
-.TH PERFQUERY 8 "February 19, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-perfquery \- query InfiniBand port counters
-
-.SH SYNOPSIS
-.B perfquery
-[\-d(ebug)] [\-G(uid)] [\-x|\-\-extended] [\-X|\-\-xmtsl] [\-S|\-\-rcvsl]
-[\-D|\-\-xmtdisc] [\-E|\-\-rcverr] [\-T|\-\-extended_speeds][\-\-oprcvcounters] [\-\-flowctlcounters]
-[\-\-vloppackets] [\-\-vlopdata] [\-\-vlxmitflowctlerrors] [\-\-vlxmitcounters]
-[\-\-swportvlcong] [\-\-rcvcc] [\-\-slrcvfecn] [\-\-slrcvbecn] [\-\-xmitcc]
-[\-\-vlxmittimecc] [\-c|\-\-smplctl] [-a(ll_ports)] [-l(oop_ports)]
-[-r(eset_after_read)] [-R(eset_only)] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-h(elp)] [<lid|guid> [[port] [reset_mask]]]
-
-.SH DESCRIPTION
-.PP
-perfquery uses PerfMgt GMPs to obtain the PortCounters (basic performance
-and error counters), PortExtendedCounters, PortXmitDataSL, PortRcvDataSL,
-PortRcvErrorDetails, PortXmitDiscardDetails, PortExtendedSpeedsCounters, or PortSamplesControl
-from the PMA at the node/port specified. Optionally shows aggregated
-counters for all ports of node.
-Also, optionally, reset after read, or only reset counters.
-
-Note: In PortCounters, PortCountersExtended, PortXmitDataSL, and PortRcvDataSL,
-components that represent Data (e.g. PortXmitData and PortRcvData) indicate
-octets divided by 4 rather than just octets.
-
-Note: Inputting a port of 255 indicates an operation be performed on all ports.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-x\fR, \fB\-\-extended\fR
-show extended port counters rather than (basic) port counters.
-Note that extended port counters attribute is optional.
-.TP
-\fB\-X\fR, \fB\-\-xmtsl\fR
-show transmit data SL counter. This is an optional counter for QoS.
-.TP
-\fB\-S\fR, \fB\-\-rcvsl\fR
-show receive data SL counter. This is an optional counter for QoS.
-.TP
-\fB\-D\fR, \fB\-\-xmtdisc\fR
-show transmit discard details. This is an optional counter.
-.TP
-\fB\-E\fR, \fB\-\-rcverr\fR
-show receive error details. This is an optional counter.
-.TP
-\fB\-D\fR, \fB\-\-xmtdisc\fR
-show transmit discard details. This is an optional counter.
-.TP
-\fB\-T\fR, \fB\-\-extended_speeds\fR
-show extended speeds port counters. This is an optional counter.
-.TP
-\fB\-\-oprcvcounters\fR
-show Rcv Counters per Op code. This is an optional counter.
-.TP
-\fB\-\-flowctlcounters\fR
-show flow control counters. This is an optional counter.
-.TP
-\fB\-\-vloppackets\fR
-show packets received per Op code per VL. This is an optional counter.
-.TP
-\fB\-\-vlopdata\fR
-show data received per Op code per VL. This is an optional counter.
-.TP
-\fB\-\-vlxmitflowctlerrors\fR
-show flow control update errors per VL. This is an optional counter.
-.TP
-\fB\-\-vlxmitcounters\fR
-show ticks waiting to transmit counters per VL. This is an optional counter.
-.TP
-\fB\-\-swportvlcong\fR
-show sw port VL congestion. This is an optional counter.
-.TP
-\fB\-\-rcvcc\fR
-show Rcv congestion control counters. This is an optional counter.
-.TP
-\fB\-\-slrcvfecn\fR
-show SL Rcv FECN counters. This is an optional counter.
-.TP
-\fB\-\-slrcvbecn\fR
-show SL Rcv BECN counters. This is an optional counter.
-.TP
-\fB\-\-xmitcc\fR
-show Xmit congestion control counters. This is an optional counter.
-.TP
-\fB\-\-vlxmittimecc\fR
-show VL Xmit Time congestion control counters. This is an optional counter.
-.TP
-\fB\-c\fR, \fB\-\-smplctl\fR
-show port samples control.
-.TP
-\fB\-a\fR, \fB\-\-all_ports\fR
-show aggregated counters for all ports of the destination lid
-or reset all counters for all ports.  If the destination lid
-does not support the AllPortSelect flag, all ports will be
-iterated through to emulate AllPortSelect behavior.
-.TP
-\fB\-l\fR, \fB\-\-loop_ports\fR
-If all ports are selected by the user (either through the
-\fB\-a\fR option or port 255) iterate through each port
-rather than doing than aggregate operation.
-.TP
-\fB\-r\fR, \fB\-\-reset_after_read\fR
-reset counters after read
-.TP
-\fB\-R\fR, \fB\-\-Reset_only\fR
-only reset counters
-
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
-.SH EXAMPLES
-
-.PP
-perfquery               # read local port performance counters
-.PP
-perfquery 32 1          # read performance counters from lid 32, port 1
-.PP
-perfquery -x 32 1       # read extended performance counters from lid 32, port 1
-.PP
-perfquery -a 32         # read perf counters from lid 32, all ports
-.PP
-perfquery -r 32 1       # read performance counters and reset
-.PP
-perfquery -x -r 32 1    # read extended performance counters and reset
-.PP
-perfquery -R 0x20 1     # reset performance counters of port 1 only
-.PP
-perfquery -x -R 0x20 1  # reset extended performance counters of port 1 only
-.PP
-perfquery -R -a 32      # reset performance counters of all ports
-.PP
-perfquery -R 32 2 0x0fff # reset only error counters of port 2
-.PP
-perfquery -R 32 2 0xf000 # reset only non-error counters of port 2
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/man/sminfo.8 b/man/sminfo.8
deleted file mode 100644
index 49b7461..0000000
--- a/man/sminfo.8
+++ /dev/null
@@ -1,107 +0,0 @@
-.TH SMINFO 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-sminfo \- query InfiniBand SMInfo attribute
-
-.SH SYNOPSIS
-.B sminfo
-[\-d(ebug)] [\-e(rr_show)] -s state -p prio -a activity [\-D(irect)]
-[\-G(uid)]  [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-h(elp)] sm_lid | sm_dr_path [modifier]
-
-.SH DESCRIPTION
-.PP
-Optionally set and display the output of a sminfo query in human readable
-format. The target SM is the one listed in the local port info, or the SM
-specified by the optional SM lid or by the SM direct routed path.
-.PP
-Note: using sminfo for any purposes other then simple query may be very
-dangerous, and may result in a malfunction of the target SM.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-s\fR
-set SM state
- 0 - not active
- 1 - discovering
- 2 - standby
- 3 - master
-.TP
-\fB\-p\fR
-set priority (0-15)
-.TP
-\fB\-a\fR
-set activity count
-
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
-.SH EXAMPLES
-
-.PP
-sminfo                  # local port\'s sminfo
-.PP
-sminfo 32               # show sminfo of lid 32
-.PP
-sminfo  -G 0x8f1040023  # same but using guid address
-
-.SH SEE ALSO
-.BR smpdump (8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/smpdump.8 b/man/smpdump.8
deleted file mode 100644
index e8a5bfa..0000000
--- a/man/smpdump.8
+++ /dev/null
@@ -1,99 +0,0 @@
-.TH SMPDUMP 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-smpdump \- dump InfiniBand subnet management attributes
-
-.SH SYNOPSIS
-.B smpdump
-[\-s(ring)] [\-D(irect)] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-h(elp)] <dlid|dr_path> <attr> [mod]
-
-.SH DESCRIPTION
-.PP
-smpdump is a general purpose SMP utility which gets SM attributes from a
-specified SMA. The result is dumped in hex by default.
-
-.SH OPTIONS
-
-.TP
-attr
-IBA attribute ID for SM attribute
-.TP
-mod
-IBA modifier for SM attribute
-
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
-.SH EXAMPLES
-
-Direct Routed Examples
-.PP
-smpdump -D 0,1,2,3,5 16 # NODE DESC
-.PP
-smpdump -D 0,1,2 0x15 2 # PORT INFO, port 2
-
-LID Routed Examples
-.PP
-smpdump 3 0x15 2        # PORT INFO, lid 3 port 2
-.PP
-smpdump 0xa0 0x11       # NODE INFO, lid 0xa0
-
-.SH SEE ALSO
-.BR smpquery (8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/smpquery.8 b/man/smpquery.8
deleted file mode 100644
index c4cb8f2..0000000
--- a/man/smpquery.8
+++ /dev/null
@@ -1,122 +0,0 @@
-.TH SMPQUERY 8 "March 9, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-smpquery \- query InfiniBand subnet management attributes
-
-.SH SYNOPSIS
-.B smpquery
-[\-d(ebug)] [\-e(rr_show)] [\-v(erbose)] [\-D(irect)] [\-G(uid)]
-[\-x|\-\-extended] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-\-node-name-map node-name-map] [\-V(ersion)] [\-h(elp)]
-<op> <dest dr_path|lid|guid> [op params]
-
-.SH DESCRIPTION
-.PP
-smpquery allows a basic subset of standard SMP queries including the following:
-node info, node description, switch info, port info. Fields are displayed in
-human readable format.
-
-.SH OPTIONS
-
-.PP
-.TP
-Current supported operations and their parameters:
-        nodeinfo <addr>
-        nodedesc <addr>
-        portinfo <addr> [<portnum>]     # default port is zero
-        switchinfo <addr>
-        pkeys <addr> [<portnum>]
-        sl2vl <addr> [<portnum>]
-        vlarb <addr> [<portnum>]
-        guids <addr>
-        mlnxextportinfo <addr> [<portnum>]  # default port is zero
-
-.TP
-\fB\-x\fR, \fB\-\-extended\fR
-Set SMSupportsExtendedSpeeds bit 31 in AttributeModifier
-(only impacts PortInfo queries).
-
-.TP
-\fB\-\-node\-name\-map\fR <node-name-map>
-Specify a node name map.  The node name map file maps GUIDs to more
-user friendly names.  See
-.B ibnetdiscover(8)
-for node name map file format.
-
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-d      raise the IB debugging level.
-        May be used several times (-ddd or -d -d -d).
-.PP
-\-e      show send and receive errors (timeouts and others)
-.PP
-\-h      show the usage message
-.PP
-\-v      increase the application verbosity level.
-        May be used several times (-vv or -v -v -v)
-.PP
-\-V      show the version info.
-
-# Addressing flags
-.PP
-\-D      use directed path address arguments. The path
-        is a comma separated list of out ports.
-        Examples:
-        "0"             # self port
-        "0,1,2,1,4"     # out via port 1, then 2, ...
-.PP
-\-c      use combined route address arguments. The
-        address is a combination of a LID and a direct route path.
-        The LID specified is the DLID and the local LID is used
-        as the DrSLID.
-.PP
-\-G      use GUID address argument. In most cases, it is the Port GUID.
-        Example:
-        "0x08f1040023"
-.PP
-\-s <smlid>      use 'smlid' as the target lid for SM/SA queries.
-
-# Other common flags:
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-Multiple CA/Multiple Port Support
-
-When no IB device or port is specified, the port to use is selected
-by the following criteria:
-.PP
-1. the first port that is ACTIVE.
-.PP
-2. if not found, the first port that is UP (physical link up).
-
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
-.SH EXAMPLES
-
-.PP
-smpquery portinfo 3 1        # portinfo by lid, with port modifier
-.PP
-smpquery -G switchinfo 0x2C9000100D051 1        # switchinfo by guid
-.PP
-smpquery -D nodeinfo 0       # nodeinfo by direct route
-.PP
-smpquery -c nodeinfo 6 0,12  # nodeinfo by combined route
-
-.SH SEE ALSO
-.BR smpdump (8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org >
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
