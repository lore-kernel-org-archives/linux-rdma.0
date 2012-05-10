From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 8/8] infiniband-diags: move
 man/check_lft_balance,ibcacheedit,ibstatus,ibidsverify to rst documentation
Date: Wed, 9 May 2012 18:45:26 -0700
Message-ID: <20120509184526.34bb4849.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org




Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am                        |   11 +++---
 configure.in                       |    4 ++
 doc/rst/check_lft_balance.8.in.rst |   52 +++++++++++++++++++++++++++++
 doc/rst/ibcacheedit.8.in.rst       |   59 +++++++++++++++++++++++++++++++++
 doc/rst/ibidsverify.8.in.rst       |   63 ++++++++++++++++++++++++++++++++++++
 doc/rst/ibstatus.8.in.rst          |   54 ++++++++++++++++++++++++++++++
 man/check_lft_balance.8            |   42 ------------------------
 man/ibcacheedit.8                  |   57 --------------------------------
 man/ibidsverify.8                  |   40 -----------------------
 man/ibstatus.8                     |   41 -----------------------
 10 files changed, 238 insertions(+), 185 deletions(-)
 create mode 100644 doc/rst/check_lft_balance.8.in.rst
 create mode 100644 doc/rst/ibcacheedit.8.in.rst
 create mode 100644 doc/rst/ibidsverify.8.in.rst
 create mode 100644 doc/rst/ibstatus.8.in.rst
 delete mode 100644 man/check_lft_balance.8
 delete mode 100644 man/ibcacheedit.8
 delete mode 100644 man/ibidsverify.8
 delete mode 100644 man/ibstatus.8

diff --git a/Makefile.am b/Makefile.am
index 807754b..f861000 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -40,9 +40,9 @@ sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
 		scripts/set_nodedesc.sh scripts/ibclearerrors scripts/ibclearcounters
 endif
 
-man_MANS = man/check_lft_balance.8 man/ibcacheedit.8 \
-		man/ibstatus.8 \
-		doc/man/ibaddr.8 \
+man_MANS = doc/man/ibaddr.8 \
+		doc/man/check_lft_balance.8 \
+		doc/man/ibcacheedit.8 \
 		doc/man/ibccconfig.8 \
 		doc/man/ibccquery.8 \
 		doc/man/dump_lfts.8 \
@@ -50,6 +50,7 @@ man_MANS = man/check_lft_balance.8 man/ibcacheedit.8 \
 		doc/man/iblinkinfo.8 \
 		doc/man/ibfindnodesusing.8 \
 		doc/man/ibhosts.8 \
+		doc/man/ibidsverify.8 \
 		doc/man/ibnetdiscover.8 \
 		doc/man/ibnodes.8 \
 		doc/man/ibping.8 \
@@ -58,6 +59,7 @@ man_MANS = man/check_lft_balance.8 man/ibcacheedit.8 \
 		doc/man/ibroute.8 \
 		doc/man/ibrouters.8 \
 		doc/man/ibstat.8 \
+		doc/man/ibstatus.8 \
 		doc/man/ibswitches.8 \
 		doc/man/ibsysstat.8 \
 		doc/man/ibtracert.8 \
@@ -67,8 +69,7 @@ man_MANS = man/check_lft_balance.8 man/ibcacheedit.8 \
 		doc/man/smpdump.8 \
 		doc/man/smpquery.8 \
 		doc/man/vendstat.8 \
-		doc/man/infiniband-diags.8 \
-		man/ibidsverify.8
+		doc/man/infiniband-diags.8
 
 # define this for the dist target
 compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
