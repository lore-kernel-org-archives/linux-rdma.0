From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 4/8] infiniband-diags: move
 man/ibping,ibnodes,ibhosts,ibswitches,ibrouters to rst documentation
Date: Wed, 9 May 2012 18:45:00 -0700
Message-ID: <20120509184500.4a438cb5.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                 |   13 ++++--
 configure.in                |    5 ++
 doc/rst/ibhosts.8.in.rst    |   56 +++++++++++++++++++++++++++
 doc/rst/ibnodes.8.in.rst    |   58 ++++++++++++++++++++++++++++
 doc/rst/ibping.8.in.rst     |   86 ++++++++++++++++++++++++++++++++++++++++++
 doc/rst/ibrouters.8.in.rst  |   57 ++++++++++++++++++++++++++++
 doc/rst/ibswitches.8.in.rst |   55 +++++++++++++++++++++++++++
 man/ibhosts.8               |   35 -----------------
 man/ibnodes.8               |   35 -----------------
 man/ibping.8                |   87 -------------------------------------------
 man/ibrouters.8             |   31 ---------------
 man/ibswitches.8            |   35 -----------------
 12 files changed, 325 insertions(+), 228 deletions(-)
 create mode 100644 doc/rst/ibhosts.8.in.rst
 create mode 100644 doc/rst/ibnodes.8.in.rst
 create mode 100644 doc/rst/ibping.8.in.rst
 create mode 100644 doc/rst/ibrouters.8.in.rst
 create mode 100644 doc/rst/ibswitches.8.in.rst
 delete mode 100644 man/ibhosts.8
 delete mode 100644 man/ibnodes.8
 delete mode 100644 man/ibping.8
 delete mode 100644 man/ibrouters.8
 delete mode 100644 man/ibswitches.8

diff --git a/Makefile.am b/Makefile.am
index 21f5163..f7bfb57 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,14 +40,12 @@ sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
 		scripts/set_nodedesc.sh scripts/ibclearerrors scripts/ibclearcounters
 endif
 
-man_MANS = man/ibping.8 \
-		man/ibnodes.8 man/ibhosts.8 \
-		man/ibportstate.8 man/ibroute.8 man/ibstat.8 \
-		man/ibswitches.8 man/ibtracert.8 man/perfquery.8 man/sminfo.8 \
+man_MANS = man/ibportstate.8 man/ibroute.8 man/ibstat.8 \
+		man/ibtracert.8 man/perfquery.8 man/sminfo.8 \
 		man/smpdump.8 man/smpquery.8 man/saquery.8 man/vendstat.8 \
 		man/ibsysstat.8 \
 		man/ibfindnodesusing.8 \
-		man/ibrouters.8 man/check_lft_balance.8 man/ibcacheedit.8 \
+		man/check_lft_balance.8 man/ibcacheedit.8 \
 		man/ibstatus.8 \
 		doc/man/ibaddr.8 \
 		doc/man/ibccconfig.8 \
@@ -55,8 +53,13 @@ man_MANS = man/ibping.8 \
 		doc/man/dump_lfts.8 \
 		doc/man/dump_mfts.8 \
 		doc/man/iblinkinfo.8 \
+		doc/man/ibhosts.8 \
 		doc/man/ibnetdiscover.8 \
+		doc/man/ibnodes.8 \
+		doc/man/ibping.8 \
 		doc/man/ibqueryerrors.8 \
+		doc/man/ibrouters.8 \
+		doc/man/ibswitches.8 \
 		doc/man/infiniband-diags.8 \
 		man/ibidsverify.8
 
diff --git a/configure.in b/configure.in
index 0a456c1..7e49d1a 100644
--- a/configure.in
+++ b/configure.in
@@ -211,9 +211,14 @@ AC_CONFIG_FILES([\
 	doc/man/ibccquery.8 \
 	doc/man/dump_lfts.8 \
 	doc/man/dump_mfts.8 \
+	doc/man/ibhosts.8 \
 	doc/man/iblinkinfo.8 \
 	doc/man/ibnetdiscover.8 \
+	doc/man/ibnodes.8 \
+	doc/man/ibping.8 \
 	doc/man/ibqueryerrors.8 \
+	doc/man/ibrouters.8 \
+	doc/man/ibswitches.8 \
 	doc/man/infiniband-diags.8 \
 	libibnetdisc/Makefile \
 ])
