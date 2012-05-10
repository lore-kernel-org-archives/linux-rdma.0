From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/8] infiniband-diags: move man/ibcc[config|query] to rst
 documentation
Date: Wed, 9 May 2012 18:44:52 -0700
Message-ID: <20120509184452.542fc79f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                 |    4 +-
 configure.in                |    2 +
 doc/rst/ibccconfig.8.in.rst |   93 +++++++++++++++++++++++++++++++++++++++++++
 doc/rst/ibccquery.8.in.rst  |   89 +++++++++++++++++++++++++++++++++++++++++
 man/ibccconfig.8            |   89 -----------------------------------------
 man/ibccquery.8             |   85 ---------------------------------------
 6 files changed, 187 insertions(+), 175 deletions(-)
 create mode 100644 doc/rst/ibccconfig.8.in.rst
 create mode 100644 doc/rst/ibccquery.8.in.rst
 delete mode 100644 man/ibccconfig.8
 delete mode 100644 man/ibccquery.8

diff --git a/Makefile.am b/Makefile.am
index 0d0b379..21f5163 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -48,8 +48,10 @@ man_MANS = man/ibping.8 \
 		man/ibsysstat.8 \
 		man/ibfindnodesusing.8 \
 		man/ibrouters.8 man/check_lft_balance.8 man/ibcacheedit.8 \
-		man/ibstatus.8 man/ibccquery.8 man/ibccconfig.8 \
+		man/ibstatus.8 \
 		doc/man/ibaddr.8 \
+		doc/man/ibccconfig.8 \
+		doc/man/ibccquery.8 \
 		doc/man/dump_lfts.8 \
 		doc/man/dump_mfts.8 \
 		doc/man/iblinkinfo.8 \