diff --git a/configure.in b/configure.in
index 20bb25c..70a3e90 100644
--- a/configure.in
+++ b/configure.in
@@ -207,11 +207,14 @@ AC_CONFIG_FILES([\
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
 	doc/man/ibaddr.8 \
+	doc/man/check_lft_balance.8 \
+	doc/man/ibcacheedit.8 \
 	doc/man/ibccconfig.8 \
 	doc/man/ibccquery.8 \
 	doc/man/dump_lfts.8 \
 	doc/man/dump_mfts.8 \
 	doc/man/ibhosts.8 \
+	doc/man/ibidsverify.8 \
 	doc/man/iblinkinfo.8 \
 	doc/man/ibfindnodesusing.8 \
 	doc/man/ibnetdiscover.8 \
@@ -222,6 +225,7 @@ AC_CONFIG_FILES([\
 	doc/man/ibroute.8 \
 	doc/man/ibrouters.8 \
 	doc/man/ibstat.8 \
+	doc/man/ibstatus.8 \
 	doc/man/ibswitches.8 \
 	doc/man/ibsysstat.8 \
 	doc/man/ibtracert.8 \
diff --git a/doc/rst/check_lft_balance.8.in.rst b/doc/rst/check_lft_balance.8.in.rst
new file mode 100644
index 0000000..96c41f2
--- /dev/null
+++ b/doc/rst/check_lft_balance.8.in.rst
@@ -0,0 +1,52 @@
+=================
+CHECK_LFT_BALANCE
+=================
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+--------------------------------------------------
+check InfiniBand unicast forwarding tables balance
+--------------------------------------------------
+
+
+SYNOPSIS
+========
+
+check_lft_balance.sh [-hRv]
+
+
+DESCRIPTION
+===========
+
+check_lft_balance.sh is a script which checks for balancing in Infiniband
+unicast forwarding tables.  It analyzes the output of
+**dump_lfts(8)** and **iblinkinfo(8)**
+
+OPTIONS
+=======
+
+**-h**
+        show help
+
+**-R**
+        Recalculate dump_lfts information, ie do not use the cached
+        information.  This option is slower but should be used if the diag
+        tools have not been used for some time or if there are other reasons to
+        believe that the fabric has changed.
+
+**-v**
+        verbose output
+
+SEE ALSO
+========
+
+**dump_lfts(8)**
+**iblinkinfo(8)**
+
+AUTHORS
+=======
+
+Albert Chu
+        < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/doc/rst/ibcacheedit.8.in.rst b/doc/rst/ibcacheedit.8.in.rst
new file mode 100644
index 0000000..5d61efb
--- /dev/null
+++ b/doc/rst/ibcacheedit.8.in.rst
@@ -0,0 +1,59 @@
+===========
+IBCACHEEDIT
+===========
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+---------------------------
+edit an ibnetdiscover cache
+---------------------------
+
+
+SYNOPSIS
+========
+
+ibcacheedit [options] <orig.cache> <new.cache>
+
+DESCRIPTION
+===========
+
+ibcacheedit allows users to edit an ibnetdiscover cache created through the
+**--cache** option in **ibnetdiscover(8)** .
+
+OPTIONS
+=======
+
+**--switchguid BEFOREGUID:AFTERGUID**
+        Specify a switchguid that should be changed.  The before and after guid
+        should be separated by a colon.  On switches, port guids are identical
+        to the switch guid, so port guids will be adjusted as well on switches.
+
+**--caguid BEFOREGUID:AFTERGUID**
+        Specify a caguid that should be changed.  The before and after guid
+        should be separated by a colon.
+
+**--sysimgguid BEFOREGUID:AFTERGUID**
+        Specify a sysimgguid that should be changed.  The before and after guid
+        should be spearated by a colon.
+
+**--portguid NODEGUID:BEFOREGUID:AFTERGUID**
+        Specify a portguid that should be changed.  The nodeguid of the port
+        (e.g. switchguid or caguid) should be specified first, followed by a
+        colon, the before port guid, another colon, then the after port guid.
+        On switches, port guids are identical to the switch guid, so the switch
+        guid will be adjusted as well on switches.
+
+Debugging flags
+---------------
+
+.. include:: common/opt_h.rst
+.. include:: common/opt_V.rst
+
+
+AUTHORS
+=======
+
+Albert Chu
+        < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/doc/rst/ibidsverify.8.in.rst b/doc/rst/ibidsverify.8.in.rst
new file mode 100644
index 0000000..3614333
--- /dev/null
+++ b/doc/rst/ibidsverify.8.in.rst
@@ -0,0 +1,63 @@
+===========
+IBIDSVERIFY
+===========
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: Open IB Diagnostics
+
+---------------------------------------------------
+validate IB identifiers in subnet and report errors
+---------------------------------------------------
+
+SYNOPSIS
+========
+
+ibidsverify.pl [-h] [-R]
+
+DESCRIPTION
+===========
+
+ibidsverify.pl is a perl script which uses a full topology file that was
+created by ibnetdiscover, scans the network to validate the LIDs and GUIDs
+in the subnet. The validation consists of checking that there are no zero
+or duplicate identifiers.
+
+Finally, ibidsverify.pl will also reuse the cached ibnetdiscover output from
+some of the other diag tools which makes it a bit faster than running
+ibnetdiscover from scratch.
+
+OPTIONS
+=======
+
+**-R**
+Recalculate the ibnetdiscover information, ie do not use the cached
+information.  This option is slower but should be used if the diag tools have
+not been used for some time or if there are other reasons to believe the
+fabric has changed.
+
+**-C <ca_name>**    use the specified ca_name.
+
+**-P <ca_port>**    use the specified ca_port.
+
+EXIT STATUS
+===========
+
+Exit status is 1 if errors are found, 0 otherwise.
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+
+SEE ALSO
+========
+
+**ibnetdiscover(8)**
+
+AUTHOR
+======
+
+Hal Rosenstock
+	< halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/doc/rst/ibstatus.8.in.rst b/doc/rst/ibstatus.8.in.rst
new file mode 100644
index 0000000..cfdac68
--- /dev/null
+++ b/doc/rst/ibstatus.8.in.rst
@@ -0,0 +1,54 @@
+========
+IBSTATUS
+========
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
+ibstatus [\-h] [devname[:port]]...
+
+DESCRIPTION
+===========
+
+ibstatus is a script which displays basic information obtained from the local
+IB driver. Output includes LID, SMLID, port state, link width active, and port
+physical state.
+
+OPTIONS
+=======
+
+.. include:: common/opt_h.rst
+
+**devname**
+        InfiniBand device name
+
+**portnum**
+        port number of InfiniBand device
+
+EXAMPLES
+========
+
+::
+        ibstatus                    # display status of all IB ports
+        ibstatus mthca1             # status of mthca1 ports
+        ibstatus mthca1:1 mthca0:2  # show status of specified ports
+
+SEE ALSO
+========
+
+**ibstat (8)**
+
+AUTHOR
+======
+
+Hal Rosenstock
+        < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/check_lft_balance.8 b/man/check_lft_balance.8
deleted file mode 100644
index 3eeca0d..0000000
--- a/man/check_lft_balance.8
+++ /dev/null
@@ -1,42 +0,0 @@
-.TH CHECK_LFT_BALANCE.SH 8 "March 1, 2008" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-check_lft_balance.sh \- check InfiniBand unicast forwarding tables balance
-
-.SH SYNOPSIS
-.B check_lft_balance.sh
-[-hRv]
-
-
-.SH DESCRIPTION
-.PP
-check_lft_balance.sh is a script which checks for balancing in Infiniband
-unicast forwarding tables.  It analyzes the output of
-.BR dump_lfts(8)
-and
-.BR iblinkinfo(8).
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-h\fR
-show help
-.TP
-\fB\-R\fR
-Recalculate dump_lfts information, ie do not use the cached
-information.  This option is slower but should be used if the diag tools have
-not been used for some time or if there are other reasons to believe that
-the fabric has changed.
-.TP
-\fB\-v\fR
-verbose output
-
-.SH SEE ALSO
-.BR dump_lfts(8),
-.BR iblinkinfo(8)
-
-.SH AUTHORS
-.TP
-Albert Chu
-.RI < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibcacheedit.8 b/man/ibcacheedit.8
deleted file mode 100644
index b977827..0000000
--- a/man/ibcacheedit.8
+++ /dev/null
@@ -1,57 +0,0 @@
-.TH IBCACHEEDIT 8 "Apr 15, 2010" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibcacheedit \- edit an ibnetdiscover cache
-
-.SH SYNOPSIS
-.B ibcacheedit
-[\-\-switchguid BEFOREGUID:AFTERGUID] [\-\-caguid BEFORE:AFTER]
-[\-\-sysimgguid BEFOREGUID:AFTERGUID] [\-\-portguid NODEGUID:BEFOREGUID:AFTERGUID]
-[\-h(elp)] <orig.cache> <new.cache>
-
-.SH DESCRIPTION
-.PP
-ibcacheedit allows users to edit an ibnetdiscover cache created through the
-\fB\-\-cache\fR option in
-.B ibnetdiscover(8).
-
-.SH OPTIONS
-
-.PP
-.TP
-\fB\-\-switchguid\fR BEFOREGUID:AFTERGUID
-Specify a switchguid that should be changed.  The before and after guid
-should be separated by a colon.  On switches, port guids are identical
-to the switch guid, so port guids will be adjusted as well on switches.
-.TP
-\fB\-\-caguid\fR BEFOREGUID:AFTERGUID
-Specify a caguid that should be changed.  The before and after guid
-should be separated by a colon.
-.TP
-\fB\-\-sysimgguid\fR BEFOREGUID:AFTERGUID
-Specify a sysimgguid that should be changed.  The before and after guid
-should be spearated by a colon.
-.TP
-\fB\-\-portguid\fR NODEGUID:BEFOREGUID:AFTERGUID
-Specify a portguid that should be changed.  The nodeguid of the port
-(e.g. switchguid or caguid) should be specified first, followed by a
-colon, the before port guid, another colon, then the after port guid.
-On switches, port guids are identical to the switch guid, so the
-switch guid will be adjusted as well on switches.
-
-.SH COMMON OPTIONS
-
-Most OpenIB diagnostics take the following common flags. The exact list of
-supported flags per utility can be found in the usage message and can be shown
-using the util_name -h syntax.
-
-# Debugging flags
-.PP
-\-h      show the usage message
-.PP
-\-V      show the version info.
-
-.SH AUTHORS
-.TP
-Albert Chu
-.RI < chu11-i2BcT+NCU+M@public.gmane.org >
diff --git a/man/ibidsverify.8 b/man/ibidsverify.8
deleted file mode 100644
index d617387..0000000
--- a/man/ibidsverify.8
+++ /dev/null
@@ -1,40 +0,0 @@
-.TH IBIDSVERIFY 8 "June 1, 2007" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibidsverify.pl \- validate IB identifiers in subnet and report errors
-
-.SH SYNOPSIS
-.B ibidsverify.pl
-[\-h] [\-R]
-
-.SH DESCRIPTION
-.PP
-ibidsverify.pl is a perl script which uses a full topology file that was
-created by ibnetdiscover, scans the network to validate the LIDs and GUIDs
-in the subnet. The validation consists of checking that there are no zero
-or duplicate identifiers.
-
-Finally, ibidsverify.pl will also reuse the cached ibnetdiscover output from
-some of the other diag tools which makes it a bit faster than running
-ibnetdiscover from scratch.
-
-.SH OPTIONS
-.PP
-.TP
-\fB\-R\fR
-Recalculate the ibnetdiscover information, ie do not use the cached
-information.  This option is slower but should be used if the diag tools have
-not been used for some time or if there are other reasons to believe the
-fabric has changed.
-
-.SH EXIT STATUS
-
-Exit status is 1 if errors are found, 0 otherwise.
-
-.SH SEE ALSO
-.BR ibnetdiscover(8)
-
-.SH AUTHOR
-.TP
-Hal Rosenstock
-.RI < halr-smomgflXvOZWk0Htik3J/w@public.gmane.org >
diff --git a/man/ibstatus.8 b/man/ibstatus.8
deleted file mode 100644
index c4b3831..0000000
--- a/man/ibstatus.8
+++ /dev/null
@@ -1,41 +0,0 @@
-.TH IBSTATUS 8 "July 25, 2006" "OpenIB" "OpenIB Diagnostics"
-
-.SH NAME
-ibstatus \- query basic status of InfiniBand device(s)
-
-.SH SYNOPSIS
-.B ibstatus
-[\-h] [devname[:port]]...
-
-.SH DESCRIPTION
-.PP
-ibstatus is a script which displays basic information obtained from the local
-IB driver. Output includes LID, SMLID, port state, link width active, and port
-physical state.
-
-.SH OPTIONS
-
-.PP
-.TP
-devname
-InfiniBand device name
-.TP
-portnum
-port number of InfiniBand device
-
-.SH EXAMPLES
-
-.PP
-ibstatus                # display status of all IB ports
-.PP
-ibstatus mthca1         # status of mthca1 ports
-.PP
-ibstatus mthca1:1 mthca0:2      # show status of specified ports
-
-.SH SEE ALSO
-.BR ibstat (8)
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