diff --git a/doc/rst/ibhosts.8.in.rst b/doc/rst/ibhosts.8.in.rst
new file mode 100644
index 0000000..237b89e
--- /dev/null
+++ b/doc/rst/ibhosts.8.in.rst
@@ -0,0 +1,56 @@
+=======
+IBHOSTS
+=======
+
+--------------------------------------
+show InfiniBand host nodes in topology
+--------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+SYNOPSIS
+========
+
+ibhosts [options] [<topology-file>]
+
+
+DESCRIPTION
+===========
+
+ibhosts is a script which either walks the IB subnet topology or uses an
+already saved topology file and extracts the CA nodes.
+
+OPTIONS
+=======
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/opt_t.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_z-config.rst
+
+.. include:: common/sec_portselection.rst
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+
+SEE ALSO
+========
+
+ibnetdiscover(8)
+
+DEPENDENCIES
+============
+
+ibnetdiscover, ibnetdiscover format
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/ibnodes.8.in.rst b/doc/rst/ibnodes.8.in.rst
new file mode 100644
index 0000000..d36a03e
--- /dev/null
+++ b/doc/rst/ibnodes.8.in.rst
@@ -0,0 +1,58 @@
+=======
+IBNODES
+=======
+
+---------------------------------
+show InfiniBand nodes in topology
+---------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibnodes [options] [<topology-file>]
+
+DESCRIPTION
+===========
+
+ibnodes is a script which either walks the IB subnet topology or uses an
+already saved topology file and extracts the IB nodes (CAs and switches).
+
+
+OPTIONS
+=======
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/opt_t.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_z-config.rst
+
+.. include:: common/sec_portselection.rst
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+
+
+SEE ALSO
+========
+
+ibnetdiscover(8)
+
+DEPENDENCIES
+============
+
+ibnetdiscover, ibnetdiscover format
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/ibping.8.in.rst b/doc/rst/ibping.8.in.rst
new file mode 100644
index 0000000..8dd2e41
--- /dev/null
+++ b/doc/rst/ibping.8.in.rst
@@ -0,0 +1,86 @@
+======
+IBPING
+======
+
+--------------------------
+ping an InfiniBand address
+--------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibping [options] <dest lid | guid>
+
+DESCRIPTION
+===========
+
+ibping uses vendor mads to validate connectivity between IB nodes.
+On exit, (IP) ping like output is show. ibping is run as client/server.
+Default is to run as client. Note also that a default ping server is
+implemented within the kernel.
+
+
+OPTIONS
+=======
+
+**-c, --count**
+stop after count packets
+
+**-f, --flood**
+flood destination: send packets back to back without delay
+
+**-o, --oui**
+use specified OUI number to multiplex vendor mads
+
+**-S, --Server**
+start in server mode (do not return)
+
+
+Addressing Flags
+----------------
+
+.. include:: common/opt_L.rst
+.. include:: common/opt_G.rst
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
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+.. include:: common/opt_t.rst
+
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
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/ibrouters.8.in.rst b/doc/rst/ibrouters.8.in.rst
new file mode 100644
index 0000000..d6c8639
--- /dev/null
+++ b/doc/rst/ibrouters.8.in.rst
@@ -0,0 +1,57 @@
+=========
+IBROUTERS
+=========
+
+----------------------------------------
+show InfiniBand router nodes in topology
+----------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibrouters [options] [<topology-file>]
+
+DESCRIPTION
+===========
+
+ibrouters is a script which either walks the IB subnet topology or uses an
+already saved topology file and extracts the router nodes.
+
+OPTIONS
+=======
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/opt_t.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_z-config.rst
+
+.. include:: common/sec_portselection.rst
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+
+SEE ALSO
+========
+
+ibnetdiscover(8)
+
+DEPENDENCIES
+============
+
+ibnetdiscover, ibnetdiscover format
+
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/ibswitches.8.in.rst b/doc/rst/ibswitches.8.in.rst
new file mode 100644
index 0000000..3a99337
--- /dev/null
+++ b/doc/rst/ibswitches.8.in.rst
@@ -0,0 +1,55 @@
+==========
+IBSWITCHES
+==========
+
+----------------------------------------
+show InfiniBand switch nodes in topology
+----------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibswitches [options] [<topology-file>]
+
+DESCRIPTION
+===========
+
+ibswitches is a script which either walks the IB subnet topology or uses an
+already saved topology file and extracts the switch nodes.
+
+OPTIONS
+=======
+
+.. include:: common/opt_C.rst
+.. include:: common/opt_P.rst
+.. include:: common/opt_t.rst
+.. include:: common/opt_h.rst
+.. include:: common/opt_z-config.rst
+
+.. include:: common/sec_portselection.rst
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+.. include:: common/sec_node-name-map.rst
+
+SEE ALSO
+========
+ibnetdiscover(8)
+
+DEPENDENCIES
+============
+
+ibnetdiscover, ibnetdiscover format
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/ibhosts.8 b/man/ibhosts.8
deleted file mode 100644
index 462380f..0000000
--- a/man/ibhosts.8
+++ /dev/null
@@ -1,35 +0,0 @@
-.TH IBHOSTS 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibhosts \- show InfiniBand host nodes in topology
-
-.SH SYNOPSIS
-.B ibhosts
-[\-h] [<topology-file> | \-C ca_name \-P ca_port \-t(imeout) timeout_ms]
-
-.SH DESCRIPTION
-.PP
-ibhosts is a script which either walks the IB subnet topology or uses an
-already saved topology file and extracts the CA nodes.
-
-.SH OPTIONS
-.PP
-\-h      show the usage message
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-.SH SEE ALSO
-.BR ibnetdiscover(8)
-
-.SH DEPENDENCIES
-
-ibnetdiscover, ibnetdiscover format
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/ibnodes.8 b/man/ibnodes.8
deleted file mode 100644
index 509900b..0000000
--- a/man/ibnodes.8
+++ /dev/null
@@ -1,35 +0,0 @@
-.TH IBNODES 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibnodes \- show InfiniBand nodes in topology
-
-.SH SYNOPSIS
-.B ibnodes
-[\-h] [<topology-file> | \-C ca_name \-P ca_port \-t(imeout) timeout_ms]
-
-.SH DESCRIPTION
-.PP
-ibnodes is a script which either walks the IB subnet topology or uses an
-already saved topology file and extracts the IB nodes (CAs and switches).
-
-.SH OPTIONS
-.PP
-\-h      show the usage message
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-.SH SEE ALSO
-
-.BR ibnetdiscover(8)
-
-.SH DEPENDENCIES
-
-ibnetdiscover, ibnetdiscover format
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/ibping.8 b/man/ibping.8
deleted file mode 100644
index b5154af..0000000
--- a/man/ibping.8
+++ /dev/null
@@ -1,87 +0,0 @@
-.TH IBPING 8 "August 11, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibping \- ping an InfiniBand address
-
-.SH SYNOPSIS
-.B ibping
-[\-d(ebug)] [\-e(rr_show)] [\-v(erbose)] [\-G(uid)] [\-C ca_name]
-[\-P ca_port] [\-s smlid] [\-t(imeout) timeout_ms] [\-V(ersion)]
-[\-c ping_count] [\-f(lood)] [\-o oui] [\-S(erver)] [\-h(elp)]
-<dest lid | guid>
-
-.SH DESCRIPTION
-.PP
-ibping uses vendor mads to validate connectivity between IB nodes.
-On exit, (IP) ping like output is show. ibping is run as client/server.
-Default is to run as client. Note also that a default ping server is
-implemented within the kernel.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-c\fR
-stop after count packets
-.TP
-\fB\-f\fR, \fB\-\-flood\fR
-flood destination: send packets back to back without delay
-.TP
-\fB\-o\fR, \fB\-\-oui\fR
-use specified OUI number to multiplex vendor mads
-.TP
-\fB\-S\fR, \fB\-\-Server\fR
-start in server mode (do not return)
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
diff --git a/man/ibrouters.8 b/man/ibrouters.8
deleted file mode 100644
index 9c3ef68..0000000
--- a/man/ibrouters.8
+++ /dev/null
@@ -1,31 +0,0 @@
-.TH IBROUTERS 8 "May 30, 2007" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibrouters \- show InfiniBand router nodes in topology
-
-.SH SYNOPSIS
-.B ibrouters
-[\-h] [<topology-file> | \-C ca_name \-P ca_port \-t(imeout) timeout_ms]
-
-.SH DESCRIPTION
-.PP
-ibrouters is a script which either walks the IB subnet topology or uses an
-already saved topology file and extracts the Rt nodes.
-
-.SH OPTIONS
-.PP
-\-h      show the usage message
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-.SH SEE ALSO
-.BR ibnetdiscover(8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/ibswitches.8 b/man/ibswitches.8
deleted file mode 100644
index 038f8db..0000000
--- a/man/ibswitches.8
+++ /dev/null
@@ -1,35 +0,0 @@
-.TH IBSWITCHES 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibswitches\- show InfiniBand switch nodes in topology
-
-.SH SYNOPSIS
-.B ibswitches
-[\-h] [<topology-file> | \-C ca_name \-P ca_port \-t(imeout) timeout_ms]
-
-.SH DESCRIPTION
-.PP
-ibswitches is a script which either walks the IB subnet topology or uses an
-already saved topology file and extracts the switch nodes.
-
-.SH OPTIONS
-.PP
-\-h      show the usage message
-.PP
-\-C <ca_name>    use the specified ca_name.
-.PP
-\-P <ca_port>    use the specified ca_port.
-.PP
-\-t <timeout_ms> override the default timeout for the solicited mads.
-
-.SH SEE ALSO
-.BR ibnetdiscover(8)
-
-.SH DEPENDENCIES
-
-ibnetdiscover, ibnetdiscover format
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