diff --git a/configure.in b/configure.in
index 81426d4..0a456c1 100644
--- a/configure.in
+++ b/configure.in
@@ -207,6 +207,8 @@ AC_CONFIG_FILES([\
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
 	doc/man/ibaddr.8 \
+	doc/man/ibccconfig.8 \
+	doc/man/ibccquery.8 \
 	doc/man/dump_lfts.8 \
 	doc/man/dump_mfts.8 \
 	doc/man/iblinkinfo.8 \
diff --git a/doc/rst/ibccconfig.8.in.rst b/doc/rst/ibccconfig.8.in.rst
new file mode 100644
index 0000000..3ab31b6
--- /dev/null
+++ b/doc/rst/ibccconfig.8.in.rst
@@ -0,0 +1,93 @@
+==========
+IBCCCONFIG
+==========
+
+-------------------------------------
+configure congestion control settings
+-------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+ibccconfig [common_options] [-c cckey] <op> <lid|guid> [port]
+
+DESCRIPTION
+===========
+
+**ibccconfig**
+supports the configuration of congestion control settings on switches
+and HCAs.
+
+**WARNING -- You should understand what you are doing before using this tool.
+Misuse of this tool could result in a broken fabric.**
+
+OPTIONS
+=======
+
+Current supported operations and their parameters:
+  CongestionKeyInfo (CK) <lid|guid> <cckey> <cckeyprotectbit> <cckeyleaseperiod> <cckeyviolations>
+  SwitchCongestionSetting (SS) <lid|guid> <controlmap> <victimmask> <creditmask> <threshold> <packetsize> <csthreshold> <csreturndelay> <markingrate>
+  SwitchPortCongestionSetting (SP) <lid|guid> <portnum> <valid> <control_type> <threshold> <packet_size> <cong_parm_marking_rate> 
+  CACongestionSetting (CS) <lid|guid> <port_control> <control_map> <ccti_timer> <ccti_increase> <trigger_threshold> <ccti_min>
+  CongestionControlTable (CT) <lid|guid> <cctilimit> <index> <cctentry> <cctentry> ...
+
+**--cckey, -c, <cckey>**
+Specify a congestion control (CC) key.  If none is specified, a key of 0 is used.
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
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+
+
+EXAMPLES
+========
+
+::
+
+        ibccconfig SwitchCongestionSetting 2 0x1F 0x1FFFFFFFFF 0x0 0xF 8 0 0:0 1  # Configure Switch Congestion Settings
+        ibccconfig CACongestionSetting 1 0 0x3 150 1 0 0                          # Configure CA Congestion Settings to SL 0 and SL 1
+        ibccconfig CACongestionSetting 1 0 0x4 200 1 0 0                          # Configure CA Congestion Settings to SL 2
+        ibccconfig CongestionControlTable 1 63 0 0:0 0:1 ...                      # Configure first block of Congestion Control Table
+        ibccconfig CongestionControlTable 1 127 0 0:64 0:65 ...                   # Configure second block of Congestion Control Table
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+AUTHOR
+======
+
+Albert Chu
+        < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/doc/rst/ibccquery.8.in.rst b/doc/rst/ibccquery.8.in.rst
new file mode 100644
index 0000000..89b741c
--- /dev/null
+++ b/doc/rst/ibccquery.8.in.rst
@@ -0,0 +1,89 @@
+=========
+IBCCQUERY
+=========
+
+--------------------------------------
+query congestion control settings/info
+--------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+ibccquery [common_options] [-c cckey] <op> <lid|guid> [port]
+
+DESCRIPTION
+===========
+
+ibccquery support the querying of settings and other information related
+to congestion control.
+
+OPTIONS
+=======
+
+Current supported operations and their parameters:
+  CongestionInfo (CI) <addr>
+  CongestionKeyInfo (CK) <addr>
+  CongestionLog (CL) <addr>
+  SwitchCongestionSetting (SS) <addr>
+  SwitchPortCongestionSetting (SP) <addr> [<portnum>]
+  CACongestionSetting (CS) <addr>
+  CongestionControlTable (CT) <addr>
+  Timestamp (TI) <addr>
+
+
+**--cckey, -c <cckey>**
+Specify a congestion control (CC) key.  If none is specified, a key of 0 is used.
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
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
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
+
+        ibccquery CongestionInfo 3		# Congestion Info by lid
+        ibccquery SwitchPortCongestionSetting 3	# Query all Switch Port Congestion Settings
+        ibccquery SwitchPortCongestionSetting 3 1 # Query Switch Port Congestion Setting for port 1
+
+AUTHOR
+======
+
+Albert Chu
+        < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibccconfig.8 b/man/ibccconfig.8
deleted file mode 100644
index 3a49f0c..0000000
--- a/man/ibccconfig.8
+++ /dev/null
@@ -1,89 +0,0 @@
-.TH IBCCCONFIG 8 "Dec 1, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibccconfig \- configure congestion control settings
-
-.SH SYNOPSIS
-.B ibccconfig
-[\-d(ebug)] [\-G(uid)] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-h(elp)] [\-c cckey] <op> <lid|guid> [port]
-
-.SH DESCRIPTION
-.PP
-.B ibccconfig
-supports the configuration of congestion control settings on switches
-and HCAs.
-
-.B WARNING -- You should understand what you are doing before using this tool.  Misuse of this tool could result in a broken fabric.
-
-.SH OPTIONS
-
-.PP
-.TP
-Current supported operations and their parameters:
-  CongestionKeyInfo (CK) <lid|guid> <cckey> <cckeyprotectbit> <cckeyleaseperiod> <cckeyviolations>
-  SwitchCongestionSetting (SS) <lid|guid> <controlmap> <victimmask> <creditmask> <threshold> <packetsize> <csthreshold> <csreturndelay> <markingrate>
-  SwitchPortCongestionSetting (SP) <lid|guid> <portnum> <valid> <control_type> <threshold> <packet_size> <cong_parm_marking_rate> 
-  CACongestionSetting (CS) <lid|guid> <port_control> <control_map> <ccti_timer> <ccti_increase> <trigger_threshold> <ccti_min>
-  CongestionControlTable (CT) <lid|guid> <cctilimit> <index> <cctentry> <cctentry> ...
-
-.TP
-\fB\-c\-fR, \fB\-\-cckey\fR <cckey>
-Specify a congestion control (CC) key.  If none is specified, a key of 0 is used.
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
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
-.SH EXAMPLES
-
-.PP
-ibccconfig SwitchCongestionSetting 2 0x1F 0x1FFFFFFFFF 0x0 0xF 8 0 0:0 1    # Configure Switch Congestion Settings
-.PP
-ibccconfig CACongestionSetting 1 0 0x3 150 1 0 0          # Configure CA Congestion Settings to SL 0 and SL 1
-.PP
-ibccconfig CACongestionSetting 1 0 0x4 200 1 0 0          # Configure CA Congestion Settings to SL 2
-.PP
-ibccconfig CongestionControlTable 1 63 0 0:0 0:1 ...        # Configure first block of Congestion Control Table
-.PP
-ibccconfig CongestionControlTable 1 127 0 0:64 0:65 ...     # Configure second block of Congestion Control Table
-
-.SH AUTHOR
-.TP
-Albert Chu
-.RI < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibccquery.8 b/man/ibccquery.8
deleted file mode 100644
index f3e8149..0000000
--- a/man/ibccquery.8
+++ /dev/null
@@ -1,85 +0,0 @@
-.TH IBCCQUERY 8 "Aug 10, 2011" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibccquery \- query congestion control settings/info
-
-.SH SYNOPSIS
-.B ibccquery
-[\-d(ebug)] [\-G(uid)] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[\-V(ersion)] [\-h(elp)] [\-c cckey] <op> <lid|guid> [port]
-
-.SH DESCRIPTION
-.PP
-.Bibccquery support the querying of settings and other information related
-to congestion control.
-
-.SH OPTIONS
-
-.PP
-.TP
-Current supported operations and their parameters:
-  CongestionInfo (CI) <addr>
-  CongestionKeyInfo (CK) <addr>
-  CongestionLog (CL) <addr>
-  SwitchCongestionSetting (SS) <addr>
-  SwitchPortCongestionSetting (SP) <addr> [<portnum>]
-  CACongestionSetting (CS) <addr>
-  CongestionControlTable (CT) <addr>
-  Timestamp (TI) <addr>
-
-.TP
-\fB\-c\-fR, \fB\-\-cckey\fR <cckey>
-Specify a congestion control (CC) key.  If none is specified, a key of 0 is used.
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
-If a port and/or CA name is specified, the user request is
-attempted to be fulfilled, and will fail if it is not possible.
-
-.SH EXAMPLES
-
-.PP
-ibccquery CongestionInfo 3		# Congestion Info by lid
-.PP
-ibccquery SwitchPortCongestionSetting 3	# Query all Switch Port Congestion Settings
-.PP
-ibccquery SwitchPortCongestionSetting 3 1 # Query Switch Port Congestion Setting for port 1
-
-.SH AUTHOR
-.TP
-Albert Chu
-.RI < chu11-i2BcT+NCU+M@public.gmane.org >
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
