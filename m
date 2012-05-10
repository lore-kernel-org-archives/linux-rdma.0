From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 7/8] infiniband-diags: move
 man/saquery,vendstat,ibsysstat,ibfindnodesusing to rst documentation
Date: Wed, 9 May 2012 18:45:13 -0700
Message-ID: <20120509184513.6f72c911.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                       |    9 +-
 configure.in                      |    4 +
 doc/rst/ibfindnodesusing.8.in.rst |   54 ++++++++++
 doc/rst/ibsysstat.8.in.rst        |   87 ++++++++++++++++
 doc/rst/saquery.8.in.rst          |  202 +++++++++++++++++++++++++++++++++++++
 doc/rst/vendstat.8.in.rst         |  120 ++++++++++++++++++++++
 man/ibfindnodesusing.8            |   31 ------
 man/ibsysstat.8                   |   85 ----------------
 man/saquery.8                     |  145 --------------------------
 man/vendstat.8                    |  113 ---------------------
 10 files changed, 472 insertions(+), 378 deletions(-)
 create mode 100644 doc/rst/ibfindnodesusing.8.in.rst
 create mode 100644 doc/rst/ibsysstat.8.in.rst
 create mode 100644 doc/rst/saquery.8.in.rst
 create mode 100644 doc/rst/vendstat.8.in.rst
 delete mode 100644 man/ibfindnodesusing.8
 delete mode 100644 man/ibsysstat.8
 delete mode 100644 man/saquery.8
 delete mode 100644 man/vendstat.8

diff --git a/Makefile.am b/Makefile.am
index 3aa47bf..807754b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,10 +40,7 @@ sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
 		scripts/set_nodedesc.sh scripts/ibclearerrors scripts/ibclearcounters
 endif
 
-man_MANS = man/saquery.8 man/vendstat.8 \
-		man/ibsysstat.8 \
-		man/ibfindnodesusing.8 \
-		man/check_lft_balance.8 man/ibcacheedit.8 \
+man_MANS = man/check_lft_balance.8 man/ibcacheedit.8 \
 		man/ibstatus.8 \
 		doc/man/ibaddr.8 \
 		doc/man/ibccconfig.8 \
@@ -51,6 +48,7 @@ man_MANS = man/saquery.8 man/vendstat.8 \
 		doc/man/dump_lfts.8 \
 		doc/man/dump_mfts.8 \
 		doc/man/iblinkinfo.8 \
+		doc/man/ibfindnodesusing.8 \
 		doc/man/ibhosts.8 \
 		doc/man/ibnetdiscover.8 \
 		doc/man/ibnodes.8 \
@@ -61,11 +59,14 @@ man_MANS = man/saquery.8 man/vendstat.8 \
 		doc/man/ibrouters.8 \
 		doc/man/ibstat.8 \
 		doc/man/ibswitches.8 \
+		doc/man/ibsysstat.8 \
 		doc/man/ibtracert.8 \
 		doc/man/perfquery.8 \
+		doc/man/saquery.8 \
 		doc/man/sminfo.8 \
 		doc/man/smpdump.8 \
 		doc/man/smpquery.8 \
+		doc/man/vendstat.8 \
 		doc/man/infiniband-diags.8 \
 		man/ibidsverify.8
 
