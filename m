From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 5/8] infiniband-diags: move
 man/ibportstate,ibstat,ibroute,ibtracert to rst documentation
Date: Wed, 9 May 2012 18:45:04 -0700
Message-ID: <20120509184504.bee06c6e.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                  |    7 ++-
 configure.in                 |    4 +
 doc/rst/ibportstate.8.in.rst |  116 ++++++++++++++++++++++++++++++++++++++
 doc/rst/ibroute.8.in.rst     |  108 +++++++++++++++++++++++++++++++++++
 doc/rst/ibstat.8.in.rst      |   83 +++++++++++++++++++++++++++
 doc/rst/ibtracert.8.in.rst   |  106 ++++++++++++++++++++++++++++++++++
 man/ibportstate.8            |  128 ------------------------------------------
 man/ibroute.8                |  122 ----------------------------------------
 man/ibstat.8                 |  111 ------------------------------------
 man/ibtracert.8              |  108 -----------------------------------
 10 files changed, 422 insertions(+), 471 deletions(-)
 create mode 100644 doc/rst/ibportstate.8.in.rst
 create mode 100644 doc/rst/ibroute.8.in.rst
 create mode 100644 doc/rst/ibstat.8.in.rst
 create mode 100644 doc/rst/ibtracert.8.in.rst
 delete mode 100644 man/ibportstate.8
 delete mode 100644 man/ibroute.8
 delete mode 100644 man/ibstat.8
 delete mode 100644 man/ibtracert.8

diff --git a/Makefile.am b/Makefile.am
index f7bfb57..16a8fd8 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,8 +40,7 @@ sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
 		scripts/set_nodedesc.sh scripts/ibclearerrors scripts/ibclearcounters
 endif
 
-man_MANS = man/ibportstate.8 man/ibroute.8 man/ibstat.8 \
-		man/ibtracert.8 man/perfquery.8 man/sminfo.8 \
+man_MANS = man/perfquery.8 man/sminfo.8 \
 		man/smpdump.8 man/smpquery.8 man/saquery.8 man/vendstat.8 \
 		man/ibsysstat.8 \
 		man/ibfindnodesusing.8 \
@@ -57,9 +56,13 @@ man_MANS = man/ibportstate.8 man/ibroute.8 man/ibstat.8 \
 		doc/man/ibnetdiscover.8 \
 		doc/man/ibnodes.8 \
 		doc/man/ibping.8 \
+		doc/man/ibportstate.8 \
 		doc/man/ibqueryerrors.8 \
+		doc/man/ibroute.8 \
 		doc/man/ibrouters.8 \
+		doc/man/ibstat.8 \
 		doc/man/ibswitches.8 \
+		doc/man/ibtracert.8 \
 		doc/man/infiniband-diags.8 \
 		man/ibidsverify.8
 
diff --git a/configure.in b/configure.in
index 7e49d1a..67d3031 100644
--- a/configure.in
+++ b/configure.in
@@ -216,9 +216,13 @@ AC_CONFIG_FILES([\
 	doc/man/ibnetdiscover.8 \
 	doc/man/ibnodes.8 \
 	doc/man/ibping.8 \
+	doc/man/ibportstate.8 \
 	doc/man/ibqueryerrors.8 \
+	doc/man/ibroute.8 \
 	doc/man/ibrouters.8 \
+	doc/man/ibstat.8 \
 	doc/man/ibswitches.8 \
+	doc/man/ibtracert.8 \
 	doc/man/infiniband-diags.8 \
 	libibnetdisc/Makefile \
 ])
