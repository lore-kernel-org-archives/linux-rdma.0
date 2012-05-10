From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/8] infiniband-diags: move man/dump_[ml]fts to rst
 documentation
Date: Wed, 9 May 2012 18:44:47 -0700
Message-ID: <20120509184447.fb235979.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                |    4 ++-
 configure.in               |    2 +
 doc/rst/dump_lfts.8.in.rst |   73 ++++++++++++++++++++++++++++++++++++++++++++
 doc/rst/dump_mfts.8.in.rst |   64 ++++++++++++++++++++++++++++++++++++++
 man/dump_lfts.8            |   51 ------------------------------
 man/dump_mfts.8            |   45 ---------------------------
 6 files changed, 142 insertions(+), 97 deletions(-)
 create mode 100644 doc/rst/dump_lfts.8.in.rst
 create mode 100644 doc/rst/dump_mfts.8.in.rst
 delete mode 100644 man/dump_lfts.8
 delete mode 100644 man/dump_mfts.8

diff --git a/Makefile.am b/Makefile.am
index 0eedbb9..0d0b379 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -45,11 +45,13 @@ man_MANS = man/ibping.8 \
 		man/ibportstate.8 man/ibroute.8 man/ibstat.8 \
 		man/ibswitches.8 man/ibtracert.8 man/perfquery.8 man/sminfo.8 \
 		man/smpdump.8 man/smpquery.8 man/saquery.8 man/vendstat.8 \
-		man/dump_lfts.8 man/dump_mfts.8 man/ibsysstat.8 \
+		man/ibsysstat.8 \
 		man/ibfindnodesusing.8 \
 		man/ibrouters.8 man/check_lft_balance.8 man/ibcacheedit.8 \
 		man/ibstatus.8 man/ibccquery.8 man/ibccconfig.8 \
 		doc/man/ibaddr.8 \
+		doc/man/dump_lfts.8 \
+		doc/man/dump_mfts.8 \
 		doc/man/iblinkinfo.8 \
 		doc/man/ibnetdiscover.8 \
 		doc/man/ibqueryerrors.8 \
diff --git a/configure.in b/configure.in
index ec7afac..81426d4 100644
--- a/configure.in
+++ b/configure.in
@@ -207,6 +207,8 @@ AC_CONFIG_FILES([\
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
 	doc/man/ibaddr.8 \
+	doc/man/dump_lfts.8 \
+	doc/man/dump_mfts.8 \
 	doc/man/iblinkinfo.8 \
 	doc/man/ibnetdiscover.8 \
 	doc/man/ibqueryerrors.8 \
diff --git a/doc/rst/dump_lfts.8.in.rst b/doc/rst/dump_lfts.8.in.rst
new file mode 100644
index 0000000..9b9ded2
--- /dev/null
+++ b/doc/rst/dump_lfts.8.in.rst
@@ -0,0 +1,73 @@
+============
+DUMP_LFTS.SH
+============
+
+-----------------------------------------
+dump InfiniBand unicast forwarding tables
+-----------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+
+SYNOPSIS
+========
+
+dump_lfts.sh [-h] [-D] [-C ca_name] [-P ca_port] [-t(imeout) timeout_ms] [>/path/to/dump-file]
+
+
+DESCRIPTION
+===========
+
+dump_lfts.sh is a script which dumps the InfiniBand unciast forwarding
+tables (MFTs) in the switch nodes in the subnet.
+
+The dump file format is compatible with loading into OpenSM using
+the -R file -U /path/to/dump-file syntax.
+
+OPTIONS
+=======
+
+**-D**
+dump forwarding tables using direct routed rather than LID routed SMPs
+
+**-h**
+show help
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
+.. include:: common/opt_t.rst
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
+**dump_mfts(8), ibroute(8), ibswitches(8), opensm(8)**
+
+
+AUTHORS
+=======
+
+Sasha Khapyorsky
+        < sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org >
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/dump_mfts.8.in.rst b/doc/rst/dump_mfts.8.in.rst
new file mode 100644
index 0000000..551effc
--- /dev/null
+++ b/doc/rst/dump_mfts.8.in.rst
@@ -0,0 +1,64 @@
+============
+DUMP_MFTS.SH
+============
+
+-------------------------------------------
+dump InfiniBand multicast forwarding tables
+-------------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+dump_mfts.sh [\-h] [\-D] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms] [>/path/to/file]
+
+DESCRIPTION
+===========
+
+dump_mfts.sh is a script which dumps the InfiniBand multicast
+forwarding tables (MFTs) in the switch nodes in the subnet.
+
+OPTIONS
+=======
+
+**-D**
+dump forwarding tables using direct routed rather than LID routed SMPs
+
+**-h**
+show help
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
+.. include:: common/opt_t.rst
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
+**dump_lfts(8), ibroute(8), ibswitches(8), opensm(8)**
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/dump_lfts.8 b/man/dump_lfts.8
deleted file mode 100644
index 1f5e1a7..0000000
--- a/man/dump_lfts.8
+++ /dev/null
@@ -1,51 +0,0 @@
-.TH DUMP_LFTS.SH 8 "May 21, 2007" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-dump_lfts.sh \- dump InfiniBand unicast forwarding tables
-
-.SH SYNOPSIS
-.B dump_lfts.sh
-[\-h] [\-D] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[>/path/to/dump-file]
-
-
-.SH DESCRIPTION
-.PP
-dump_lfts.sh is a script which dumps the InfiniBand unciast forwarding
-tables (MFTs) in the switch nodes in the subnet.
-
-The dump file format is compatible with loading into OpenSM using
-the -R file -U /path/to/dump-file syntax.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-D\fR
-dump forwarding tables using direct routed rather than LID routed SMPs
-.TP
-\fB\-h\fR
-show help
-.TP
-\fB\-C\fR <ca_name>
-use the specified ca_name.
-.TP
-\fB\-P\fR <ca_port>
-use the specified ca_port.
-.TP
-\fB\-t\fR <timeout_ms>
-override the default timeout for the solicited mads.
-
-.SH SEE ALSO
-.BR dump_mfts(8),
-.BR ibroute(8),
-.BR ibswitches(8),
-.BR opensm(8)
-
-.SH AUTHORS
-.TP
-Sasha Khapyorsky
-.RI < sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org >
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/dump_mfts.8 b/man/dump_mfts.8
deleted file mode 100644
index 885301e..0000000
--- a/man/dump_mfts.8
+++ /dev/null
@@ -1,45 +0,0 @@
-.TH DUMP_MFTS.SH 8 "May 21, 2007" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-dump_lfts.sh \- dump InfiniBand multicast forwarding tables
-
-.SH SYNOPSIS
-.B dump_mfts.sh
-[\-h] [\-D] [\-C ca_name] [\-P ca_port] [\-t(imeout) timeout_ms]
-[>/path/to/file]
-
-.SH DESCRIPTION
-.PP
-dump_mfts.sh is a script which dumps the InfiniBand multicast
-forwarding tables (MFTs) in the switch nodes in the subnet.
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-D\fR
-dump forwarding tables using direct routed rather than LID routed SMPs
-.TP
-\fB\-h\fR
-show help
-.TP
-\fB\-C\fR <ca_name>
-use the specified ca_name.
-.TP
-\fB\-P\fR <ca_port>
-use the specified ca_port.
-.TP
-\fB\-t\fR <timeout_ms>
-override the default timeout for the solicited mads.
-
-
-.SH SEE ALSO
-.BR dump_lfts(8),
-.BR ibroute(8),
-.BR ibswitches(8),
-.BR opensm(8)
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