diff --git a/configure.in b/configure.in
index 66b7fef..20bb25c 100644
--- a/configure.in
+++ b/configure.in
@@ -213,6 +213,7 @@ AC_CONFIG_FILES([\
 	doc/man/dump_mfts.8 \
 	doc/man/ibhosts.8 \
 	doc/man/iblinkinfo.8 \
+	doc/man/ibfindnodesusing.8 \
 	doc/man/ibnetdiscover.8 \
 	doc/man/ibnodes.8 \
 	doc/man/ibping.8 \
@@ -222,11 +223,14 @@ AC_CONFIG_FILES([\
 	doc/man/ibrouters.8 \
 	doc/man/ibstat.8 \
 	doc/man/ibswitches.8 \
+	doc/man/ibsysstat.8 \
 	doc/man/ibtracert.8 \
 	doc/man/perfquery.8 \
+	doc/man/saquery.8 \
 	doc/man/sminfo.8 \
 	doc/man/smpdump.8 \
 	doc/man/smpquery.8 \
+	doc/man/vendstat.8 \
 	doc/man/infiniband-diags.8 \
 	libibnetdisc/Makefile \
 ])
diff --git a/doc/rst/ibfindnodesusing.8.in.rst b/doc/rst/ibfindnodesusing.8.in.rst
new file mode 100644
index 0000000..6d19c36
--- /dev/null
+++ b/doc/rst/ibfindnodesusing.8.in.rst
@@ -0,0 +1,54 @@
+================
+IBFINDNODESUSING
+================
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+-------------------------------------------------------------------------------
+find a list of end nodes which are routed through the specified switch and port
+-------------------------------------------------------------------------------
+
+
+SYNOPSIS
+========
+
+ibfindnodesusing.pl [options] <switch_guid|switch_name> <port>
+
+DESCRIPTION
+===========
+
+ibfindnodesusing.pl uses ibroute and detects the current nodes which are routed
+through both directions of the link specified.  The link is specified by one
+switch port end; the script finds the remote end automatically.
+
+
+OPTIONS
+=======
+
+**-h**
+        show help
+
+**-R**
+        Recalculate the ibnetdiscover information, ie do not use the cached
+        information.  This option is slower but should be used if the diag
+        tools have not been used for some time or if there are other reasons to
+        believe that the fabric has changed.
+
+**-C <ca_name>**    use the specified ca_name.
+
+**-P <ca_port>**    use the specified ca_port.
+
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+
+AUTHOR
+======
+
+Ira Weiny
+        < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/doc/rst/ibsysstat.8.in.rst b/doc/rst/ibsysstat.8.in.rst
new file mode 100644
index 0000000..5451f39
--- /dev/null
+++ b/doc/rst/ibsysstat.8.in.rst
@@ -0,0 +1,87 @@
+=========
+IBSYSSTAT
+=========
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+--------------------------------------
+system status on an InfiniBand address
+--------------------------------------
+
+
+SYNOPSIS
+========
+
+ibsysstat [options] <dest lid | guid> [<op>]
+
+DESCRIPTION
+===========
+
+ibsysstat uses vendor mads to validate connectivity between IB nodes
+and obtain other information about the IB node. ibsysstat is run as
+client/server. Default is to run as client.
+
+OPTIONS
+=======
+
+Current supported operations:
+
+::
+        ping \- verify connectivity to server (default)
+        host \- obtain host information from server
+        cpu  \- obtain cpu information from server
+
+**-o, --oui**
+        use specified OUI number to multiplex vendor mads
+
+**-S, --Server**
+        start in server mode (do not return)
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
+
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
new file mode 100644
index 0000000..36696c7
--- /dev/null
+++ b/doc/rst/saquery.8.in.rst
@@ -0,0 +1,202 @@
+=======
+SAQUERY
+=======
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+-------------------------------------------------
+query InfiniBand subnet administration attributes
+-------------------------------------------------
+
+
+SYNOPSIS
+========
+
+saquery [options] [<name> | <lid> | <guid>]
+
+DESCRIPTION
+===========
+
+saquery issues the selected SA query. Node records are queried by default.
+
+OPTIONS
+=======
+
+**-p**
+        get PathRecord info
+
+**-N**
+        get NodeRecord info
+
+**-D, --list**
+        get NodeDescriptions of CAs only
+
+**-S**
+        get ServiceRecord info
+
+**-I**
+        get InformInfoRecord (subscription) info
+
+**-L**
+        return the Lids of the name specified
+
+**-l**
+        return the unique Lid of the name specified
+
+**-G**
+        return the Guids of the name specified
+
+**-O**
+        return the name for the Lid specified
+
+**-U**
+        return the name for the Guid specified
+
+**-c**
+        get the SA's class port info
+
+**-s**
+        return the PortInfoRecords with isSM or isSMdisabled capability mask bit on
+
+**-g**
+        get multicast group info
+
+**-m**
+        get multicast member info.  If a group is specified, limit the output
+        to the group specified and print one line containing only the GUID and
+        node description for each entry. Example: saquery -m 0xc000
+
+**-x**
+        get LinkRecord info
+
+**--src-to-dst <src:dst>**
+        get a PathRecord for <src:dst>
+        where src and dst are either node names or LIDs
+
+**--sgid-to-dgid <sgid:dgid>**
+        get a PathRecord for **sgid** to **dgid**
+        where both GIDs are in an IPv6 format acceptable to **inet_pton (3)**
+
+**--smkey <val>**
+        use SM_Key value for the query. Will be used only with "trusted"
+        queries.  If non-numeric value (like 'x') is specified then saquery
+        will prompt for a value.
+
+**--slid <lid>** Source LID (PathRecord)
+
+**--dlid <lid>** Destination LID (PathRecord)
+
+**--mlid <lid>** Multicast LID (MCMemberRecord)
+
+**--sgid <gid>** Source GID (IPv6 format) (PathRecord)
+
+**--dgid <gid>** Destination GID (IPv6 format) (PathRecord)
+
+**--gid <gid>** Port GID (MCMemberRecord)
+
+**--mgid <gid>** Multicast GID (MCMemberRecord)
+
+**--reversible** Reversible path (PathRecord)
+
+**--numb_path** Number of paths (PathRecord)
+
+**--pkey** P_Key (PathRecord, MCMemberRecord). If non-numeric value (like 'x')
+        is specified then saquery will prompt for a value
+
+**--qos_class** QoS Class (PathRecord)
+
+**--sl** Service level (PathRecord, MCMemberRecord)
+
+**--mtu** MTU and selector (PathRecord, MCMemberRecord)
+
+**--rate** Rate and selector (PathRecord, MCMemberRecord)
+
+**--pkt_lifetime** Packet lifetime and selector (PathRecord, MCMemberRecord)
+
+**--qkey** Q_Key (MCMemberRecord). If non-numeric value (like 'x') is specified
+        then saquery will prompt for a value
+
+**--tclass** Traffic Class (PathRecord, MCMemberRecord)
+
+**--flow_label** Flow Label (PathRecord, MCMemberRecord)
+
+**--hop_limit** Hop limit (PathRecord, MCMemberRecord)
+
+**--scope** Scope (MCMemberRecord)
+
+**--join_state** Join state (MCMemberRecord)
+
+**--proxy_join** Proxy join (MCMemberRecord)
+
+Supported query names (and aliases):
+
+::
+        ClassPortInfo (CPI)
+        NodeRecord (NR) [lid]
+        PortInfoRecord (PIR) [[lid]/[port]/[options]]
+        SL2VLTableRecord (SL2VL) [[lid]/[in_port]/[out_port]]
+        PKeyTableRecord (PKTR) [[lid]/[port]/[block]]
+        VLArbitrationTableRecord (VLAR) [[lid]/[port]/[block]]
+        InformInfoRecord (IIR)
+        LinkRecord (LR) [[from_lid]/[from_port]] [[to_lid]/[to_port]]
+        ServiceRecord (SR)
+        PathRecord (PR)
+        MCMemberRecord (MCMR)
+        LFTRecord (LFTR) [[lid]/[block]]
+        MFTRecord (MFTR) [[mlid]/[position]/[block]]
+        GUIDInfoRecord (GIR) [[lid]/[block]]
+
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
+.. include:: common/opt_o-outstanding_smps.rst
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_z-config.rst
+
+
+
+COMMON FILES
+============
+
+.. include:: common/sec_config-file.rst
+
+.. include:: common/sec_node-name-map.rst
+
+
+
+DEPENDENCIES
+============
+
+OpenSM (or other running SM/SA), libosmcomp, libibumad, libibmad
+
+AUTHORS
+=======
+
+Ira Weiny
+        < weiny2-i2BcT+NCU+M@public.gmane.org >
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/vendstat.8.in.rst b/doc/rst/vendstat.8.in.rst
new file mode 100644
index 0000000..abb4e33
--- /dev/null
+++ b/doc/rst/vendstat.8.in.rst
@@ -0,0 +1,120 @@
+========
+VENDSTAT
+========
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+------------------------------------------
+query InfiniBand vendor specific functions
+------------------------------------------
+
+
+SYNOPSIS
+========
+
+vendstat [options] <lid|guid>
+
+DESCRIPTION
+===========
+
+vendstat uses vendor specific MADs to access beyond the IB spec
+vendor specific functionality. Currently, there is support for
+Mellanox InfiniSwitch-III (IS3) and InfiniSwitch-IV (IS4).
+
+OPTIONS
+=======
+
+**-N**
+	show IS3 or IS4 general information.
+
+**-w**
+	show IS3 port xmit wait counters.
+
+**-i**
+	show IS4 counter group info.
+
+**-c <num,num>**
+	configure IS4 counter groups.
+
+	Configure IS4 counter groups 0 and 1. Such configuration is not
+	persistent across IS4 reboot.  First number is for counter group 0 and
+	second is for counter group 1.
+
+	Group 0 counter config values:
+
+::
+		0 - PortXmitDataSL0-7
+		1 - PortXmitDataSL8-15
+		2 - PortRcvDataSL0-7
+
+	Group 1 counter config values:
+
+::
+		1 - PortXmitDataSL8-15
+		2 - PortRcvDataSL0-7
+		8 - PortRcvDataSL8-15
+
+**-R, --Read <addr,mask>**
+	Read configuration space record at addr
+
+**-W, --Write <addr,val,mask>**
+	Write configuration space record at addr
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
+	vendstat -N 6		# read IS3 or IS4 general information
+	vendstat -w 6		# read IS3 port xmit wait counters
+	vendstat -i 6 12	# read IS4 port 12 counter group info
+	vendstat -c 0,1 6 12	# configure IS4 port 12 counter groups for PortXmitDataSL
+	vendstat -c 2,8 6 12	# configure IS4 port 12 counter groups for PortRcvDataSL
+
+AUTHOR
+======
+
+Hal Rosenstock
+	< hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/man/ibfindnodesusing.8 b/man/ibfindnodesusing.8
deleted file mode 100644
index e19d90a..0000000
--- a/man/ibfindnodesusing.8
+++ /dev/null
@@ -1,31 +0,0 @@
-.TH IBFINDNODESUSING 8 "May 22, 2007" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibfindnodesusing.pl \- find a list of end nodes which are routed through
-the specified switch and port
-
-.SH SYNOPSIS
-.B ibfindnodesusing.pl
-[-R] <switch_guid|switch_name> <port>
-
-.SH DESCRIPTION
-.PP
-ibfindnodesusing.pl uses ibroute and detects the current nodes which are routed
-through both directions of the link specified.  The link is specified by one
-switch port end; the script finds the remote end automatically.
-
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-R\fR
-Recalculate the ibnetdiscover information, ie do not use the cached
-information.  This option is slower but should be used if the diag tools have
-not been used for some time or if there are other reasons to believe that
-the fabric has changed.
-
-.SH AUTHOR
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibsysstat.8 b/man/ibsysstat.8
deleted file mode 100644
index 69c5f83..0000000
--- a/man/ibsysstat.8
+++ /dev/null
@@ -1,85 +0,0 @@
-.TH IBSYSSTAT 8 "August 11, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibsysstat \- system status on an InfiniBand address
-
-.SH SYNOPSIS
-.B ibsysstat
-[\-d(ebug)] [\-e(rr_show)] [\-v(erbose)] [\-G(uid)]
-[\-C ca_name] [\-P ca_port] [\-s smlid] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-o oui] [\-S(erver)] [\-h(elp)] <dest lid | guid> [<op>]
-
-.SH DESCRIPTION
-.PP
-ibsysstat uses vendor mads to validate connectivity between IB nodes
-and obtain other information about the IB node. ibsysstat is run as
-client/server. Default is to run as client.
-
-.SH OPTIONS
-
-.PP
-.TP
-Current supported operations:
- ping \- verify connectivity to server (default)
- host \- obtain host information from server
- cpu  \- obtain cpu information from server
-.TP
-\fB\-o\fR, \fB\-\-oui\fR
-use specified OUI number to multiplex vendor mads
-.TP
-\fB\-S\fR, \fB\-\-Server\fR
-start in server mode (do not return)
-
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
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/saquery.8 b/man/saquery.8
deleted file mode 100644
index 6ae7425..0000000
--- a/man/saquery.8
+++ /dev/null
@@ -1,145 +0,0 @@
-.TH SAQUERY 8 "March 14, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-saquery \- query InfiniBand subnet administration attributes
-
-.SH SYNOPSIS
-.B saquery
-[\-h] [\-d] [\-p] [\-N] [\-\-list | \-D] [\-S] [\-I] [\-L] [\-l] [\-G] [\-O]
-[\-U] [\-c] [\-s] [\-g] [\-m] [\-x]
-[\-C ca_name] [\-P ca_port] [\-\-smkey val] [\-t(imeout) <msec>]
-[\-\-src\-to\-dst <src:dst>]
-[\-\-sgid\-to\-dgid <sgid\-dgid>]
-[\-\-node\-name\-map <node\-name\-map>]
-[<name> | <lid> | <guid>]
-
-.SH DESCRIPTION
-.PP
-saquery issues the selected SA query. Node records are queried by default.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-p\fR
-get PathRecord info
-.TP
-\fB\-N\fR
-get NodeRecord info
-.TP
-\fB\-\-list | \-D\fR
-get NodeDescriptions of CAs only
-.TP
-\fB\-S\fR
-get ServiceRecord info
-.TP
-\fB\-I\fR
-get InformInfoRecord (subscription) info
-.TP
-\fB\-L\fR
-return the Lids of the name specified
-.TP
-\fB\-l\fR
-return the unique Lid of the name specified
-.TP
-\fB\-G\fR
-return the Guids of the name specified
-.TP
-\fB\-O\fR
-return the name for the Lid specified
-.TP
-\fB\-U\fR
-return the name for the Guid specified
-.TP
-\fB\-c\fR
-get the SA's class port info
-.TP
-\fB\-s\fR
-return the PortInfoRecords with isSM or isSMdisabled capability mask bit on
-.TP
-\fB\-g\fR
-get multicast group info
-.TP
-\fB\-m\fR
-get multicast member info.  If a group is specified, limit the output to the
-group specified and print one line containing only the GUID and node
-description for each entry. Example: saquery -m 0xc000
-.TP
-\fB\-x\fR
-get LinkRecord info
-.TP
-\fB\-\-src-to-dst\fR
-get a PathRecord for <src:dst>
-where src and dst are either node names or LIDs
-.TP
-.B \-\-sgid\-to\-dgid
-get a PathRecord for
-.I sgid
-to
-.I dgid
-where both GIDs are in an IPv6 format acceptable to
-.BR inet_pton (3).
-.TP
-\fB\-C\fR <ca_name>
-use the specified ca_name.
-.TP
-\fB\-P\fR <ca_port>
-use the specified ca_port.
-.TP
-\fB\-\-smkey\fR <val>
-use SM_Key value for the query. Will be used only with "trusted" queries.
-If non-numeric value (like 'x') is specified then saquery will prompt for
-a value.
-.TP
-\fB\-t\fR, \fB\-timeout\fR <msec>
-Specify SA query response timeout in milliseconds.
-Default is 100 milliseconds. You may want to use
-this option if IB_TIMEOUT is indicated.
-.TP
-\fB\-\-node\-name\-map\fR <node-name-map>
-Specify a node name map.  The node name map file maps GUIDs to more
-user friendly names.  See
-.B ibnetdiscover(8)
-for node name map file format.  Only used with the \fB\-O\fR and \fB\-U\fR
-options.
-.TP
-Supported query names (and aliases):
- ClassPortInfo (CPI)
- NodeRecord (NR) [lid]
- PortInfoRecord (PIR) [[lid]/[port]/[options]]
- SL2VLTableRecord (SL2VL) [[lid]/[in_port]/[out_port]]
- PKeyTableRecord (PKTR) [[lid]/[port]/[block]]
- VLArbitrationTableRecord (VLAR) [[lid]/[port]/[block]]
- InformInfoRecord (IIR)
- LinkRecord (LR) [[from_lid]/[from_port]] [[to_lid]/[to_port]]
- ServiceRecord (SR)
- PathRecord (PR)
- MCMemberRecord (MCMR)
- LFTRecord (LFTR) [[lid]/[block]]
- MFTRecord (MFTR) [[mlid]/[position]/[block]]
- GUIDInfoRecord (GIR) [[lid]/[block]]
-.TP
-\fB\-d\fR
-enable debugging
-.TP
-\fB\-h\fR
-show help
-
-.SH FILES
-
-ib-node-name-map -- see ibnetdiscover for more information
-
-The node name map is used to specify user friendly names for nodes in the
-output.  Node GUIDs are used to perform the lookup.
-
-.SH DEPENDENCIES
-
-OpenSM (or other running SM/SA), libosmcomp, libibumad, libibmad
-
-.SH AUTHORS
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/vendstat.8 b/man/vendstat.8
deleted file mode 100644
index 2a87f2b..0000000
--- a/man/vendstat.8
+++ /dev/null
@@ -1,113 +0,0 @@
-.TH VENDSTAT 8 "February 10, 2010" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-vendstat \- query InfiniBand vendor specific functions
-
-.SH SYNOPSIS
-.B vendstat
-[\-d(ebug)] [\-G(uid)] [\-N] [\-w] [\-i] [\-c <num,num>]
-[\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-h(elp)] <lid|guid>
-
-.SH DESCRIPTION
-.PP
-vendstat uses vendor specific MADs to access beyond the IB spec
-vendor specific functionality. Currently, there is support for
-Mellanox InfiniSwitch-III (IS3) and InfiniSwitch-IV (IS4).
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-N\fR
-show IS3 or IS4 general information.
-.TP
-\fB\-w\fR
-show IS3 port xmit wait counters.
-.TP
-\fB\-i\fR
-show IS4 counter group info.
-.TP
-\fB\-c\fR <num,num>
-configure IS4 counter groups.
-
-Configure IS4 counter groups 0 and 1. Such configuration
-is not persistent across IS4 reboot.
-First number is for counter group 0 and second is for
-counter group 1.
-
-Group 0 counter config values:
- 0 - PortXmitDataSL0-7
- 1 - PortXmitDataSL8-15
- 2 - PortRcvDataSL0-7
-
-Group 1 counter config values:
- 1 - PortXmitDataSL8-15
- 2 - PortRcvDataSL0-7
- 8 - PortRcvDataSL8-15
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
-vendstat -N 6		# read IS3 or IS4 general information
-.PP
-vendstat -w 6		# read IS3 port xmit wait counters
-.PP
-vendstat -i 6 12	# read IS4 port 12 counter group info
-.PP
-vendstat -c 0,1 6 12	# configure IS4 port 12 counter groups for PortXmitDataSL
-.PP
-vendstat -c 2,8 6 12	# configure IS4 port 12 counter groups for PortRcvDataSL
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