diff --git a/doc/rst/ibportstate.8.in.rst b/doc/rst/ibportstate.8.in.rst
new file mode 100644
index 0000000..3af2aaa
--- /dev/null
+++ b/doc/rst/ibportstate.8.in.rst
@@ -0,0 +1,116 @@
+===========
+IBPORTSTATE
+===========
+
+-----------------------------------------------------------------
+handle port (physical) state and link speed of an InfiniBand port
+-----------------------------------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibportstate [options] <dest dr_path|lid|guid> <portnum> [<op>]
+
+DESCRIPTION
+===========
+
+ibportstate allows the port state and port physical state of an IB port
+to be queried (in addition to link width and speed being validated
+relative to the peer port when the port queried is a switch port),
+or a switch port to be disabled, enabled, or reset. It
+also allows the link speed/width enabled on any IB port to be adjusted.
+
+OPTIONS
+=======
+
+**<op>**
+        Supported ops: enable, disable, reset, speed, espeed, fdr10, width, query,
+                        down, arm, active, vls, mtu, lid, smlid, lmc (Default
+                        is query)
+
+        **enable, disable, and reset** are only allowed on switch ports (An
+        error is indicated if attempted on CA or router ports)
+
+        **speed and width** are allowed on any port
+
+        **speed** values are the legal values for PortInfo:LinkSpeedEnabled (An
+        error is indicated if PortInfo:LinkSpeedSupported does not support this
+        setting)
+
+        **espeed** is allowed on any port supporting extended link speeds
+
+        **fdr10** is allowed on any port supporting fdr10 (An error is
+        indicated if port's capability mask indicates extended link speeds are
+        not supported or if PortInfo:LinkSpeedExtSupported does not support
+        this setting)
+
+        **width** values are legal values for PortInfo:LinkWidthEnabled (An
+        error is indicated if PortInfo:LinkWidthSupported does not support this
+        setting) (NOTE: Speed and width changes are not effected until the port
+        goes through link renegotiation)
+
+        **query** also validates port characteristics (link width, speed,
+        espeed, and fdr10) based on the peer port. This checking is done when
+        the port queried is a switch port as it relies on combined routing (an
+        initial LID route with directed routing to the peer) which can only be
+        done on a switch. This peer port validation feature of query op
+        requires LID routing to be functioning in the subnet.
+
+
+Addressing Flags
+----------------
+
+.. include:: common/opt_L.rst
+.. include:: common/opt_G.rst
+.. include:: common/opt_D.rst
+.. include:: common/opt_s.rst
+
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+.. include:: common/opt_t.rst
+
+Debugging flags
+---------------
+
+.. include:: common/opt_h.rst
+.. include:: common/opt_d.rst
+.. include:: common/opt_e.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
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
+        ibportstate 3 1 disable                  # by lid
+        ibportstate -G 0x2C9000100D051 1 enable  # by guid
+        ibportstate -D 0 1                       # (query) by direct route
+        ibportstate 3 1 reset                    # by lid
+        ibportstate 3 1 speed 1                  # by lid
+        ibportstate 3 1 width 1                  # by lid
+        ibportstate -D 0 1 lid 0x1234 arm        # by direct route
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/doc/rst/ibroute.8.in.rst b/doc/rst/ibroute.8.in.rst
new file mode 100644
index 0000000..0070dd6
--- /dev/null
+++ b/doc/rst/ibroute.8.in.rst
@@ -0,0 +1,108 @@
+=======
+IBROUTE
+=======
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+-----------------------------------------
+query InfiniBand switch forwarding tables
+-----------------------------------------
+
+
+SYNOPSIS
+========
+
+ibroute [options] [<dest dr_path|lid|guid> [<startlid> [<endlid>]]]
+
+DESCRIPTION
+===========
+
+ibroute uses SMPs to display the forwarding tables (unicast
+(LinearForwardingTable or LFT) or multicast (MulticastForwardingTable or MFT))
+for the specified switch LID and the optional lid (mlid) range.
+The default range is all valid entries in the range 1...FDBTop.
+
+OPTIONS
+=======
+
+**-a, --all**
+        show all lids in range, even invalid entries
+
+**-n, --no_dests**
+        do not try to resolve destinations
+
+**-M, --Multicast**
+        show multicast forwarding tables
+        In this case, the range parameters are specifying the mlid range.
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
+Port Selection flags
+--------------------
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/sec_portselection.rst
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
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+
+EXAMPLES
+========
+
+Unicast examples
+
+::
+        ibroute 4               # dump all lids with valid out ports of switch with lid 4
+        ibroute -a 4            # same, but dump all lids, even with invalid out ports
+        ibroute -n 4            # simple dump format - no destination resolution
+        ibroute 4 10            # dump lids starting from 10 (up to FDBTop)
+        ibroute 4 0x10 0x20     # dump lid range
+        ibroute -G 0x08f1040023 # resolve switch by GUID
+        ibroute -D 0,1          # resolve switch by direct path
+
+Multicast examples
+
+::
+        ibroute -M 4                # dump all non empty mlids of switch with lid 4
+        ibroute -M 4 0xc010 0xc020  # same, but with range
+        ibroute -M -n 4             # simple dump format
+
+SEE ALSO
+========
+
+ibtracert (8)
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/ibstat.8.in.rst b/doc/rst/ibstat.8.in.rst
new file mode 100644
index 0000000..3e19b3e
--- /dev/null
+++ b/doc/rst/ibstat.8.in.rst
@@ -0,0 +1,83 @@
+======
+IBSTAT
+======
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+------------------------------------------
+query basic status of InfiniBand device(s)
+------------------------------------------
+
+
+SYNOPSIS
+========
+
+ibstat [options] <ca_name> [portnum]
+
+DESCRIPTION
+===========
+
+ibstat is a binary which displays basic information obtained from the local
+IB driver. Output includes LID, SMLID, port state, link width active, and port
+physical state.
+
+It is similar to the ibstatus utility but implemented as a binary rather
+than a script. It has options to list CAs and/or ports and displays more
+information than ibstatus.
+
+OPTIONS
+=======
+
+**-l, --list_of_cas**
+        list all IB devices
+
+**-s, --short**
+        short output
+
+**-p, --port_list**
+        show port list
+
+**ca_name**
+        InfiniBand device name
+
+**portnum**
+        port number of InfiniBand device
+
+
+
+Debugging flags
+---------------
+
+.. include:: common/opt_d.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_v.rst
+.. include:: common/opt_V.rst
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+
+
+
+EXAMPLES
+========
+
+::
+        ibstat            # display status of all ports on all IB devices
+        ibstat -l         # list all IB devices
+        ibstat -p         # show port guids
+        ibstat mthca0 2   # show status of port 2 of 'mthca0'
+
+SEE ALSO
+========
+ibstatus (8)
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/ibtracert.8.in.rst b/doc/rst/ibtracert.8.in.rst
new file mode 100644
index 0000000..b002fa8
--- /dev/null
+++ b/doc/rst/ibtracert.8.in.rst
@@ -0,0 +1,106 @@
+=========
+IBTRACERT
+=========
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+---------------------
+trace InfiniBand path
+---------------------
+
+SYNOPSIS
+========
+
+ibtracert [options] [<lid|guid> [<startlid> [<endlid>]]]
+
+
+DESCRIPTION
+===========
+
+ibtracert uses SMPs to trace the path from a source GID/LID to a
+destination GID/LID. Each hop along the path is displayed until
+the destination is reached or a hop does not respond. By using
+the -m option, multicast path tracing can be performed between source
+and destination nodes.
+
+OPTIONS
+=======
+
+**-n, --no_info**
+        simple format; don't show additional information
+
+**-m**
+        show the multicast trace of the specified mlid
+
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
+.. include:: common/opt_node_name_map.rst
+.. include:: common/opt_z-config.rst
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+
+
+EXAMPLES
+========
+
+Unicast examples
+
+::
+        ibtracert 4 16                                  # show path between lids 4 and 16
+        ibtracert -n 4 16                               # same, but using simple output format
+        ibtracert -G 0x8f1040396522d 0x002c9000100d051  # use guid addresses
+
+Multicast example
+
+::
+        ibtracert -m 0xc000 4 16    # show multicast path of mlid 0xc000 between lids 4 and 16
+
+SEE ALSO
+========
+ibroute (8)
+
+
+AUTHOR
+======
+
+Hal Rosenstock
+        <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+
+Ira Weiny
+        <weiny2-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibportstate.8 b/man/ibportstate.8
deleted file mode 100644
index 0537d7e..0000000
--- a/man/ibportstate.8
+++ /dev/null
@@ -1,128 +0,0 @@
-.TH IBPORTSTATE 8 "Mar 9, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibportstate \- handle port (physical) state and link speed of an InfiniBand port
-
-.SH SYNOPSIS
-.B ibportstate
-[\-d(ebug)] [\-e(rr_show)] [\-v(erbose)] [\-D(irect)] [\-G(uid)]
-[\-s smlid] [\-V(ersion)] [\-C ca_name] [\-P ca_port]
-[\-t(imeout) timeout_ms] [\-h(elp)] <dest dr_path|lid|guid> <portnum> [<op>]
-
-.SH DESCRIPTION
-.PP
-ibportstate allows the port state and port physical state of an IB port
-to be queried (in addition to link width and speed being validated
-relative to the peer port when the port queried is a switch port),
-or a switch port to be disabled, enabled, or reset. It
-also allows the link speed/width enabled on any IB port to be adjusted.
-
-.SH OPTIONS
-
-.PP
-.TP
-op
-Port operations allowed
- supported ops: enable, disable, reset, speed, espeed, fdr10, width, query,
-		down, arm, active, vls, mtu, lid, smlid, lmc
- Default is query
-.PP
- ops enable, disable, and reset are only allowed on switch ports
- (An error is indicated if attempted on CA or router ports)
- speed and width ops are allowed on any port
- speed values are legal values for PortInfo:LinkSpeedEnabled
- (An error is indicated if PortInfo:LinkSpeedSupported does not support
-  this setting)
- espeed ops are allowed on any port supporting extended link speeds
- fdr10 ops are allowed on any port supporting fdr10
-(An error is indicated if port's capability mask indicates extended
- link speeds are not supported or if PortInfo:LinkSpeedExtSupported
- does not support this setting)
- width values are legal values for PortInfo:LinkWidthEnabled
- (An error is indicated if PortInfo:LinkWidthSupported does not support
-  this setting)
- (NOTE: Speed and width changes are not effected until the port goes through
-  link renegotiation)
- query also validates port characteristics (link width, speed, espeed, and fdr10)
-  based on the peer port. This checking is done when the port
-  queried is a switch port as it relies on combined routing
-  (an initial LID route with directed routing to the peer) which
-  can only be done on a switch. This peer port validation feature
-  of query op requires LID routing to be functioning in the subnet.
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
-ibportstate 3 1 disable                 # by lid
-.PP
-ibportstate -G 0x2C9000100D051 1 enable # by guid
-.PP
-ibportstate -D 0 1                      # (query) by direct route
-.PP
-ibportstate 3 1 reset				# by lid
-.PP
-ibportstate 3 1 speed 1				# by lid
-.PP
-ibportstate 3 1 width 1				# by lid
-.PP
-ibportstate -D 0 1 lid 0x1234 arm		# by direct route
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org >
diff --git a/man/ibroute.8 b/man/ibroute.8
deleted file mode 100644
index 3e93408..0000000
--- a/man/ibroute.8
+++ /dev/null
@@ -1,122 +0,0 @@
-.TH IBROUTE 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibroute \- query InfiniBand switch forwarding tables
-
-.SH SYNOPSIS
-.B ibroute
-[\-d(ebug)] [-a(ll)] [-n(o_dests)] [-v(erbose)] [\-D(irect)] [\-G(uid)]
-[-M(ulticast)] [-s smlid] [\-C ca_name] [\-P ca_port]
-[\-t(imeout) timeout_ms] [\-V(ersion)] [\-h(elp)]
-[<dest dr_path|lid|guid> [<startlid> [<endlid>]]]
-
-.SH DESCRIPTION
-.PP
-ibroute uses SMPs to display the forwarding tables (unicast
-(LinearForwardingTable or LFT) or multicast (MulticastForwardingTable or MFT))
-for the specified switch LID and the optional lid (mlid) range.
-The default range is all valid entries in the range 1...FDBTop.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-a\fR, \fB\-\-all\fR
-show all lids in range, even invalid entries
-.TP
-\fB\-n\fR, \fB\-\-no_dests\fR
-do not try to resolve destinations
-.TP
-\fB\-M\fR, \fB\-\-Multicast\fR
-show multicast forwarding tables
-In this case, the range parameters are specifying the mlid range.
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
-Unicast examples
-.PP
-ibroute 4       # dump all lids with valid out ports of switch with lid 4
-.PP
-ibroute -a 4    # same, but dump all lids, even with invalid out ports
-.PP
-ibroute -n 4    # simple dump format - no destination resolution
-.PP
-ibroute 4 10    # dump lids starting from 10 (up to FDBTop)
-.PP
-ibroute 4 0x10 0x20     # dump lid range
-.PP
-ibroute -G 0x08f1040023 # resolve switch by GUID
-.PP
-ibroute -D 0,1  # resolve switch by direct path
-
-.PP
-Multicast examples
-.PP
-ibroute -M 4    # dump all non empty mlids of switch with lid 4
-.PP
-ibroute -M 4 0xc010 0xc020      # same, but with range
-.PP
-ibroute -M -n 4 # simple dump format
-
-.SH SEE ALSO
-.BR ibtracert (8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/ibstat.8 b/man/ibstat.8
deleted file mode 100644
index 7d69ff3..0000000
--- a/man/ibstat.8
+++ /dev/null
@@ -1,111 +0,0 @@
-.TH IBSTAT 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibstat \- query basic status of InfiniBand device(s)
-
-.SH SYNOPSIS
-.B ibstat
-[\-d(ebug)] [\-l(ist_of_cas)] [\-s(hort)] [\-p(ort_list)]
-[\-V(ersion)] [\-h] <ca_name> [portnum]
-
-.SH DESCRIPTION
-.PP
-ibstat is a binary which displays basic information obtained from the local
-IB driver. Output includes LID, SMLID, port state, link width active, and port
-physical state.
-
-It is similar to the ibstatus utility but implemented as a binary rather
-than a script. It has options to list CAs and/or ports and displays more
-information than ibstatus.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-l\fR, \fB\-\-list_of_cas\fR
-list all IB devices
-.TP
-\fB\-s\fR, \fB\-\-short\fR
-short output
-.TP
-\fB\-p\fR, \fB\-\-port_list\fR
-show port list
-.TP
-ca_name
-InfiniBand device name
-.TP
-portnum
-port number of InfiniBand device
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
-ibstat            # display status of all ports on all IB devices
-.PP
-ibstat -l         # list all IB devices
-.PP
-ibstat -p         # show port guids
-.PP
-ibstat mthca0 2   # show status of port 2 of 'mthca0'
-
-.SH SEE ALSO
-.BR ibstatus (8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/ibtracert.8 b/man/ibtracert.8
deleted file mode 100644
index 674db7e..0000000
--- a/man/ibtracert.8
+++ /dev/null
@@ -1,108 +0,0 @@
-.TH IBTRACERT 8 "September 14, 2010" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibtracert\- trace InfiniBand path
-
-.SH SYNOPSIS
-.B ibtracert
-[\-d(ebug)] [-v(erbose)] [\-G(uids)] [-n(o_info)] [-m mlid]
-[-s smlid] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-\-node\-name\-\-map <node-name-map>] [\-h(elp)]
-[<lid|guid> [<startlid> [<endlid>]]]
-
-.SH DESCRIPTION
-.PP
-ibtracert uses SMPs to trace the path from a source GID/LID to a
-destination GID/LID. Each hop along the path is displayed until
-the destination is reached or a hop does not respond. By using
-the -m option, multicast path tracing can be performed between source
-and destination nodes.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-n\fR, \fB\-\-no_info\fR
-simple format; don't show additional information
-.TP
-\fB\-m\fR
-show the multicast trace of the specified mlid
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
-Unicast examples
-.PP
-ibtracert 4 16              # show path between lids 4 and 16
-.PP
-ibtracert -n 4 16           # same, but using simple output format
-.PP
-ibtracert -G 0x8f1040396522d 0x002c9000100d051  # use guid addresses
-
-.PP
-Multicast example
-.PP
-ibtracert -m 0xc000 4 16    # show multicast path of mlid 0xc000 between lids 4 and 16
-
-.SH SEE ALSO
-.BR ibroute (8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
-.TP
-Ira Weiny
-.RI < weiny2-i2BcT+NCU+M@public.gmane.org >
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
